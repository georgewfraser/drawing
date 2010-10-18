function [pd, covPd] = computeEmpiricalPD(snips, rate)
pd = cell(size(snips));
covPd = cell(size(snips));
for day=1:length(pd)
    pd{day} = struct();
    covPd{day} = struct();
    fields = fieldnames(rate{day});
    X = repmat(snips{day}.targetPos(:,1:2),10,1);
    for iif=1:length(fields)
        % Just look at the first half of the movement
        y = rate{day}.(fields{iif})(:,6:15);
        y = bsxfun(@times,y,snips{day}.time(:,2)-snips{day}.time(:,1));
        y = y(:);
        [b, dev, stats] = glmfit(X,y,'poisson','offset',repmat(.1,size(y)));
        pd{day}.(fields{iif}) = b;
        covPd{day}.(fields{iif}) = stats.covb;
    end
end
        
        
