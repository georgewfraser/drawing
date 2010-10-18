function angles = subspaceAngle(controlRate, controlRateMean)
angles = nan(length(controlRate),25);
bigSubspace = princomp(unravelRates(controlRateMean));
caret = 0;
for day=1:length(controlRate)
    nUnits = length(fieldnames(controlRate{day}));
    littleSubspace = princomp(unravelRates(controlRate(day)));
    sector = caret + (1:nUnits);
    for nFactors=1:25
        angles(day,nFactors) = subspace(littleSubspace(:,1:nFactors), bigSubspace(sector,1:nFactors));
    end
    caret = caret + nUnits;
end