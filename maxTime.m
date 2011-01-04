function coutRateMean = maxTime(coutRateMean)
for day=1:length(coutRateMean)
    cnames = fieldnames(coutRateMean{day});
    for unit=1:length(cnames)
        X = coutRateMean{day}.(cnames{unit});
        [row,col] = find(X==max(X(:)));
        coutRateMean{day}.(cnames{unit}) = col<=5 | col>=16;
    end
    coutRateMean{day} = cell2mat(struct2cell(coutRateMean{day}));
end
coutRateMean = cell2mat(coutRateMean);