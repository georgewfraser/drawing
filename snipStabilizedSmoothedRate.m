function rate = snipStabilizedSmoothedRate(snips, data)
rate = struct();
cnames = fieldnames(data.spikes);
nsmooth = 5;
smoother = cos(-pi+pi/nsmooth:2*pi/nsmooth:pi-pi/nsmooth)+1;
smoother = smoother./norm(smoother);
npad = floor(nsmooth/2);

for iic=1:length(cnames)
    name = cnames{iic};
    if(~isfield(rate,name))
        rate.(name) = nan(size(snips.time));
    end

    for iis=1:size(snips.time,1)
        centers = snips.time(iis,:);
        centers = [centers(1)+diff(centers(1:2))*(-npad:-1) ...
                   centers ...
                   centers(end)+diff(centers(end-1:end))*(1:npad)]; %#ok<AGROW>
        edges = [centers(1) - (centers(2)-centers(1))./2, ...
                 centers(1:end-1)+diff(centers)./2, ...
                 centers(end) + (centers(end)-centers(end-1))./2];
        
        counts = quickHist(data.spikes.(name),edges);
        widths = diff(edges)';
        counts = sqrt(counts)./sqrt(widths);
        counts = filter(smoother,1,counts);
        counts = counts(npad*2+1:end);
        rate.(name)(iis,:) = counts;
    end
end
end