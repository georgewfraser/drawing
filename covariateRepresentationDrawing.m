function [motor, discrepancy, absDiscrepancy] = covariateRepresentationDrawing(coeff, snips, rate, kin)
motor = nan(length(rate),length(coeff));
discrepancy = nan(size(motor));
absDiscrepancy = nan(size(motor));

for day=1:length(rate)
    fprintf('.');
    vx = kin{day}.velX(:,21:120);
    vy = kin{day}.velY(:,21:120);
    vz = kin{day}.velZ(:,21:120);
    Vm = [vx(:) vy(:) vz(:)];
    illusion = snips{day}.progress;
    illusion = illusion-2;
    illusion = illusion/2;
    illusion(illusion<0) = 0;
    illusion(illusion>1) = 1;
    illusion(~snips{day}.is_illusion,:) = 0;
    % Map [0,1] to [0,1.8]
    illusion = 1+illusion*.8;
    illusion(~snips{day}.is_ellipse,:) = 1./illusion(~snips{day}.is_ellipse,:);
    % We want just the difference between coordinate systems
    illusion = illusion-1;
    illusion = illusion.*kin{day}.velX;
    
    cutRate = structfun(@(X) X(:,21:120), rate{day}, 'UniformOutput', false);
    R = unravel(cutRate);
    R = bsxfun(@minus,R,mean(R));
    
    for nFactors=1:length(coeff)
        C = unravel(coeff{nFactors}{day});
        F = R*pinv(C);
        
        motor(day,nFactors) = getR2(F,Vm);
        
        lagIllusionFit = nan(21,1);
        lagAbsIllusionFit = nan(21,1);
        for lag=-10:10
            lagIllusion = illusion(:,lag+(21:120));
            lagIllusion = lagIllusion(:);
            
            lagIllusionFit(lag+11) = getR2(F,lagIllusion);
            lagAbsIllusionFit(lag+11) = getR2(F,abs(lagIllusion));
        end
        discrepancy(day,nFactors) = max(lagIllusionFit);
        absDiscrepancy(day,nFactors) = max(lagAbsIllusionFit);
    end
end
fprintf('\n');
end

function R2 = getR2(A,B)
mask = ~isnan(sum(B,2))|isnan(sum(A,2));
A = bsxfun(@minus,A,nanmean(A));
B = bsxfun(@minus,B,nanmean(B));
Bhat = nan(size(B));
idx = crossvalind('Kfold',size(A,1),5);
for k=1:5
    X = A(k~=idx&mask,:)\B(k~=idx&mask,:);
    Bhat(k==idx&mask,:) = A(k==idx&mask,:)*X;
end
ssr = sum(sum((B(mask,:)-Bhat(mask,:)).^2));
ss = sum(sum(B(mask,:).^2));
R2 = 1 - ssr/ss;
% R2 = R2.*size(B,2);
end