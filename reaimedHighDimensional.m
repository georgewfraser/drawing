function coeff = reaimedHighDimensional(rateMean, factorCoeff)
coeff = cell(size(rateMean));

th = (-pi+pi/8:pi/8:pi)';
[x,y] = pol2cart(th,1);

for day=1:length(rateMean)
    coeff{day} = struct();
    
    % Dependent variables, firing rateMean means by target
    R = structfun(@(x) mean(x(:,6:15),2),rateMean{day},'UniformOutput',false);
    R = cell2mat(struct2cell(R)');
    R = bsxfun(@minus,R,mean(R));
    % Preferred directions in the high-dimensional space
    P = unravel(factorCoeff{day});
    Pxy = nan(2,size(P,2));
    for unit=1:size(R,2)
        mask = (1:size(R,2))~=unit;
        % Target directions in the high-dimensional space
        V = R(:,mask) / P(:,mask);
        % Estimate rate for current unit
        Rhat = V*P(:,unit);
        % Estimate velocity preferred direction for current unit
        Pxy(:,unit) = [x y] \ Rhat;
    end
    
    fields = fieldnames(rateMean{day});
    for unit=1:length(fields)
        coeff{day}.(fields{unit}) = Pxy(:,unit)';
    end
end