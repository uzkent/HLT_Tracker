function [pg, dpgdx, ddpgdx, dpgdmu, dpgdsig] = GaussianPDF(x,mu,sig)

r = x - [mu]';
pg = getLikelihood(r, sig);
isig = pinv(sig);

dpgdmu = isig*r.* pg;
%dpgdsig = 1/2 .* (isig*(r*r')*isig - isig) .* pg;
dpgdx = -dpgdmu;
%ddpgdx = 2.*dpgdsig;
dpgdsig = 1/2 .* (isig*(r*r')*isig).* pg;
ddpgdx=(isig*(r*r')*isig - isig) .* pg;