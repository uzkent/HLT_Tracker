function y = hxSquaredRoot_jac(x,model)

%y = [2*x(1) 2*x(2) 2*x(3)]./(2*sqrt(x(1).^2+x(2).^2+x(3).^2));
%y = [ x(1)/(x(1)^2 + x(2)^2 + x(3)^2)^(1/2), x(2)/(x(1)^2 + x(2)^2 + x(3)^2)^(1/2), x(3)/(x(1)^2 + x(2)^2 + x(3)^2)^(1/2)];
%% Calculate h matrix
y=eye(4,model.fn);
%y=y(1:4,:);