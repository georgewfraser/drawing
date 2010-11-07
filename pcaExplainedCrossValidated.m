function [explained, reconstruction, coeff] = pcaExplainedCrossValidated(rate)
FACTOR_LIMIT = min(15,min(cellfun(@(x) length(fieldnames(x)), rate)));
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

% startTime = now;

for day=1:length(rate)
    fprintf('%d \t',day);
    fields = fieldnames(rate{day});
    rateMatrix = unravel(rate{day});
    rateMatrix = bsxfun(@minus,rateMatrix,mean(rateMatrix));
    ss = sum(rateMatrix(:).^2);
    
    % Create k-fold cross validation indexes
    dim = size(rate{day}.(fields{1}));
    fold = crossvalind('Kfold',dim(1),5);
    fold = repmat(fold,1,dim(2));
    keyboard; % make sure fold looks right
    fold = fold(:);
    coeffMatrix = cell(5,1);
    for k=1:5
        coeffMatrix{k} = princomp(rateMatrix(fold~=k,:));
    end
            
    for nFactors=1:FACTOR_LIMIT
        fprintf('.');
        recon = nan(size(rateMatrix));
        for k=1:5
            for unit=1:size(recon,2)
                mask = (1:size(recon,2))~=unit;
                latentToRate = coeffMatrix{k}(unit,1:nFactors)';
                rateToLatent = pinv(coeffMatrix{k}(mask,1:nFactors)');
                recon(fold==k,unit) = rateMatrix(fold==k,mask)*rateToLatent*latentToRate;
            end
        end
        reconstruction{nFactors}{day} = reravel(recon, rate{day});
        residuals = rateMatrix-recon;
        ssr = sum(residuals(:).^2);
        
        explained(day,nFactors) = 1 - (ssr/ss);
        
        if(nFactors==15)
            y = 1 + 1;
        end
        
        for unit=1:length(fields)
            coeff{nFactors}{day}.(fields{unit}) = coeffMatrix{1}(unit,1:nFactors);
        end
        
%         completed = ((day-1)*FACTOR_LIMIT+nFactors)/(length(rate)*FACTOR_LIMIT);
%         fprintf('ETA %s\n',datestr(startTime+(now-startTime)/completed));
    end
    fprintf('\n');
end
    