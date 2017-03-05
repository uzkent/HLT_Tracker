function [Weight]=assignweight(model)
%% THIS FUNCTION ASSIGNS THE WEIGHTS TO THE CORRESPONDING COMPONENTS
%Assign weight to the first component
Weight.initial(1) = 1/model.n;
%Assign weights to remaining components
for i = 2:model.n
    Weight.initial(i) = (1-Weight.initial(1))/(model.n-1);
end



