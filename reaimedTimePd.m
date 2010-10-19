function coeff = reaimedTimePd(rateMean)
coeff = cell(size(rateMean));

th = (-pi+pi/8:pi/8:pi)';
[x,y] = pol2cart(th,1);

for day=1:length(rateMean)
    coeff{day} = struct();
    
    V_early = [x y];
    % Dependent variables, firing rateMean means by target
    R_early = structfun(@(x) x(:,6:15)*(1:-(1/9):0)', rateMean{day},'UniformOutput',false);
    R_early = cell2mat(struct2cell(R_early)');
    R_early = bsxfun(@minus,R_early,mean(R_early));
    
    oldSSE = nan;
    newSSE = nan;
    iterations = 0;
    while(iterations<100 && (~isfinite(newSSE/oldSSE) || newSSE/oldSSE<.99))
        % Estimate the preferred directions
        P_early = V_early \ R_early;
        % Estimate the target directions
        V_early = R_early / P_early;
        
        residuals = R_early - V_early*P_early;
        oldSSE = newSSE;
        newSSE = sum(residuals(:).^2);
        iterations = iterations+1;
%         fprintf('SSE = %f\n',newSSE);
    end
    fprintf('Converged in %d iterations\n',iterations);
    
    V_late = [x y];
    % Dependent variables, firing rateMean means by target
    R_late = structfun(@(x) x(:,6:15)*(0:(1/9):1)', rateMean{day},'UniformOutput',false);
    R_late = cell2mat(struct2cell(R_late)');
    R_late = bsxfun(@minus,R_late,mean(R_late));
    
    oldSSE = nan;
    newSSE = nan;
    iterations = 0;
    while(iterations<100 && (~isfinite(newSSE/oldSSE) || newSSE/oldSSE<.99))
        % Estimate the preferred directions
        P_late = V_late \ R_late;
        % Estimate the target directions
        V_late = R_late / P_late;
        
        residuals = R_late - V_late*P_late;
        oldSSE = newSSE;
        newSSE = sum(residuals(:).^2);
        iterations = iterations+1;
%         fprintf('SSE = %f\n',newSSE);
    end
    fprintf('Converged in %d iterations\n',iterations);
    
    fields = fieldnames(rateMean{day});
    for unit=1:length(fields)
        coeff{day}.(fields{unit}) = [P_early(:,unit)' P_late(:,unit)'];
    end
    
    subplot(7,7,day);
    hold on;
    thEarly = cart2pol(V_early(:,1), V_early(:,2));
    thEarly = th+wrapToPi(thEarly-th);
    plot(th, thEarly, 'go');
    thLate = cart2pol(V_late(:,1), V_late(:,2));
    thLate = th+wrapToPi(thLate-th);
    plot(th, thLate, 'rx');
    line([-pi pi],[-pi pi]);
end