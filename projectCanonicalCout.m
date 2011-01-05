function canRate = projectCanonicalCout(snips, rate, canB)
canRate = cell(size(rate));
for day=1:length(snips)
    canRate{day} = struct();
    Y = unravel(rate{day});
    V = Y*canB{day,1};
    for var=1:size(V,2)
        canRate{day}.(sprintf('canonical%0.2d',var)) = reshape(V(:,var),size(snips{day}.time));
    end
end