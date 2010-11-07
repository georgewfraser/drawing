function [good, array] = filterLags(lags, uncertainty)
array = cellfun(@fieldnames, lags, 'UniformOutput', false);
array = cellfun(@(day) cellfun(@(x) sscanf(x,'Unit%d'), day), array, 'UniformOutput', false);
array = cell2mat(array);

uncertainty = cell2mat(cellfun(@(day) cell2mat(struct2cell(day)), uncertainty, 'UniformOutput', false));
peakCorr = cell2mat(cellfun(@(day) structfun(@bestCorr, day), lags, 'UniformOutput', false));
lags = cell2mat(cellfun(@(day) structfun(@bestLag, day), lags, 'UniformOutput', false));

good = lags(uncertainty<5*pi/180 & peakCorr>.5);
end

function b = bestLag(x)
b = find(x==max(x));
if(length(b)~=1)
    b = nan;
end
end

function b = bestCorr(x)
b = x(x==max(x));
if(length(b)~=1)
    b = nan;
end
end