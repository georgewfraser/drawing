function rateByDay = meanByTarget(snipsByDay, rateByDay)
for day=1:length(snipsByDay)
    snips = snipsByDay{day};
    rate = rateByDay{day};
    
    uniqueTargets = unique(snips.targetPos-snips.startPos,'rows');
    th = cart2pol(uniqueTargets(:,1),uniqueTargets(:,2));
    [th, sortIndex] = sort(th);
    uniqueTargets = uniqueTargets(sortIndex,:);
    [tf,trialTargetIndex] = ismember(snips.targetPos-snips.startPos, uniqueTargets, 'rows');

    cnames = fieldnames(rate);
    for unit=1:length(cnames)
        X = rate.(cnames{unit});
        Xmean = nan(length(uniqueTargets),size(X,2));

        for iit=1:length(uniqueTargets)
            Xmean(iit,:) = mean(X(iit==trialTargetIndex,:));
        end
        rate.(cnames{unit}) = Xmean;
    end
    
    rateByDay{day} = rate;
end