function [ant, post] = splitFactors(coutFactors, coutRate)
ant = cell(size(coutRate));
post = cell(size(coutRate));

for day=1:length(coutRate)
    cnames = fieldnames(coutRate{day});
    channel = cellfun(@(x) str2double(x(5:7)), cnames);
    dim = size(coutRate{day}.(cnames{1}));
    
    rate = unravel(coutRate{day});
    fact = unravel(coutFactors{day});
    factR = nan(size(fact));
    fold = repmat(crossvalind('Kfold',dim(1),5),1,dim(2));
    fold = fold(:);
    for k=1:5
        model = [ones(sum(fold~=k),1) rate(fold~=k,channel<100)]\fact(fold~=k,:);
        factR(fold==k,:) = [ones(sum(fold==k),1) rate(fold==k,channel<100)]*model;
    end
    ant{day} = reravel(factR, coutFactors{day});
    for k=1:5
        model = [ones(sum(fold~=k),1)  rate(fold~=k,channel>100)]\fact(fold~=k,:);
        factR(fold==k,:) = [ones(sum(fold==k),1)  rate(fold==k,channel>100)]*model;
    end
    post{day} = reravel(factR, coutFactors{day});
end