function rateByDate = snipSmoothedRate(snipsByDate, dataByDate, varargin)
if(~isempty(varargin))
    lag = varargin{1};
else
    lag = 0;
end

rateByDate = cell(size(snipsByDate));
for day=1:length(snipsByDate)
    snips = snipsByDate{day};
    data = dataByDate{day};
    rate = struct();
    cnames = fieldnames(data.spikes);
    for iic=1:length(cnames)
        name = cnames{iic};
        rate.(name) = nan(size(snips.time));

        for iis=1:size(snips.time,1)
            rate.(name)(iis,:) = cosineFilter(data.spikes.(name), snips.time(iis,:)-lag, .2);
        end
    end
    rateByDate{day} = rate;
end