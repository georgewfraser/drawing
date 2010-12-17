function [pos, vel, acc, hold, holdA, holdB] = covariateRepresentation(factors, kin)
pos = nan(length(kin),size(factors,2));
vel = nan(size(pos));
acc = nan(size(pos));
hold = nan(size(pos));
holdA = nan(size(pos));
holdB = nan(size(pos));

for day=1:length(kin)
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
    HA = zeros(size(kin{day}.velX));
    HA(:,1:5) = 1;
    HA = HA(:);
    HB = zeros(size(kin{day}.velX));
    HB(:,16:end) = 1;
    HB = HB(:);
    
    for nFactors=1:size(factors,2)
        F = unravel(factors{day,nFactors});
        
        pos(day,nFactors) = getR2(F,P);
        vel(day,nFactors) = getR2(F,V);
        acc(day,nFactors) = getR2(F,A);
        hold(day,nFactors) = getR2(F,H);
        holdA(day,nFactors) = getR2(F,HA);
        holdB(day,nFactors) = getR2(F,HB);
    end
end
end

function R2 = getR2(A,B)
mask = isnan(sum(B,2))|isnan(sum(A,2));
A = A(~mask,:);
B = B(~mask,:);
A = bsxfun(@minus,A,mean(A));
B = bsxfun(@minus,B,mean(B));
Bhat = nan(size(B));
idx = crossvalind('Kfold',size(A,1),5);
for k=1:5
    X = A(k~=idx,:)\B(k~=idx,:);
    Bhat(k==idx,:) = A(k==idx,:)*X;
end
ssr = sum(sum((B-Bhat).^2));
ss = sum(sum(B.^2));
R2 = 1 - ssr/ss;
% R2 = R2.*size(B,2);
end