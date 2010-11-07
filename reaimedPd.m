function coeff = reaimedPd(rateMean)
coeff = cell(size(rateMean));

th = (-pi+pi/8:pi/8:pi)';
[x,y] = pol2cart(th,1);

for day=1:length(rateMean)
    coeff{day} = struct();
    
    % Independent variables, target directions
    V = [x y];
    % Dependent variables, firing rateMean means by target
    R = structfun(@(x) mean(x(:,6:15),2),rateMean{day},'UniformOutput',false);
    R = cell2mat(struct2cell(R)');
    R = bsxfun(@minus,R,mean(R));
    
    oldSSE = nan;
    newSSE = nan;
    iterations = 0;
    while(iterations<100 && (~isfinite(newSSE/oldSSE) || newSSE/oldSSE<.99))
        % Estimate the preferred directions
        P = V \ R;
        % Estimate the target directions
        V = R / P;
        % Constrain V to unit vectors
        V = bsxfun(@rdivide,V,sqrt(sum(V.^2,2)));
        
        residuals = R - V*P;
        oldSSE = newSSE;
        newSSE = sum(residuals(:).^2);
        iterations = iterations+1;
%         fprintf('SSE = %f\n',newSSE);
    end
%     fprintf('Converged in %d iterations\n',iterations);
    
    fields = fieldnames(rateMean{day});
    for unit=1:length(fields)
        coeff{day}.(fields{unit}) = P(:,unit)';
    end
    
%     subplot(7,7,day);
%     hold on;
%     thR = cart2pol(V(:,1), V(:,2));
%     thR = th+wrapToPi(thR-th);
%     plot(th, thR, 'go');
%     line([-pi pi],[-pi pi]);
end