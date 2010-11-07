function explained = varianceExplainedCrossDay(rate, coeff, survival)
FACTOR_LIMIT = length(coeff);
explained = nan(length(rate),FACTOR_LIMIT);

startTime = now;

crossCoeff = cell(size(coeff));
for nFactors=1:FACTOR_LIMIT
    crossCoeff{nFactors} = cell(size(rate));
    for day=2:length(rate)
        % Construct a matrix of yesterday's coefficients using the surviving
        % units
        crossCoeff{nFactors}{day} = struct();
        [unit1, unit2] = find(survival{day-1});
        for i=1:length(unit1)
            name1 = sprintf('Unit%0.2d_%d',ceil(unit1(i)/4),mod(unit1(i)-1,4)+1);
            name2 = sprintf('Unit%0.2d_%d',ceil(unit2(i)/4),mod(unit2(i)-1,4)+1);
            crossCoeff{nFactors}{day}.(name2) = coeff{nFactors}{day-1}.(name1);
        end
    end
end
        

for day=2:length(rate)
    coeffUnits = fieldnames(crossCoeff{1}{day});
    rateUnits = fieldnames(rate{day});
    commonUnits = intersect(rateUnits,coeffUnits);
    subrate = orderfields(rmfield(rate{day},setdiff(rateUnits,commonUnits)));
    rateMatrix = unravel(subrate);
    rateMatrix = bsxfun(@minus,rateMatrix,mean(rateMatrix));
    ss = sum(rateMatrix(:).^2);
    for nFactors=1:FACTOR_LIMIT
        recon = nan(size(rateMatrix));
        subcoeff = orderfields(rmfield(crossCoeff{nFactors}{day},setdiff(coeffUnits,commonUnits)));
        coeffMatrix = cell2mat(struct2cell(subcoeff));
        for unit=1:size(recon,2)
            mask = (1:size(recon,2))~=unit;
            latentToRate = coeffMatrix(unit,:)';
            rateToLatent = pinv(coeffMatrix(mask,:)');
            recon(:,unit) = rateMatrix(:,mask)*rateToLatent*latentToRate;
        end
        residuals = rateMatrix-recon;
        ssr = sum(residuals(:).^2);
        
        explained(day,nFactors) = 1 - (ssr/ss);
        
        completed = ((day-1)*FACTOR_LIMIT+nFactors)/(length(rate)*FACTOR_LIMIT);
        fprintf('ETA %s\n',datestr(startTime+(now-startTime)/completed));
    end
end
    