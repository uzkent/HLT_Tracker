function [margPdfx1x2] = margPdf(mu,sig,domain,index)

mu = [mu{:,index}]';
sig = [sig{index}];

% [X1,X2] = meshgrid(domain.x(1,:),domain.x(2,:));
% F = mvnpdf([X1(:) X2(:)],[mu(1) mu(2)],[sig(1,1) sig(1,2);sig(2,1) sig(2,2)]);
%     
% F = reshape(F,length(domain.x(1,:)),length(domain.x(2,:))); %length(repmat(xint(ct),1,domain.no_points)));
% margPdfx1x2 = F;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [X2,X3] = meshgrid(domain.x(2,:),domain.x(3,:));
% 
% F = mvnpdf([X2(:) X3(:)],[mu(2) mu(3)],[sig(2,2) sig(2,3);sig(3,2) sig(3,3)]);
%   
% F = reshape(F,length(domain.x(2,:)),length(domain.x(3,:))); %length(repmat(xint(ct),1,domain.no_points)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[X2,X3] = meshgrid(domain.x(2,:),domain.x(3,:));
for i = 1:domain.no_points
    for j = 1:domain.no_points
        F(i,j) = getLikelihood2D(([X2(i,j) X3(i,j)]-[mu(2) mu(3)])',[sig(2,2) sig(2,3);sig(3,2) sig(3,3)]);
    end
end
margPdfx1x2 = F;