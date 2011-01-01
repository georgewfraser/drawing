function md = moddepth(coutRateMean)
md = cellfun(@daySub, coutRateMean, 'UniformOutput', false);
md = cell2mat(md);
end

function md = daySub(day)
md = structfun(@(X) range(mean(X,2)), day);
end