function rate = snipRate(snips, data)
rate = struct();
cnames = fieldnames(data.spikes);

for iic=1:length(cnames)
    name = cnames{iic};
    if(~isfield(rate,name))
        rate.(name) = nan(size(snips.time));
    end

    for iis=1:size(snips.time,1)
        edges = snips.time(iis,:);
        edges = [edges(1) - (edges(2)-edges(1))./2, ...
                 edges(1:end-1)+diff(edges)./2, ...
                 edges(end) + (edges(end)-edges(end-1))./2];
        rate.(name)(iis,:) = quickHist(data.spikes.(name),edges)' ./ diff(edges);
    end
end
end