function [detect]=adjustblobs(detect)
%% THIS FUNCTION ADJUSTS THE DETECTIONS ACCORDINGLY TO BE USED FOR TRACKING
b_size=size(detect,1);
for i=1:b_size;
    rows=size(detect,1);
    if detect(i,3)>5.95 && detect(i,4)<5.95
      % First Partition
      detect(i,1)=detect(i,1)+(detect(i,3)/2);
      detect(rows+1,1)=detect(i,1)-2*(detect(i,3)/2);          
      detect(i,3)=detect(i,3)/2;
      detect(rows+1,3)=detect(i,3);
      % Second Partition;
      detect(rows+1,2)=detect(i,2);
      detect(rows+1,4)=detect(i,4);
      detect(rows+1,5)=detect(i,5);          
      % Draw the rectangular on the detected image
%       DrawRectangle([detect(i,1),detect(i,2),2*abs(detect(i,3)),2*abs(detect(i,4)),-detect(i,5)],'r-');
%       DrawRectangle([detect(rows+1,1),detect(rows+1,2),2*abs(detect(rows+1,3)),2*abs(detect(rows+1,4)),-detect(rows+1,5)],'r-');
   elseif detect(i,3)<5.95 && detect(i,4)>5.95
      % First Partition
      detect(i,1)=detect(i,1)+(detect(i,3)/2);
      detect(rows+1,1)=detect(i,1)-2*(detect(i,3)/2);          
      detect(i,3)=detect(i,3)/2;
      detect(rows+1,3)=detect(i,3);
      % Second Partition;
      detect(i,2)=detect(i,2)+detect(i,4)/2;                    
      detect(rows+1,2)=detect(i,2)-2*detect(i,4)/2;
      detect(i,4)=detect(i,4)/2;
      detect(rows+1,4)=detect(i,4);          
      detect(rows+1,5)=detect(i,5);          
      % Draw the rectangular on the detected image
%       DrawRectangle([detect(i,1),detect(i,2),2*abs(detect(i,3)),2*abs(detect(i,4)),-detect(i,5)],'r-');
%       DrawRectangle([detect(rows+1,1),detect(rows+1,2),2*abs(detect(rows+1,3)),2*abs(detect(rows+1,4)),-detect(rows+1,5)],'r-');
   elseif detect(i,3)>5.95 && detect(i,4)>5.95
      % First Partition
      detect(rows+1,1)=detect(i,1);          
      detect(i,3)=detect(i,3)/2;
      detect(rows+1,3)=detect(i,3);
      % Second Partition;
      detect(i,2)=detect(i,2)+detect(i,4)/2;                    
      detect(rows+1,2)=detect(i,2)-2*detect(i,4)/2;
      detect(i,4)=detect(i,4)/2;
      detect(rows+1,4)=detect(i,4);   
      detect(rows+1,5)=detect(i,5);          
      % Draw the rectangular on the detected image
%       DrawRectangle([detect(i,1),detect(i,2),2*abs(detect(i,3)),2*abs(detect(i,4)),-detect(i,5)],'r-');
%       DrawRectangle([detect(rows+1,1),detect(rows+1,2),2*abs(detect(rows+1,3)),2*abs(detect(rows+1,4)),-detect(rows+1,5)],'r-');
    else
%       DrawRectangle([detect(i,1),detect(i,2),2*abs(detect(i,3)),2*abs(detect(i,4)),-detect(i,5)],'r-');
   end
end
