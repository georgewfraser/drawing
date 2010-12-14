function canRate = projectCanonical(snips, rate, canB, fold)
canRate = cell(size(rate));
for day=1:length(snips)
    canRate{day} = struct();
    for var=1:size(canB{day,1},2)
        canRate{day}.(sprintf('canonical%0.2d',var)) = nan(size(snips{day}.time));
    end
    for k=1:5
        sel = fold{day}==k;
        
        dday = structfun(@(X) X(sel,:), rate{day}, 'UniformOutput', false);
        Y = unravel(dday);
        V = Y*canB{day,k};
        for var=1:size(V,2)
            canRate{day}.(sprintf('canonical%0.2d',var))(sel,:) = reshape(V(:,var),size(snips{day}.time(sel,:)));
        end
    end
end