function latent = kinSpaceLatent(rate, controlRateMean, kinematics)
latent = nan(length(rate),25);
latentSpace = princomp(unravelAll(controlRateMean));
caret = 0;
for day=1:length(rate)
    rateUnits = fieldnames(rate{day});
    allUnits = fieldnames(controlRateMean{day});
    % Convert today's rates to a matrix  
    X = unravel(rate{day});
    K = [kinematics{day}.velX(:) kinematics{day}.velY(:)];
    % Locate units in rate struct in controlRateMean struct
    [tf,loc] = ismember(rateUnits,allUnits);
    X = X(:,tf);
    % Subtract mean
    X = bsxfun(@minus,X,mean(X));
    % Identify the subspace we are using today
    sector = caret + loc;
    todaySpace = latentSpace(sector,:);
    % Compute variance explained by n factors
    sumK2 = sum(K(:).^2);
    for nFactors=1:25
        nFactorsTodaySpace = orth(todaySpace(:,1:nFactors));
        Xhat = X*nFactorsTodaySpace;
        Khat = nan(size(K));
        for dimension=1:2
            Khat(:,dimension) = Xhat*regress(K(:,dimension),Xhat);
        end
        residuals = K-Khat;
        latent(day,nFactors) = 1 - sum(residuals(:).^2)/sumK2;
    end
    nUnits = length(fieldnames(controlRateMean{day}));
    caret = caret + nUnits;
end