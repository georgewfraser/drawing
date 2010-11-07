function angles = daySeparationSubspaceAngles(coeff, survival)
angles = nan(length(survival)-1,length(coeff));
for day=1:length(survival)-1
    [day1Id, day2Id] = find(survival{day});
    space1 = nan(length(day1Id),length(coeff));
    space2 = nan(length(day1Id),length(coeff));
    for unit=1:length(day1Id)
        day1Name = sprintf('Unit%0.2d_%d',ceil(day1Id(unit)/4),mod(day1Id(unit)-1,4)+1);
        day2Name = sprintf('Unit%0.2d_%d',ceil(day2Id(unit)/4),mod(day2Id(unit)-1,4)+1);

        space1(unit,:) = coeff{length(coeff)}{day}.(day1Name);
        space2(unit,:) = coeff{length(coeff)}{day+1}.(day2Name);
    end
    angles = subspacea(space1,space2);
end