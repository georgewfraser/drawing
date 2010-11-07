function explained = varianceExplainedSurvivors(rate, survival)
FACTOR_LIMIT = 15;
explained = nan(length(rate),FACTOR_LIMIT);

startTime = now;

for day=1:length(rate)-1
    fields = fieldnames(rate{day});
    % Identify the subset of the population which survives through tomorrow
    survivors = find(sum(survival{day},2)>0);
    sfields = sprintf('Unit%0.2d_%d',[ceil(survivors/4) mod(survivors-1,4)+1]');
    sfields = cellstr(reshape(sfields,8,length(sfields)/8)');
    survivorMask = ismember(fields,sfields);
    rateMatrix = unravel(rate{day});
    rateMatrix = bsxfun(@minus,rateMatrix,mean(rateMatrix));
    ss = sum(rateMatrix(:).^2);
    for nFactors=1:FACTOR_LIMIT
        recon = nan(size(rateMatrix));
        fold = crossvalind('Kfold',size(rateMatrix,1),5);
        for k=1:5
            coeffMatrix = factoran(rateMatrix(fold~=k,:),nFactors,'Rotate','none');
            for unit=find(survivorMask)'
                leaveOutMask = (1:size(recon,2))~=unit;
                latentToRate = coeffMatrix(unit,:)';
                rateToLatent = pinv(coeffMatrix(leaveOutMask,:)');
                recon(fold==k,unit) = rateMatrix(fold==k,leaveOutMask)*rateToLatent*latentToRate;
            end
        end
        residuals = rateMatrix(:,survivorMask)-recon(:,survivorMask);
        ssr = sum(residuals(:).^2);
        
        explained(day,nFactors) = 1 - (ssr/ss);
        
        completed = ((day-1)*FACTOR_LIMIT+nFactors)/(length(rate)*FACTOR_LIMIT);
        fprintf('ETA %s\n',datestr(startTime+(now-startTime)/completed));
    end
end