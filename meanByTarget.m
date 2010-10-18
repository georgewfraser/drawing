function Xmean = meanByTarget(snips, X)
uniqueTargets = unique(snips.targetPos-snips.startPos,'rows');
th = cart2pol(uniqueTargets(:,1),uniqueTargets(:,2));
[th, sortIndex] = sort(th);
uniqueTargets = uniqueTargets(sortIndex,:);
[tf,trialTargetIndex] = ismember(snips.targetPos-snips.startPos, uniqueTargets, 'rows');

Xmean = nan(length(uniqueTargets),size(X,2));

for iit=1:length(uniqueTargets)
    Xmean(iit,:) = mean(X(iit==trialTargetIndex,:));
end
