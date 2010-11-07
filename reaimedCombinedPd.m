function coeff = reaimedCombinedPd(rateMean1, rateMean2)
coeff = cell(size(rateMean1));

th = (-pi+pi/8:pi/8:pi)';
th = [th; th];
[x,y] = pol2cart(th,1);

for day=1:length(rateMean1)
    coeff{day} = struct();
    
    % Model : V*P = R
    %
    % Independent variables, target directions
    V = [x y];
    % Dependent variables, firing rateMean means by target
    R1 = structfun(@(x) mean(x(:,6:15),2),rateMean1{day},'UniformOutput',false);
    R1 = cell2mat(struct2cell(R1)');
    R1 = bsxfun(@minus,R1,mean(R1));
    R2 = structfun(@(x) mean(x(:,6:15),2),rateMean2{day},'UniformOutput',false);
    R2 = cell2mat(struct2cell(R2)');
    R2 = bsxfun(@minus,R2,mean(R2));
    R = [R1; R2];
    
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
    
    fields = fieldnames(rateMean1{day});
    for unit=1:length(fields)
        coeff{day}.(fields{unit}) = P(:,unit)';
    end
    
%     subplot(7,7,day);
%     hold on;
%     thR = cart2pol(V(:,1), V(:,2));
%     thR = th+wrapToPi(thR-th);
%     plot(th(1:16), thR(1:16), 'rx');
%     plot(th(16:end), thR(16:end), 'go');
%     line([-pi pi],[-pi pi]);
end