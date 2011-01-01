function [rowci, colci] = centerOfMass(channel, map, values1, values2)
[tf,loc] = ismember(channel, map);
[row, col] = ind2sub(size(map),loc);

values1 = reshape(values1,numel(values1),1);
values2 = reshape(values2,numel(values2),1);
row = reshape(row,numel(row),1);
col = reshape(col,numel(col),1);

rowci = bootci(1000,@weightedMean,row,values1,values2);
colci = bootci(1000,@weightedMean,col,values1,values2);
end

function m = weightedMean(target, weights1, weights2)
weights1 = weights1 ./ sum(weights1);
weights2 = weights2 ./ sum(weights2);
m1 = sum(weights1.*target);
m2 = sum(weights2.*target);
m = m2-m1;
end