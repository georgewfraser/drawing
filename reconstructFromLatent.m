function recon = reconstructFromLatent(rate, controlRateMean, nFactors)
recon = cell(size(rate));
latentSpace = princomp(unravelRates(controlRateMean));
caret = 0;
for day=1:length(rate)
    rateUnits = fieldnames(rate{day});
    allUnits = fieldnames(controlRateMean{day});
    % Locate units in rate struct in controlRateMean struct
    [tf,loc] = ismember(rateUnits,allUnits);
    Xindex = find(tf);
    % Construct a matrix of rates
    X = cell2mat(struct2cell(structfun(@(x) x(:)', rate{day}, 'UniformOutput', false)))';
    X = X(:,tf);
    % Subtract mean
    Xmean = mean(X);
    X = bsxfun(@minus,X,Xmean);
    % Identify the subspace we are using today
    sector = caret + loc;
    todaySpace = latentSpace(sector,:);
    nFactorsTodaySpace = orth(todaySpace(:,1:nFactors));
    Xhat = X*nFactorsTodaySpace*nFactorsTodaySpace';
    Xhat = bsxfun(@plus,Xhat,Xmean);
    recon{day} = rate{day};
    for col=1:size(X,2)
        name = rateUnits{Xindex(col)};
        recon{day}.(name)(:) = Xhat(:,col);
    end
    nUnits = length(fieldnames(controlRateMean{day}));
    caret = caret + nUnits;
end
