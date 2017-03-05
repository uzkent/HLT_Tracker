function meanval = avoidoutfowkernel(meanval,model)
%% Avoid components to get out of the frame
if meanval(1)>model.im_res(2)-10
   meanval(1)=model.im_res(2)-10;
elseif meanval(1)<10
    meanval(1)=10;
else 
end
if meanval(2)>model.im_res(1)-10
   meanval(2)=model.im_res(1)-10;
elseif meanval(2)<10
    meanval(2)=10;
else 
end