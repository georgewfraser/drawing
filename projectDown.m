function factors = projectDown(coeff, rate)
factors = cell(size(coeff));
for day=1:length(coeff)
    factors{day} = struct();
end

for day=1:length(rate)
    f = fieldnames(rate{day});
    dim = size(rate{day}.(f{1}));
    R = unravel(rate{day});
    R = bsxfun(@minus,R,nanmean(R));
    C = unravel(coeff{day});
    F = R*pinv(C);
    for i=1:size(F,2)
        name = sprintf('factor%0.2d',i);
        factors{day}.(name) = reshape(F(:,i),dim);
    end
end
        