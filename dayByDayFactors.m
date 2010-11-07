function coeff=dayByDayFactors(rate)
FACTOR_LIMIT = min(15,min(cellfun(@(x) length(fieldnames(x)), rate)));
coeff = cell(FACTOR_LIMIT,1);
for nFactors=1:length(coeff)
    coeff{nFactors} = cell(size(rate));
    for day=1:length(rate)
        coeff{nFactors}{day} = struct();
    end
end

% startTime = now;

for day=1:length(rate)
    X = unravel(rate{day});
    P = princomp(X);
%     P = bsxfun(@times,P,sign(mean(P)));
    fields = fieldnames(rate{day});
    fprintf('%d \t',day);
    for nFactors=1:length(coeff)
        fprintf('.');
%         P = factoran(X,nFactors,'Rotate','none');
        for unit=1:length(fields)
            coeff{nFactors}{day}.(fields{unit}) = P(unit,1:nFactors);
        end
        
%         completed = ((day-1)*FACTOR_LIMIT+nFactors)/(length(rate)*FACTOR_LIMIT);
%         fprintf('ETA %s\n',datestr(startTime+(now-startTime)/completed));
    end
    fprintf('\n');
end
end