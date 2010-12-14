function coeff = icaRotation(coeff, rate)
for day=1:length(rate)
    X = unravel(rate{day});
    X = bsxfun(@minus,X,nanmean(X));
    C = unravel(coeff{day});
    score = X*pinv(C);
    [icasig, A] = fastica(score');
    A = [A; zeros(size(A,2)-size(A,1),size(A,2))];
    coeff{day} = reravel(A*C, coeff{day});
end