function plotLagVCoeff(lagValues, lags, canCoeff)
[lags, corrs, array] = pullLags(lags);
for day=1:length(canCoeff)
    canCoeff{day} = cell2mat(struct2cell(structfun(@(x) x(1:4), canCoeff{day}, 'UniformOutput', false)));
end
canCoeff = cell2mat(canCoeff);
pairs(@plot, [lagValues(lags(corrs>.5))' canCoeff(corrs>.5,:)], '.');
