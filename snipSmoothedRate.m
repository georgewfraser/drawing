function rate = snipSmoothedRate(snips, data, varargin)
if(~isempty(varargin))
    lag = varargin{1};
else
    lag = 0;
end
rate = struct();
cnames = fieldnames(data.spikes);

smoother = 1-cos((0:.010:.2)*2*pi/.2);
smoother = smoother./norm(smoother);

for iic=1:length(cnames)
    name = cnames{iic};
    rate.(name) = nan(size(snips.time));

    for iis=1:size(snips.time,1)
        edges = (snips.time(iis,1)-.1):.010:(snips.time(iis,end)+.1);
        times = (edges(1:end-1)+edges(2:end))./2;
        counts = quickHist(data.spikes.(name),edges);
        counts = filtfilt(smoother,1,counts);
        counts = counts ./ .010;
        rate.(name)(iis,:) = interpolate(times, counts, snips.time(iis,:)+lag);
    end
end