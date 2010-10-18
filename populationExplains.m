function r2 = populationExplains(rate)
r2 = nan(length(rate),1);
for day=1:length(rate)
    X = cell2mat(struct2cell(structfun(@(x) x(:)', rate{day}, 'UniformOutput', false)))';
    Y = nan(size(X));
    for unit=1:size(X,2)
        mask = (1:size(X,2))~=unit;
        Y(:,unit) = X(:,mask)*regress(X(:,unit),X(:,mask));
    end
    residuals = X - Y;
    r2(day) = 1 - sum(residuals(:).^2)/sum(X(:).^2);
end