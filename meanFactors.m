function coeff = meanFactors(controlRateMean)
X = unravelAll(controlRateMean);
C = princomp(X, 'econ');

coeff = cell(25,1);
for nFactors=1:25
    coeff{nFactors} = cell(size(controlRateMean));
    count = 0;
    for day=1:length(coeff{nFactors})
        coeff{nFactors}{day} = struct();
        fields = fieldnames(controlRateMean{day});
        for unit=1:length(fields)
            coeff{nFactors}{day}.(fields{unit}) = C(count+unit,1:nFactors);
        end
        count = count + length(fields);
    end
end