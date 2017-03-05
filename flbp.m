%%
% Implementation of Fuzzy LBP also called Soft LBP, introduced in [1] and
% [2].
%
% [1] Ahonen, T.; Pietik, M. & Pietikäinen, M.
% Soft histograms for local binary patterns
% In Proceedings of the Finnish signal processing symposium, FINSIG 2007,
% 2007, 1-4
%
% [2] Iakovidis, D. K.; Keramidas, E. G. & Maroulis, D.
% Fuzzy Local Binary Patterns for Ultrasound Texture Characterization
% Image Analysis and Recognition, Springer Berlin / Heidelberg,
% 2008, 5112, 750-759 DIO: 10.1007/978-3-540-69812-8
%
% --
% 2011-11-28 - Gustaf Kylberg, gustaf@cb.uu.se
%
%

function result = flbp(varargin) % image,radius,neighbors,fuzziness,mapping,mode)

% Check number of input arguments.
narginchk(1,6);

image = varargin{1};
d_image=double(image);

if nargin ==1
    spoints=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
    neighbors=8;
    mapping=0;
    fuzziness=5;
    mode='h';
elseif nargin==2
    spoints=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
    neighbors=8;
    mapping=0;
    fuzziness=varargin{2};
    mode='h';
elseif nargin >= 5 && isstruct(varargin{5})
    radius=varargin{2};
    neighbors=varargin{3};
    fuzziness=varargin{4};
    
    spoints=zeros(neighbors,2);
    
    % Angle step.
    a = 2*pi/neighbors;
    
    for i = 1:neighbors
        spoints(i,1) = -radius*sin((i-1)*a);
        spoints(i,2) = radius*cos((i-1)*a);
    end
    
    if(nargin >= 5)
        mapping=varargin{5};
        if(isstruct(mapping) && mapping.samples ~= neighbors)
            error('Incompatible mapping');
        end
    else
        mapping=0;
    end
    
    if(nargin == 6)
        mode = varargin{6};
        
    else
        mode='h';
    end
    
else
    error('Input arguments');
end


% Determine the dimensions of the input image.
[ysize xsize] = size(image);

miny=min(spoints(:,1));
maxy=max(spoints(:,1));
minx=min(spoints(:,2));
maxx=max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
origy=1-floor(min(miny,0));
origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
    error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% Fill the center pixel matrix C.
centerPixels = double(image(origy:origy+dy,origx:origx+dx));
% d_C = double(C);

bins = 2^neighbors;

% Initialize the result matrix with zeros.
% result=zeros(dy+1,dx+1);
neighbourimage = zeros([size(centerPixels) neighbors]);

%% Compute the neighbour image
for m = 1:neighbors %parfor
    y = spoints(m,1)+origy;
    x = spoints(m,2)+origx;
    % Calculate floors, ceils and rounds for the x and y.
    fy = floor(y); cy = ceil(y); ry = round(y);
    fx = floor(x); cx = ceil(x); rx = round(x);
    % Check if interpolation is needed.
    if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
        % Interpolation is not needed, use original datatypes
        N = image(ry:ry+dy,rx:rx+dx);
        neighbourimage(:,:,m) = N;
        %     D = N >= C;
    else
        % Interpolation needed, use double type images
        ty = y - fy;
        tx = x - fx;
        
        % Calculate the interpolation weights.
        w1 = (1 - tx) * (1 - ty);
        w2 =      tx  * (1 - ty);
        w3 = (1 - tx) *      ty ;
        w4 =      tx  *      ty ;
        % Compute interp1olated pixel values
        N = w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
            w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx);
        neighbourimage(:,:,m) = N;
    end
end

histogram = zeros(1,bins);

%% Build matrix where rows are digits in the binary number, typically 256x8
% for N=8.
codes = 0:2^neighbors-1;
codeStrs = dec2base(codes,2,neighbors); % char array with binary numbers

codeBitwise = double(codeStrs);
codeBitwise(codeBitwise==49) = 1;
codeBitwise(codeBitwise==48) = 0;
codeBitwise = logical(codeBitwise);

%% for all neighbourhoods asign contribution to histogram
ni = neighbourimage(:);
neighbourimage = reshape(ni,[size(neighbourimage,1)*...
    size(neighbourimage,2),...
    size(neighbourimage,3)]);

centerPixels = centerPixels(:);

histogram = zeros(1,bins);

for i = 1:size(neighbourimage,1)
    
    % vilka bins kan inte få bidrag, jo de som har 0:r där 1_or är fixa (övertröskeln)
    over = neighbourimage(i,:)>(centerPixels(i)+fuzziness);
    under = neighbourimage(i,:)<(centerPixels(i)-fuzziness);
    
    overIdx = neighbors -find(over)+1; % har 1:or i dessa positioner
    underIdx = neighbors -find(under)+1; % har 0:or i dessa positioner
    
    fix_1 = logical(sum(codeBitwise(:,overIdx),2)==length(overIdx));
    fix_0 = logical(sum(~codeBitwise(:,underIdx),2)==length(underIdx));
    
    bins = find(fix_1.*fix_0);
    
    for k = 1:length(bins)
        
        histogram(bins(k)) = histogram(bins(k)) + single_flbp(...
            neighbourimage(i,:),...
            centerPixels(i),...
            fuzziness,...
            neighbors,...
            codeBitwise(bins(k),:)...
            );
    end
    
end

%% Apply mapping if it is defined

if isstruct(mapping)
    newHist = zeros(size(histogram))-1;
    for i = 1:length(mapping.table)
        if newHist(mapping.table(i)+1)==-1
            newHist(mapping.table(i)+1) = histogram(i);
        else
            newHist(mapping.table(i)+1) = ...
                newHist(mapping.table(i)+1) + histogram(i);
        end
    end
    newHist(newHist==-1) = [];
    result = newHist;
else
    result = histogram;
end

if (strcmp(mode,'nh'))
    result=result/sum(result);
end


end

%% eq 7 in [1]- Contribution of a single pixel position to one bin
function out = single_flbp(g_p,g_c,d,P,codeBitWise)
% -IN-
% g_p   - array with values of the sampling points
% g_c   - value of center pixel.
% d     - fuzzy parameter
% P     - number of samples
% codeBitWise - cuttent code, as an array, bit by bit
% -OUT-
% out   - contribution from one single pixel position to one bin
out = 1;

for n = 1:P
    out = out * ...
        (codeBitWise(end+1-n)*f1(g_p(n),g_c,d) + ...
        (1-codeBitWise(end+1-n))*f0(g_p(n),g_c,d));
end

end

%% eq. 5 in [1]- belongingness function f1
% m = f1(p,pc,d)
%
% -IN-
% p     - intensity value of sample point
% pc    - intensity value of center point
% d     - width of fuzzy interval
%
% -OUT-
% m     - membership [0 1]
function m = f1(p,pc,d)
z = p-pc;
if(z<=-d)
    m = 0;
elseif(z>=d)
    m = 1;
elseif(d~=0) % d~=0
    m = 0.5+0.5*z/d;
else
    m = 1;
end
end % end of function f1

%% eq 6 in [1]- belongingness function f0
function m = f0(p,pc,T)
m = 1 - f1(p,pc,T);
end % end of function f0


