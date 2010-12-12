function lags = populationLags(drawingSnips, drawingKin, drawing)
lagValues = -.5:.010:.5;
basis = drawingBasis(drawingSnips, drawingKin);

lags = cell(size(drawing));
for day=1:length(drawing)
    lags{day} = struct();
    cnames = fieldnames(drawing{day}.spikes);
    for unit=1:length(cnames)
        lags{day}.(cnames{unit}) = nan(size(lagValues));
    end
end

for lag=1:length(lagValues)
    fprintf('.');
    drawingRate = snipSmoothedRate(drawingSnips, drawing, lagValues(lag));
    
    for day=1:length(drawing)
        sel = drawingSnips{day}.is_ellipse | ~drawingSnips{day}.is_illusion;
        cnames = fieldnames(drawingRate{day});
        bday = structfun(@(X) X(sel,:), basis{day}, 'UniformOutput', false);
        X = unravel(bday);
        for unit=1:length(cnames)
            Y = drawingRate{day}.(cnames{unit})(sel,:);
            Y = reshape(Y,numel(Y),1);
            
            if(sum(Y)>0)
                [A,B,r] = canoncorr(X,Y);
                lags{day}.(cnames{unit})(lag) = r;
            end
        end
    end
end
fprintf('\n');
end
            

function [X,Y] = trainingData(drawingSnips, drawingRate, basis, day)
    sel = drawingSnips{day}.is_ellipse | ~drawingSnips{day}.is_illusion;
    bday = structfun(@(x) x(sel,:), basis{day}, 'UniformOutput', false);
    dday = structfun(@(x) x(sel,:), drawingRate{day}, 'UniformOutput', false);
    X = unravel(bday);
    Y = unravel(dday);
end