function recon = reconstructFromLatent(rate, coeff)
recon = cell(size(rate));
for day=1:length(rate)
    coeffUnits = fieldnames(coeff{day});
    rateUnits = fieldnames(rate{day});
    commonUnits = intersect(rateUnits,coeffUnits);
    subrate = orderfields(rmfield(rate{day},setdiff(rateUnits,commonUnits)));
    subcoeff = orderfields(rmfield(coeff{day},setdiff(coeffUnits,commonUnits)));

    rateMatrix = unravel(subrate);
    rateMatrixMean = mean(rateMatrix);
    rateMatrix = bsxfun(@minus,rateMatrix,rateMatrixMean);
    coeffMatrix = cell2mat(struct2cell(subcoeff));
    coeffMatrix = orth(coeffMatrix);
    reconMatrix = rateMatrix*coeffMatrix*coeffMatrix';
    reconMatrix = bsxfun(@plus,reconMatrix,rateMatrixMean);
    recon{day} = reravel(reconMatrix, subrate);
end