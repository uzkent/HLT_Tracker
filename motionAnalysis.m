function motionAnalysis(tt,actPos,display_image)
% -------------------------------------------------------------------------
%   Explanation:
%       This function draws the actual and estimated
%       trajectories for the target of interest.
% -------------------------------------------------------------------------
figure(2)
imshow(display_image);
hold on

% Actual Positions
act = cell2mat(actPos');
plot(act(:,1),act(:,2),'g','Linewidth',2);

% Estimated Positions
est = cell2mat(tt.x);
plot(est(1,2:end),est(2,2:end),'b','Linewidth',2);