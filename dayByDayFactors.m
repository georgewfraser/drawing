function coeff=dayByDayFactors(rate)
coeff = cell(25,1);
for nFactors=1:25
    coeff{nFactors} = cell(size(rate));
    for day=1:length(rate)
        coeff{nFactors}{day} = struct();
    end
end

for day=1:length(rate)
    X = unravel(rate{day});
    %P = princomp(X);
    fields = fieldnames(rate{day});
    fprintf('%d \t',day);
    for nFactors=1:25
        fprintf('.');
        P = factoran(X,nFactors,'Maxit',10000);
        for unit=1:length(fields)
            coeff{nFactors}{day}.(fields{unit}) = P(unit,1:nFactors);
        end
    end
    fprintf('\n');
end
end