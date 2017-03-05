 function  nim=hnorm(im)
%% THIS FUNCTION NORMALIZES THE HYPERSPECTRAL IMAGES
[m,n,p]=size(im);      % Get the size of the hyperspectral image
nim=zeros(m,n,p);      % Initiate a parameter to store normalized image
% Normalize the bands
immin = min(min(im));    % Find the minimum of each band
immax = max(max(im));    % Find the maximum of each band
for i=1:p
    nim(:,:,i) = (im(:,:,i) - immin(i)) ./ (immax(i) - immin(i));    % Normalize each band
end