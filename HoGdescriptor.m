function [hog,CellHists]=HoGdescriptor(ginthist)
%%-------------------------------------------------------------------------
% Explanation :
%           This function computes the HoG descriptor for a given integral
%           image of each bin. The overall length of a feature vector for a
%           given patch is 3780x1.
%%-------------------------------------------------------------------------
% Extract the detection window and divide each block to 2x2 cells
[numrows,numcols,numbins]=size(ginthist);
% Det_Window=imresize(Data,[20 20],'bilinear');             % Upsample

% Pad the image with zeros
Det_Window = ginthist;
% Det_Window = padarray(Det_Window,[1,1]);

% Compute the number cells horizontally and vertically (should be 8 x 16).    
numHorizCells = 8;
numVertCells = 8;
cellSize = 4;

% Compute histogram for each cell in the detection window
% Create a three dimensional matrix to hold the histogram for each cell.
CellHists = zeros(numVertCells, numHorizCells, numbins);
for row=0:numVertCells-1
    % Compute the row number in the 'img' matrix corresponding to the top
    % of the cells in this row. Add 1 since the matrices are indexed from 1.
    x1 = (row * cellSize + 1);
    x2 = x1 + cellSize;

    for col=0:numHorizCells-1
        
        % Compute the indices of the pixels within this cell.
        y1 = col * cellSize + 1;
        y2 = y1 + cellSize;
        
        % Compute the histogram using Integral Images
        CellHists(row+1,col+1,:)=Det_Window(x2,y2,:)-Det_Window(x2,y1,:)...
            -Det_Window(x1,y2,:)+Det_Window(x1,y1,:); 
    
    end
end

% Normalize histogram with respect to blocks they belong to
hog=[];
for row=1:numVertCells-1    
    for col=1:numHorizCells-1
        
        % Get histograms for the cells in this block. (4 cells in a Block)
        blockHists = CellHists(row : row + 1, col : col + 1, :);
        
        % Put all the histogram values into a single vector (nevermind the 
        % order), and compute the magnitude.
        % Add a small amount to the magnitude to ensure that it's never 0.
        magnitude = norm(blockHists(:)) + 0.01;
    
        % Divide all of the histogram values by the magnitude to normalize 
        % them.
        normalized = blockHists / magnitude;
        
        % Append the normalized histograms to our descriptor vector.
        hog = [hog; normalized(:)];
    
    end
end

