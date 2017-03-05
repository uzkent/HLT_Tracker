function [C] = hCov(M)

[rows, cols, bands] = size(M);
% Remove mean from data
u = mean(mean(M,2),1);

covariance = zeros(bands,bands);
for i = 1:rows
    for j = 1:cols
        M_Sub = M(i,j,:)-u;
    end
    M_Sub = reshape(M_Sub,bands,1);
    covariance = covariance + M_Sub*M_Sub';
end

C = (covariance)/(rows*cols-1);