function [lags, corrs, array] = pullLags(lags)
array = cellfun(@fieldnames, lags, 'UniformOutput', false);
array = cellfun(@(day) cellfun(@(x) sscanf(x,'Unit%d'), day), array, 'UniformOutput', false);
array = cell2mat(array);

corrs = cell2mat(cellfun(@(day) structfun(@max, day), lags, 'UniformOutput', false));
lags = cell2mat(cellfun(@(day) structfun(@bestLag, day), lags, 'UniformOutput', false));

end

function b = bestLag(x)
b = find(x==max(x));
if(length(b)~=1)
    b = nan;
end
end