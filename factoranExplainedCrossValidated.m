function [explained, reconstruction, coeff] = factoranExplainedCrossValidated(rate)
FACTOR_LIMIT = 15;
explained = nan(length(rate),FACTOR_LIMIT);
coeff = cell(FACTOR_LIMIT,1);
reconstruction = cell(size(coeff));
for nFactors=1:length(coeff)
    coeff{nFactors} = cell(size(rate));
    reconstruction{nFactors} = cell(size(rate));
    for day=1:length(rate)
        coeff{nFactors}{day} = struct();
    end
end

startTime = now;

for day=1:length(rate)
%     fprintf('%d \t',day);
    fields = fieldnames(rate{day});
    rateMatrix = unravel(rate{day});
    rateMatrix = bsxfun(@minus,rateMatrix,mean(rateMatrix));
    ss = sum(rateMatrix(:).^2);
    for nFactors=1:FACTOR_LIMIT
%         fprintf('.');
        recon = nan(size(rateMatrix));
        fold = crossvalind('Kfold',size(rateMatrix,1),5);
        for k=1:5
            coeffMatrix = factoran(rateMatrix(fold~=k,:),nFactors,'Rotate','none');
            for unit=1:size(recon,2)
                mask = (1:size(recon,2))~=unit;
                latentToRate = coeffMatrix(unit,:)';
                rateToLatent = pinv(coeffMatrix(mask,:)');
                recon(fold==k,unit) = rateMatrix(fold==k,mask)*rateToLatent*latentToRate;
            end
        end
        reconstruction{nFactors}{day} = reravel(recon, rate{day});
        residuals = rateMatrix-recon;
        ssr = sum(residuals(:).^2);
        
        explained(day,nFactors) = 1 - (ssr/ss);
        
        for unit=1:length(fields)
            coeff{nFactors}{day}.(fields{unit}) = coeffMatrix(unit,1:nFactors);
        end
        
        completed = ((day-1)*FACTOR_LIMIT+nFactors)/(length(rate)*FACTOR_LIMIT);
        fprintf('ETA %s\n',datestr(startTime+(now-startTime)/completed));
    end
%     fprintf('\n');
end
    