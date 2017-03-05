function l = getLikelihood(r, A)
%% THIS FUNCTION UPDATES THE MEASUREMENT WEIGHTS BY EQUATING THE ZERO MOMENT OF EACH GAUSSIAN DISTRUBUTION
l = exp(-r'*inv(A*10)*r/2)/sqrt((2*pi)^7*det(A*10));  % Update the weight
if isinf(l)==1
    l=10^-5;
end