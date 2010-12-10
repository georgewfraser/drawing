function [y,yParts] = constructLaggedFilter(x,lag,m,nTerms)
% x ~ values relative to sample point
% lag ~ amount to shift filter
% m ~ maximum lag distance we will ever use
% nTerms ~ number of basis functions to use
yParts = zeros(numel(x),nTerms*2+1);
for k=-nTerms:nTerms
    cosineFunction = exp(i*k*pi*x/m)*sqrt(pi/2)/m;
    
    yParts(:,k+nTerms+1) = alpha(-k*pi/m,lag)*cosineFunction;
end
y = sum(yParts,2);
end

function y = alpha(w,lag)
y = (cos(lag*w)+i*sin(lag*w))*(sinc(pi-w/2)+sinc(pi+w/2)+2*sinc(w/2))/2/sqrt(2*pi);
end

function y = beta(k,m,lag