function angles = controlSpaceAngle(controlPd, controlRateMean)
angles = nan(length(controlPd),25);
latentSpace = princomp(unravelRates(controlRateMean));
caret = 0;
for day=1:length(controlPd)
    controlSpace = cell2mat(struct2cell(controlPd{day}));
    controlSpace = controlSpace(:,1:2);
    controlUnits = fieldnames(controlPd{day});
    allUnits = fieldnames(controlRateMean{day});
    [tf,loc] = ismember(controlUnits,allUnits);
    sector = caret + loc;
    for nFactors=1:25
        angles(day,nFactors) = subspace(controlSpace, latentSpace(sector,1:nFactors));
    end
    nUnits = length(fieldnames(controlRateMean{day}));
    caret = caret + nUnits;
end