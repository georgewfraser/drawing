function latent = meanSpaceLatent(rate, controlRateMean, controlPd)
latent = nan(length(rate),25);
latentSpace = princomp(unravelRates(controlRateMean));
caret = 0;
for day=1:length(rate)
    controlUnits = fieldnames(controlPd{day});
    rateUnits = fieldnames(rate{day});
    allUnits = fieldnames(controlRateMean{day});
    % Convert today's rates to a matrix  
    X = unravel(rate{day});
    % Locate units in rate struct in controlRateMean struct
    [tf,loc] = ismember(rateUnits,allUnits);
    X = X(:,tf);
    isControl = ismember(rateUnits(tf),controlUnits);
    % Subtract mean
    X = bsxfun(@minus,X,mean(X));
    % Identify the subspace we are using today
    sector = caret + loc;
    todaySpace = latentSpace(sector,:);
    % Compute variance explained by n factors
    sumX2 = sum(sum(X(:,isControl).^2));
    for nFactors=1:25
        nFactorsTodaySpace = orth(todaySpace(:,1:nFactors));
        Xhat = X*nFactorsTodaySpace*nFactorsTodaySpace';
        residuals = X(:,isControl)-Xhat(:,isControl);
        latent(day,nFactors) = 1 - sum(residuals(:).^2)/sumX2;
    end
    nUnits = length(fieldnames(controlRateMean{day}));
    caret = caret + nUnits;
end