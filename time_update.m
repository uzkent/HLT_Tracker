function [model,mean_est,sigval] = time_update(model,X,sig,i,~)
%% THIS FUNCTION PERFORMS THE TIME UPDATE FOR THE STATE SPACE MATRIX
%% IF X is a cell array, convert it to a numerical array
if size(X,1)+size(X,2)==2
    X=cell2mat(X');
end
%% Form an appropriate X for the propagation
if size(X,1)~=model.fn
    X=X';
end

%% PROPAGATE KERNELS BASED ON THE INTERSECTION MASK
[mean_est,sigval]=CVmodel(model,X,sig);     % Apply the CV Model
% 
% if model.matrix==1
%     if c == 1     % Draw the components propagated by the Stop Model
%        plot(mean.c(1),mean.c(2),'o','Linewidth',1,'MarkerEdgeColor','r','MarkerFaceColor','k','MarkerSize',3)
%     elseif c == 2 %Draw the components propogated by the CT or CV Models 
%        plot(mean.c(1),mean.c(2),'o','Linewidth',1,'MarkerEdgeColor','g','MarkerFaceColor','k','MarkerSize',3)
%     else          % Draw the components propagated by the CA Model
%        plot(mean.c(1),mean.c(2),'o','Linewidth',1,'MarkerEdgeColor','r','MarkerFaceColor','k','MarkerSize',3)
%     end
% end