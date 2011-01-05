function [vel, pos] = illusionCovariates(drawingSnips, drawingKin)
vel = cell(size(drawingSnips));
pos = cell(size(drawingSnips));

for day=1:length(drawingSnips)
    ideal = nan(size(drawingSnips{day}.time));
    sel = drawingSnips{day}.is_ellipse;
    template = mean(drawingKin{day}.velX(sel&~drawingSnips{day}.is_illusion,:));
    ideal(sel,:) = repmat(template,sum(sel),1);
    sel = ~drawingSnips{day}.is_ellipse;
    template = mean(drawingKin{day}.velX(sel&~drawingSnips{day}.is_illusion,:));
    ideal(sel,:) = repmat(template,sum(sel),1);
    
    vel{day} = struct('x',drawingKin{day}.velX-ideal);
    
    ideal = nan(size(drawingSnips{day}.time));
    sel = drawingSnips{day}.is_ellipse;
    template = mean(drawingKin{day}.posX(sel&~drawingSnips{day}.is_illusion,:));
    ideal(sel,:) = repmat(template,sum(sel),1);
    sel = ~drawingSnips{day}.is_ellipse;
    template = mean(drawingKin{day}.posX(sel&~drawingSnips{day}.is_illusion,:));
    ideal(sel,:) = repmat(template,sum(sel),1);
    
    pos{day} = struct('x',drawingKin{day}.posX-ideal);
end
        
