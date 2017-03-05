function [mean_dist]=evalspec(data_N,data)
%% THIS ROUTINE EVALUATES THE SPECTRAL QUALITY OF NOISE ADDED IMAGE
% data = truth spectral image, data_N = measured spectral image
[rows,cols,bands]=size(data_N);
dist = zeros(rows,cols);
for i=1:rows
    for j=1:cols
        dist(i,j)=samest(reshape(data_N(i,j,:),bands,1),reshape(data(i,j,:),bands,1));
    end
end
mean_dist=mean(mean(dist));