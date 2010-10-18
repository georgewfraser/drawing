function [coeff, factors] = rateFactorAnalysis(rate, n)
X = unravelAll(rate);
C = princomp(X);
C = rotatefactors(C(:,1:n),'Maxit',10000);
X = bsxfun(@minus,X,mean(X));
F = X*C;

factors = struct();
for iif=1:n
    name = sprintf('factor%0.2d',iif);
    factors.(name) = reshape(F(:,iif),[16 20]);
end

coeff = cell(size(rate));
count = 0;
for day=1:length(rate)
    coeff{day} = struct();
    fields = fieldnames(rate{day});
    for iif=1:length(fields)
        count = count+1;
        coeff{day}.(fields{iif}) = C(count,:);
    end
end
    
