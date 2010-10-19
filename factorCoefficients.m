function coeff = factorCoefficients(C, alive, colNames)
coeff = cell(size(alive,1),1);
for day=1:size(alive,1)
    coeff{day} = struct();
    for unit=find(alive(day,:))
        name = colNames{day,unit};
        coeff{day}.(name) = C(unit,:);
    end
end