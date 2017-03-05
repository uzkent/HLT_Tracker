function [target]=sampling(target,model,mean,hsi,time)
%% PERFORM ADAPTIVE SAMPLING BASED ON THE LOCATION OF THE COMPONENTS
% Estimate the orientation angle
theta=atand(mean(6)/mean(5));
mu=abs(mean);
target.row_size=ceil(max(mu(2)-mu(4),1):min(mu(2)+mu(4),394));
target.col_size=ceil(max(mu(1)-mu(3),1):min(mu(1)+mu(3),573));
target.top_left=[target.row_size(1) target.col_size(1)];
target.bottom_right=[target.row_size(end) target.col_size(end)];
nbands=model.nbands;   %  Number of bands in the frame

%% SAMPLE THE GAUSSIANS 
% ---------------------------------------------------------------------------------
% IF THE TARGET IS IN THE INTERSECTION
% % % ---------------------------------------------------------------------------------
% if (abs(theta)>15 && abs(theta)<75) % Check orientation angle if it is really turning
%     [target]=diagonal_sampling(target,time,mu,hsi,nbands,theta); % Diagonal sampling
%     % sample_assign{i}='Diagonal';
% elseif abs(theta)*180/pi>75
%     [target]=vertical_sampling(target,time,hsi,nbands);  % vertical sampling
%     % sample_assign{i}='Horizontal';
% else 
    [target]=horizontal_sampling(model,target,time,hsi); % horizontal sampling
%    % sample_assign{i}='Vertical';
% end

