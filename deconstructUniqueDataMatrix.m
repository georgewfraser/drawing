function rerate = deconstructUniqueDataMatrix(rate, Y, alive, nBinsPerDay, colNames)
rerate = cell(size(rate));
binCount = 0;
for day=1:length(rate)
    rerate{day} = struct();
    
    Yrows = binCount + (1:nBinsPerDay(day));
    Ycols = find(alive(day,:));
    
%     rateFields = fieldnames(rate{day});
    uniqueFields = colNames(day,Ycols);
    for unit=1:length(uniqueFields)
        name = uniqueFields{unit};
        rerate{day}.(name) = reshape(Y(Yrows,Ycols(unit)),size(rate{day}.(name)));
    end
    
    binCount = binCount+nBinsPerDay(day);
end