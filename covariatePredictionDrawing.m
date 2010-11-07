function [motor, discrepancy, absDiscrepancy, realMotor, realDiscrepancy, realAbsDiscrepancy] = covariatePredictionDrawing(coeff, snips, rate, kin)
motor = cell(length(rate),length(coeff));
discrepancy = cell(size(motor));
absDiscrepancy = cell(size(motor));

realMotor = cell(length(rate),1);
realDiscrepancy = cell(size(realMotor));
realAbsDiscrepancy = cell(size(realMotor));

for day=1:length(rate)
    fprintf('.');
    Vm = [kin{day}.velX(:) kin{day}.velY(:) kin{day}.velZ(:)];
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
    dim = size(illusion);
    illusion = illusion(:);
    
    R = unravel(rate{day});
    R = bsxfun(@minus,R,mean(R));
    
    realMotor{day} = reshape(Vm(:,1),dim);
    realDiscrepancy{day} = reshape(illusion,dim);
    realAbsDiscrepancy{day} = reshape(abs(illusion),dim);
    
    for nFactors=1:length(coeff)
        C = unravel(coeff{nFactors}{day});
        F = R*pinv(C);
        
        motor{day,nFactors} = reshape(getPred(F,Vm(:,1)),dim);
        discrepancy{day,nFactors} = reshape(getPred(F,illusion),dim);
        absDiscrepancy{day,nFactors} = reshape(getPred(F,abs(illusion)),dim);
    end
end
fprintf('\n');
end

function Bhat = getPred(A,B)
mask = ~isnan(sum(B,2))|isnan(sum(A,2));
A = bsxfun(@minus,A,nanmean(A));
B = bsxfun(@minus,B,nanmean(B));
Bhat = nan(size(B));
idx = crossvalind('Kfold',size(A,1),5);
for k=1:5
    X = A(k~=idx&mask,:)\B(k~=idx&mask,:);
    Bhat(k==idx&mask,:) = A(k==idx&mask,:)*X;
end
end