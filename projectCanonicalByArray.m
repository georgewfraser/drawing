function [canRateAnt, canRatePost] = projectCanonicalByArray(snips, rate, canB, fold)
canRateAnt = cell(size(rate));
canRatePost = cell(size(rate));
for day=1:length(snips)
    canRateAnt{day} = struct();
    canRatePost{day} = struct();
    for var=1:size(canB{day,1},2)
        canRateAnt{day}.(sprintf('canonical%0.2d',var)) = nan(size(snips{day}.time));
        canRatePost{day}.(sprintf('canonical%0.2d',var)) = nan(size(snips{day}.time));
    end
    channel = cellfun(@(x) str2double(x(5:7)), fieldnames(rate{day}));
    
    for k=1:5
        sel = fold{day}==k;
        
        dday = structfun(@(X) X(sel,:), rate{day}, 'UniformOutput', false);
        Y = unravel(dday);
        B = pinv(canB{day,k});
        B = pinv(B(:,channel<100));
        V = Y(:,channel<100)*B;
        for var=1:size(V,2)
            canRateAnt{day}.(sprintf('canonical%0.2d',var))(sel,:) = reshape(V(:,var),size(snips{day}.time(sel,:)));
        end
        B = pinv(canB{day,k});
        B = pinv(B(:,channel>100));
        V = Y(:,channel>100)*B;
        for var=1:size(V,2)
            canRatePost{day}.(sprintf('canonical%0.2d',var))(sel,:) = reshape(V(:,var),size(snips{day}.time(sel,:)));
        end
    end
end