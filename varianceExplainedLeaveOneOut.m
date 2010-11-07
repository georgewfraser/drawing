function [explained, reconstruction] = varianceExplainedLeaveOneOut(rate, coeff)
FACTOR_LIMIT = length(coeff);
explained = nan(length(rate),FACTOR_LIMIT);
reconstruction = cell(size(coeff));
for nFactors=1:length(coeff)
    reconstruction{nFactors} = cell(size(rate));
end

% startTime = now;

for day=1:length(rate)
    fprintf('%d \t',day);
    coeffUnits = fieldnames(coeff{1}{day});
    rateUnits = fieldnames(rate{day});
    commonUnits = intersect(rateUnits,coeffUnits);
    subrate = orderfields(rmfield(rate{day},setdiff(rateUnits,commonUnits)));
    rateMatrix = unravel(subrate);
    rateMatrix = bsxfun(@minus,rateMatrix,mean(rateMatrix));
    ss = sum(rateMatrix(:).^2);
    for nFactors=1:FACTOR_LIMIT
        fprintf('.');
        recon = nan(size(rateMatrix));
        subcoeff = orderfields(rmfield(coeff{nFactors}{day},setdiff(coeffUnits,commonUnits)));
        coeffMatrix = cell2mat(struct2cell(subcoeff));
        for unit=1:size(recon,2)
            mask = (1:size(recon,2))~=unit;
            latentToRate = coeffMatrix(unit,:)';
            rateToLatent = pinv(coeffMatrix(mask,:)');
            recon(:,unit) = rateMatrix(:,mask)*rateToLatent*latentToRate;
        end
        reconstruction{nFactors}{day} = reravel(recon, subrate);
        residuals = rateMatrix-recon;
        ssr = sum(residuals(:).^2);
        
        explained(day,nFactors) = 1 - (ssr/ss);
        
%         completed = ((day-1)*FACTOR_LIMIT+nFactors)/(length(rate)*FACTOR_LIMIT);
%         fprintf('ETA %s\n',datestr(startTime+(now-startTime)/completed));
    end
    fprintf('\n');
end
    