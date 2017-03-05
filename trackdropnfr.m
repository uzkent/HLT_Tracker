function [target]=trackdropnfr(target,time)
%% DROP THE TRACKS LOST FOR N CONSECUTIVE NUMBER OF FRAMES
cols=size(target.disindex,2);  % Get the time step 
rows=size(target.disindex,1);  % Get the number of tracks
dropterm=25;     % Number of frames for drop criteria
%% If it has N number of columns
if cols==dropterm   
   for i=1:rows
       dis=target.disindex(i,:);    % Get the IDs from disindex
       B=tabulate(dis);         % See if it matches the criteria
       if isempty(find(B(:,2)==dropterm))==1
          target.real_disindex(i,time)=0;
       else
          target.real_disindex(i,time)=find(B(:,2)==dropterm);  
       end
   end
end
%% If it has less then N number of columns
if cols<dropterm
   target.real_disindex(1:rows,time)=0;
end

%% If it has more then N number of columns
if cols>dropterm
   for i=1:rows
       dis=target.disindex(i,end-2:end);    % Get IDs from disindex
       B=tabulate(dis);     % See if it matches the criteria
       if isempty(find(B(:,2)==dropterm))==1
          target.real_disindex(i,time)=0;
       else
          target.real_disindex(i,time)=find(B(:,2)==dropterm);
       end
   end
end