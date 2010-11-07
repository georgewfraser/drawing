function [coeff, pred] = illusionFactors(snips, rate, kin)
coeff = cell(size(rate));
pred = cell(size(rate));
for day=1:length(rate)
    fprintf('.');
    V = unravel(kin{day});
    V = V(:,4:end);
    V(isnan(V)) = 0;
    R = unravel(rate{day});
%     R = bsxfun(@minus,R,mean(R));
    coeffVel = V \ R;
    % Wipe out the velocity subspace
%     Rhat = V*coeffVel;
    Rhat = nan(size(R));
    for unit=1:size(R,2)
        model = glmfit(V,R(:,unit),'poisson','link','log');
        Rhat(:,unit) = glmval(model,V,'log');
    end
%     R = R-(R*pinv(coeffVel)*coeffVel);
    R = R-Rhat;
    [coeffNoVel, score] = princomp(R);
    % coeffVel and coeffNoVel should be disjoint subspaces
    
    fields = fieldnames(rate{day});
    dataDim = size(rate{day}.(fields{1}));
    coeff{day} = struct();
    for unit=1:length(fields)
        coeff{day}.(fields{unit}) = coeffNoVel(unit,1:15);
    end
    for dim=1:15
        pred{day}.(sprintf('factor%0.2d',dim)) = meanByDrawing(snips{day},reshape(score(:,dim),dataDim));
    end
end
end