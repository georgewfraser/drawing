function lags = polyLags(drawingSnips, drawingKin, drawingRate)
lagValues = -.500:.010:.500;
knots = -.5:.1:.5;
splines = nan(length(lagValues),length(knots)-3);
for s=1:size(splines,2)
    oneSpline = spmak(knots((s-1)+(1:4)),1);
    splines(:,s) = fnval(oneSpline,lagValues)';
end
    
lags = cell(size(drawingKin));
for day=1:length(lags)
    fprintf('.');
    lags{day} = struct();
    
    % Direction of movement
    X = drawingKin{day}.velX;
    Y = drawingKin{day}.velY;
    S = sqrt(X.^2+Y.^2);
    X = X ./ S;
    Y = Y ./ S;
    Snan = isnan(S);
    X(Snan) = 0;
    Y(Snan) = 0;
    
    % Mask for active portion of trials
    nDrawing = size(drawingSnips{day}.time,1);
    cycleMask = [false(nDrawing,20) true(nDrawing,20*5) false(nDrawing,20)];
    % Don't use circle ellipse data
    cycleMask(~drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:) = false;
    time = drawingSnips{day}.time;
    
    % Compute many different lags for X and Y
    Xlag = nan(sum(cycleMask(:)), length(lagValues));
    Ylag = nan(sum(cycleMask(:)), length(lagValues));
    for lagIndex=1:length(lagValues)
        Xl = interpolateRowwise(time, X, time+lagValues(lagIndex));
        Xlag(:,lagIndex) = Xl(cycleMask);
        Yl = interpolateRowwise(time, Y, time+lagValues(lagIndex));
        Ylag(:,lagIndex) = Yl(cycleMask);
    end
    
    % Reduce the dimensionality using the smoothing splines
    Xpoly = Xlag*splines;
    Ypoly = Ylag*splines;
    
    fields = fieldnames(drawingRate{day});
    for unit=1:length(fields)
        % Fit firing rate as a function of kinematics with distributed lags
        R = drawingRate{day}.(fields{unit})(cycleMask);
        model = [Xpoly Ypoly] \ R;
        xmodel = splines*model(1:8);
        ymodel = splines*model(9:16);

        lags{day}.(fields{unit}) = [xmodel ymodel];
    end
    
end