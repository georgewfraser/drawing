function rate = meanByTargetLatent(snips, X)

for factor=1:size(X,2)
    factorMean = zeros(16,20);
    count = 0;
    for day=1:length(snips)
        dayData = reshape(X(count + (1:numel(snips{day}.time)),factor),size(snips{day}.time));
        factorMean = factorMean + meanByTarget(snips{day},dayData);
        count = count+numel(snips{day}.time);
    end
    factorMean = factorMean./length(snips);
    name = sprintf('factor%0.2d',factor);
    rate.(name) = factorMean;
end