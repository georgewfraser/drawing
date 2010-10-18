function X = unravelAll(days)
days = reshape(days,1,numel(days));
days = cellfun(@unravel, days, 'UniformOutput', false);
X = cell2mat(days);