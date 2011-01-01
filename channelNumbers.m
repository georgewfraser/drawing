function channel = channelNumbers(rate)
channel = [];
for day=1:length(rate)
    cnames = fieldnames(rate{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
end