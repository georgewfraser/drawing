function map = channelMap(channelToElectrode, electrodeGrid)
map = nan(10,10);
for i=1:length(channelToElectrode) % should be 96
    loc = electrodeGrid==channelToElectrode(i);
    map(loc) = i;
end