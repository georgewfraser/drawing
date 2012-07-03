function data = prune(data, snips, maxLag)
for day=1:length(data)
    samples = sort(snips{day}.time(:));
    fnames = fieldnames(data{day}.spikes);

    for unit=1:length(fnames)
       sel = pruneMex(data{day}.spikes.(fnames{unit}),samples,maxLag);
       data{day}.spikes.(fnames{unit}) = data{day}.spikes.(fnames{unit})(sel>0);
    end
end