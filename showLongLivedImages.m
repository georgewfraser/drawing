function showLongLivedImages(rateMean, survival, snr)
mask = [false(96,1) true(96,4)];
snr = cell2mat(cellfun(@(X) X(mask)', snr, 'UniformOutput', false));
% snr = [snr zeros(size(snr,1),800-size(snr,2))];

% Wipe out survival anytime the snr is below 50th percentile for either day
threshold = quantile(snr(:),.5);
for day=1:length(survival)
    survival{day}(snr(day,:)<threshold,snr(day+1,:)<threshold) = false;
end
    

survivors = nan(length(survival)+1,800);
for start=1:length(survival)-1
    % Everyone lives at least 0
    % survivors(~isnan(pd{start}(1,:))) = 0;
    
    ids = 1:800;
    % Eliminate units that aren't new today
    if(start>1)
        fromYesterday = ones(1,800)*survival{start-1};
        ids(fromYesterday>0) = 0;
    end
    % Calculate how long these units live
    for iid=start:length(survival)
        ids = ids*survival{iid};
        survivors(start,ids(ids~=0)) = iid+1-start;
    end
end
% survivors(snr<quantile(snr(:),.9)) = nan;

[sortTimes, sortIdx] = sort(survivors(:), 'descend');
sortIdx = sortIdx(~isnan(sortTimes));
for i=1:10
    figure(i);
    [start, unit] = ind2sub(size(survivors),sortIdx(i));
    plotDim = ceil(sqrt(survivors(start,unit)+1));
    for day=start:(start+survivors(start,unit))
        name = sprintf('Unit%0.2d_%d',ceil(unit/4),mod(unit,4));
        subplot(plotDim,plotDim,day-start+1);
        imagesc(rateMean{day}.(name));
        if(day<=length(survival))
            unit = find(survival{day}(unit,:));
        end
    end
end
        