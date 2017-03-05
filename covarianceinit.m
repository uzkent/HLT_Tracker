function [model]=covarianceinit(model)
% This function creates the covariance matrixes for the gaussian components
for i=1:model.n
    model.sig{i}=eye(model.fn)*50;
    model.sig{i}(5,5)=300;
    model.sig{i}(6,6)=300;
end