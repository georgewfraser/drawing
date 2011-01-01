function mapMean = projectOntoMap(channel, illusion, map)
mapMean = nan(size(map));
for c=1:96
    mapMean(map==c) = mean(illusion(channel==c));
end