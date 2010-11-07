function explained = varianceExplained(rate, coeff)
explained = nan(length(rate),length(coeff));

for day=1:length(rate)
    fprintf('%d \t',day);
    coeffUnits = fieldnames(coeff{1}{day});
    rateUnits = fieldnames(rate{day});
    commonUnits = intersect(rateUnits,coeffUnits);
    subrate = orderfields(rmfield(rate{day},setdiff(rateUnits,commonUnits)));
    rateMatrix = unravel(subrate);
    rateMatrix = bsxfun(@minus,rateMatrix,mean(rateMatrix));
    ss = sum(rateMatrix(:).^2);
    for nFactors=1:length(coeff)
        fprintf('.');
        subcoeff = orderfields(rmfield(coeff{nFactors}{day},setdiff(coeffUnits,commonUnits)));
        coeffMatrix = cell2mat(struct2cell(subcoeff));
        
        recon = nan(size(rateMatrix));
        for unit=1:size(recon,2)
            mask = (1:size(recon,2))~=unit;
            latentToRate = coeffMatrix(unit,:)';
            rateToLatent = pinv(coeffMatrix(mask,:)');
            recon(:,unit) = rateMatrix(:,mask)*rateToLatent*latentToRate;
        end
        residuals = rateMatrix-recon;
        ssr = sum(residuals(:).^2);
        
        explained(day,nFactors) = 1 - (ssr/ss);
    end
    fprintf('\n');
end
    