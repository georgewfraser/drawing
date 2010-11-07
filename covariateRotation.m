function coeff = covariateRotation(coeff, rate, kin)
pos = nan(length(rate),length(coeff));
vel = nan(size(pos));
acc = nan(size(pos));
hold = nan(size(pos));

for day=1:length(rate)
    P = [kin{day}.posX(:) kin{day}.posY(:) kin{day}.posZ(:)];
    V = [kin{day}.velX(:) kin{day}.velY(:) kin{day}.velZ(:)];
    Ax = gradient(kin{day}.velX);
    Ay = gradient(kin{day}.velY);
    Az = gradient(kin{day}.velZ);
    A = [Ax(:) Ay(:) Az(:)];
    dmask = sum(abs(P))>0;
    P = P(:,dmask);
    V = V(:,dmask);
    A = A(:,dmask);
    H = zeros(size(kin{day}.velX));
    H(:,[1:5 16:end]) = 1;
    H = H(:);
    
    nCovariates = sum(dmask)*3+1;
    
    R = unravel(rate{day});
    R = bsxfun(@minus,R,mean(R));
    C = unravel(coeff{day})';
%     C = C(:,1:nCovariates);
    F = R*C;
    % F*X = [P V A H]
    X = F \ [V H P A];
    Cx = C*X;
    C = rotatefactors(orth(Cx),'Method','procrustes','Target',Cx,'Type','orthogonal');
    F = R*C;
    [s, idx] = sort(var(F),'descend');
    C = C(:,idx);
    fields = fieldnames(coeff{day});
    for unit=1:length(fields)
        coeff{day}.(fields{unit}) = C(unit,:);
    end
end