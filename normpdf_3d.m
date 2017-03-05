function y = normpdf_3d(x,mu,sigma)

%   NORMPDF_3D Normal probability density function (pdf) for 3D vectors.
% 
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     
%
%   Default values for MU and SIGMA are 0 and 1 respectively.


if nargin < 3, 
    sigma = eye(3);
end

if nargin < 2;
    mu = [0; 0; 0];
end

if nargin < 1, 
    error('There is no input argument');
end

% check for the size of the input, must be an array of 3-d vectors
dim = size(x);
if (dim(1) ~= 3)
    error('Requires x to be an array of 3d vectors.');
end

[X1,X2,X3] = meshgrid([x(3,:)],[x(2,:)],[x(1,:)]);
y = mvnpdf([X1(:) X2(:) X3(:)],mu,sigma);
y = reshape(y,length(x(3,:)),length(x(2,:)), length(x(1,:)));





