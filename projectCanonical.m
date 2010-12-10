function rate = projectCanonical(drawingSnips, drawingRate, canB, fold)
rate = cell(size(drawingRate));
for day=1:length(drawingSnips)
    rate{day} = struct();
    for var=1:size(canB{day,1},2)
        rate{day}.(sprintf('canonical%0.2d',var)) = nan(size(drawingSnips{day}.time));
    end
    for k=1:5
        sel = drawingSnips{day}.is_ellipse | ~drawingSnips{day}.is_illusion;
        sel = sel & fold{day}==k;
        
        dday = structfun(@(X) X(sel,:), drawingRate{day}, 'UniformOutput', false);
        Y = unravel(dday);
        V = Y*canB{day,k};
        for var=1:size(V,2)
            rate{day}.(sprintf('canonical%0.2d',var))(sel,:) = reshape(V(:,var),size(drawingSnips{day}.time(sel,:)));
        end
    end
end