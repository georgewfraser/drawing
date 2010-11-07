function factors = projectDownVarimax(coeff, rate)
factors = cell(size(coeff));
for nFactors=1:length(coeff)
    factors{nFactors} = cell(size(coeff{nFactors}));
    for day=1:length(coeff{nFactors})
        factors{nFactors}{day} = struct();
    end
end

for day=1:length(rate)
    fprintf('%d \t',day);
    R = unravel(rate{day});
    for nFactors=1:length(coeff)
        fprintf('.');
        C = unravel(coeff{nFactors}{day});
        C = rotatefactors(C,'Maxit',1000);
        F = R*pinv(C);
        for i=1:size(F,2)
            name = sprintf('factor%0.2d',i);
            factors{nFactors}{day}.(name) = reshape(F(:,i),size(F,1)/20,20);
        end
    end
    fprintf('\n');
end
        