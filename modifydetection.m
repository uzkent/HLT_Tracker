function [target,counter]=modifydetection(target,boundary,time,counter)
%% MODIFIES THE DETECTED TARGETS TO BE USED FOR TRACKING PURPOSE
% Check if there is any detected objects
k=1;
for j = 1:boundary.bndrSize(1)
    bnd= boundary.boundaries{j};
    RB = max(bnd);
    LT = min(bnd);
%     % Find the right side edges coordinates
%     [RSUP_X,index]=max(bnd(:,1));
%     RSUP_Y=bnd(index,2);
%     [RSDOWN_X,index]=min(bnd(:,2));
%     RSDOWN_Y=bnd(index,1);
%     
%     % Find the left side edges coordinates
%     [LSUP_X,index]=min(bnd(:,1));
%     LSUP_Y=bnd(index,2);
%     [RSDOWN_X,index]=min(bnd(:,2));
%     RSDOWN_Y=bnd(index,1);
%     
    
    num=(RB(1)-LT(1))*(RB(2)-LT(2));
    % Transfer the detected objects to the global parameter
    if (RB(1)-LT(1))>0&&(RB(2)-LT(2))>0
       %rectangle('Position',[LT(2),LT(1),RB(2)-LT(2),RB(1)-LT(1)],'EdgeColor','g','LineWidth',1);
       target.detect{time+1}(k,:)=[((RB(2)-LT(2))/2+LT(2)),((RB(1)-LT(1))/2+LT(1)),(RB(2)-LT(2))/2,(RB(1)-LT(1))/2];
       % Adjust the ones detected as large targets
       [target,k]=adjustdetections(target,time,k);    
       k=k+1;  % Increment k
    end
end

% Increment the counter parameter  
if j>0
   counter=counter+1; 
end
