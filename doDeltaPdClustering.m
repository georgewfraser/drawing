% controlEmpiricalPd = empiricalPd(controlSnips, controlRate);
% perturbEmpiricalPd = empiricalPd(perturbSnips, perturbRate);
% 
% [controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd] = ...
%     synchFields(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd);
% 
% meanChange = cell(size(controlEmpiricalPd));
% for day=1:length(controlEmpiricalPd)
%     cday = unravel(controlEmpiricalPd{day});
%     cday = cart2pol(cday(1,:),cday(2,:));
%     pday = unravel(perturbEmpiricalPd{day});
%     pday = cart2pol(pday(1,:),pday(2,:));
%     mday = mean(wrapToPi(pday-cday));
%     fields = fieldnames(controlEmpiricalPd{day});
%     meanChange{day} = struct();
%     for unit=1:length(fields)
%         meanChange{day}.(fields{unit}) = mday;
%     end
% end
% meanChange = unravelAll(meanChange);
% 
% controlD = unravelAll(controlPd);
% controlD = cart2pol(controlD(1,:),controlD(2,:));
% perturbD = unravelAll(perturbPd);
% perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
% decoderChange = wrapToPi(perturbD-controlD);
% 
% for day=1:length(controlEmpiricalPd)
%     controlEmpiricalPd{day} = structfun(@(x) cart2pol(x(1),x(2)), controlEmpiricalPd{day}, 'UniformOutput', false);
%     perturbEmpiricalPd{day} = structfun(@(x) cart2pol(x(1),x(2)), perturbEmpiricalPd{day}, 'UniformOutput', false);
% end
% controlE = unravelAll(controlEmpiricalPd);
% perturbE = unravelAll(perturbEmpiricalPd);
% 
% deltaPd = wrapToPi(perturbE-controlE).*sign(meanChange);
% deltaPd = reravelAll(deltaPd, controlEmpiricalPd);

[Y, alive, nBinsPerDay, colNames] = constructUniqueDataMatrix(deltaPd, survival);
Yfit = nan(size(Y));
for row=1:size(Y,1)
    fprintf('.');
    rowMask = (1:size(Y,1))~=row;
    % Impute missing values in the rest of the dataset
    % # PCs needs to be selected for predictive value
    [C, ss, M, X, Ye ] = ppca_mv(Y(rowMask,:),5,0);
    % Determine what units are present in the current row
    colMask = ~isnan(Y(row,:))&~isnan(Ye(1,:));
    for unit=find(colMask)
        unitMask = colMask & (1:size(Y,2))~=unit;
        if(sum(unitMask>0))
            % Fit a model using the rest of the dataset
            A = [ones(sum(rowMask),1) Ye(:,unitMask)];
            b = Ye(:,unit);
            model = pinv(A)*b;
            Yfit(row,unit) = [1 Y(row,unitMask)]*model;
        end
    end
end