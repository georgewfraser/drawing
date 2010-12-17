function [factors1, recon1, explained1, factors2, recon2, explained2] = dayByDayFactors(rate1, rate2)
warning('off','stats:factoran:ZeroVariance');
warning('off','stats:factoran:IterOrEvalLimit');

FACTOR_LIMIT = min(15,min(cellfun(@(x) length(fieldnames(x)), rate1)));
factors1 = cell(numel(rate1),FACTOR_LIMIT);
recon1 = cell(numel(rate1),FACTOR_LIMIT);
factors2 = cell(numel(rate1),FACTOR_LIMIT);
recon2 = cell(numel(rate1),FACTOR_LIMIT);
for i=1:numel(factors1)
    factors1{i} = struct();
    recon1{i} = struct();
    factors2{i} = struct();
    recon2{i} = struct();
end
explained1 = nan(numel(rate1),FACTOR_LIMIT);
explained2 = nan(numel(rate2),FACTOR_LIMIT);

% startTime = now;

for day=1:length(rate1)
    cnames = fieldnames(rate1{day});
    dim1 = size(rate1{day}.(cnames{1}));
    dim2 = size(rate2{day}.(cnames{1}));
    X1 = unravel(rate1{day});
    X1r = nan(size(X1)); % reconstruction
    X2 = unravel(rate2{day});
    X2r = nan(size(X2)); % reconstruction
    
    fold1 = repmat(crossvalind('Kfold',dim1(1),5),1,dim1(2));
    fold1 = fold1(:);
    fold2 = repmat(crossvalind('Kfold',dim2(1),5),1,dim2(2));
    fold2 = fold2(:);
    
    fprintf('%d \t',day);
    for nFactors=1:min(FACTOR_LIMIT,size(X1,2))
        df = .5*((size(X1,2)-nFactors)^2 - (size(X1,2)+nFactors));
        if(df<0)
            break;
        end
        F1k = nan(size(X1,1),nFactors);
        F2k = nan(size(X2,1),nFactors);
        for k=1:5
            fprintf('.');
            try
                [lambda,psi] = factoran(X1(fold1~=k,:), nFactors);
            catch e
                [lambda,psi] = factoran(X1(fold1~=k,:), nFactors, 'rotate', 'none');
            end
                        
            sqrtPsi = sqrt(psi);
            invsqrtPsi = 1 ./ sqrtPsi;
            
            X0 = X1;
            meanX = mean(X1(fold1~=k,:));
            stdX = std(X1(fold1~=k,:));
            X0 = bsxfun(@minus,X0,meanX);
            X0 = bsxfun(@rdivide,X0,stdX);
            for unit=1:size(X1,2)
                mask = (1:size(X1,2))~=unit;
                F = (X0(fold1==k,mask)*diag(invsqrtPsi(mask))) / (lambda(mask,:)'*diag(invsqrtPsi(mask)));
                X1r(fold1==k,unit) = F*lambda(unit,:)'+meanX(unit);
            end
            F1k(fold1==k,:) = (X0(fold1==k,:)*diag(invsqrtPsi)) / (lambda'*diag(invsqrtPsi));
            
            X0 = X2;
            meanX = mean(X2(fold2~=k,:));
            stdX = std(X2(fold2~=k,:));
            X0 = bsxfun(@minus,X0,meanX);
            X0 = bsxfun(@rdivide,X0,stdX);
            for unit=1:size(X1,2)
                mask = (1:size(X1,2))~=unit;
                F = (X0(fold2==k,mask)*diag(invsqrtPsi(mask))) / (lambda(mask,:)'*diag(invsqrtPsi(mask)));
                X2r(fold2==k,unit) = F*lambda(unit,:)'+meanX(unit);
            end
            F2k(fold2==k,:) = (X0(fold2==k,:)*diag(invsqrtPsi)) / (lambda'*diag(invsqrtPsi));
        end
        
        recon1{day,nFactors} = reravel(X1r,rate1{day});
        factors1{day,nFactors} = struct();
        for var=1:size(F1k,2)
            factors1{day,nFactors}.(sprintf('factor%0.2d',var)) = reshape(F1k(:,var),dim1);
        end
        explained1(day,nFactors) = 1 - sum(sum((X1-X1r).^2)) / sum(sum(bsxfun(@minus,X1,mean(X1)).^2));
        
        recon2{day,nFactors} = reravel(X2r,rate2{day});
        factors2{day,nFactors} = struct();
        for var=2:size(F2k,2)
            factors2{day,nFactors}.(sprintf('factor%0.2d',var)) = reshape(F2k(:,var),dim2);
        end
        explained2(day,nFactors) = 1 - sum(sum((X2-X2r).^2)) / sum(sum(bsxfun(@minus,X2,mean(X2)).^2));
    end
    fprintf('\n');
end

warning('on','stats:factoran:ZeroVariance');
warning('on','stats:factoran:IterOrEvalLimit');
end