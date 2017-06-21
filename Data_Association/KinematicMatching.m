function [k_dist,k_index] = KinematicMatching(target,time,j,nloc);
%% THIS FUNCTION PERFORMS KINEMATIC ASSOCIATION
S = target.S_predic{j,time}(1:2,1:2);
for i = 1:size(nloc,1);
    r = nloc(i,1:2) - target.Z_predic{j,time}(1:2)';
    d(i) = sqrt(r * inv(S) * r');  % Maholanobis Distance
end
[k_dist, k_index] = min(d);  % Get the one with minimum cost