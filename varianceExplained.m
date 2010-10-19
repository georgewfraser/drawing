function explained = varianceExplained(rate, coeff, controlPd)
explained = nan(length(rate),length(coeff));

for nFactors=1:length(coeff)
    for day=1:length(rate)
        controlUnits = fieldnames(controlPd{day});
        coeffUnits = fieldnames(coeff{nFactors}{day});
        rateUnits = fieldnames(rate{day});
        commonUnits = intersect(controlUnits,coeffUnits);
        subrate = orderfields(rmfield(rate{day},setdiff(rateUnits,commonUnits)));
        subcoeff = orderfields(rmfield(coeff{nFactors}{day},setdiff(coeffUnits,commonUnits)));
        
        rateMatrix = unravel(subrate);
        rateMatrix = bsxfun(@minus,rateMatrix,mean(rateMatrix));
        coeffMatrix = cell2mat(struct2cell(subcoeff));
        coeffMatrix = orth(coeffMatrix);
        recon = rateMatrix*coeffMatrix*coeffMatrix';
        residuals = rateMatrix-recon;
        ss = sum(rateMatrix(:).^2);
        ssr = sum(residuals(:).^2);
        
        explained(day,nFactors) = 1 - (ssr/ss);
    end
end
    