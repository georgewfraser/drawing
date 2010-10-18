function X = unravel(day)
day = structfun(@(x) reshape(x,1,numel(x)), day, 'UniformOutput', false);
X = cell2mat(struct2cell(day))';