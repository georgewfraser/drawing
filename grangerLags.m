function dirLag = grangerLags(drawingSnips, drawingKin, drawingRate)
lagValues = -.500:.010:.500;
dirLag = cell(size(drawingKin));
for day=1:length(dirLag)
    fprintf('%d \t', day);
    dirLag{day} = struct();
    
    % Direction of movement
    X = drawingKin{day}.velX;
    Y = drawingKin{day}.velY;
    Z = drawingKin{day}.velZ;
    S = sqrt(X.^2+Y.^2+Z.^2);
    X = X ./ S;
    Y = Y ./ S;
    Z = Z ./ S;
    Snan = isnan(S);
    X(Snan) = 0;
    Y(Snan) = 0;
    Z(Snan) = 0;
    
    % Mask for active portion of trials
    nDrawing = size(drawingSnips{day}.time,1);
    cycleMask = [false(nDrawing,20) true(nDrawing,20*5) false(nDrawing,20)];
    % Don't use circle ellipse data
    cycleMask(~drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:) = false;
    time = drawingSnips{day}.time;
    
    % Whiten direction of movement with 1-lag regression model
    Xearly = interpolateRowwise(time,X,time-.050);
    Yearly = interpolateRowwise(time,Y,time-.050);
    Zearly = interpolateRowwise(time,Z,time-.050);
    % D, the direction of movement for just the active portion of trials
    D = [X(cycleMask) Y(cycleMask) Z(cycleMask)];
    % Dearly, D one timestep earlier
    Dearly = [Xearly(cycleMask) Yearly(cycleMask) Zearly(cycleMask)];
    % Compute ssr for a model from Dearly to D
    residuals = D - Dearly*(Dearly \ D);
    ss1 = sum(sum(residuals.^2));
    p1 = size(Dearly,2);
    
    fields = fieldnames(drawingRate{day});
    for unit=1:length(fields)
        fprintf('.');
        
        dirLag{day}.(fields{unit}) = nan(size(lagValues));
        
        R = drawingRate{day}.(fields{unit});
        R = R - mean(R(:));
        if(sum(R(cycleMask))==0)
            continue;
        end
        
        for lagIndex=find(lagValues>0)
            Rearly = interpolateRowwise(time,R,time-lagValues(lagIndex));
            Rearly = Rearly(cycleMask);
            predictors = [Dearly Rearly];
            p2 = size(predictors,2);
            residuals = D - predictors*(predictors \ D);
            ss2 = sum(sum(residuals.^2));
            n = size(predictors,1);
%             f = ((ss1-ss2)/(p2-p1))/(ss2/(n-p2));
%             p = fcdf(f, p2-p1, n-p2);
            dirLag{day}.(fields{unit})(lagIndex) = ss2/ss1;
        end
%         Rearly = interpolateRowwise(time,R,time-.050);
%         % R, one timestep earlier
%         model = Rearly(cycleMask) \ R(cycleMask);
%         % Rw, whitened rate
%         Rw = R - Rearly*model;
%         ssRw = sum(Rw(cycleMask).^2);
%         
%         for lagIndex=find(lagValues<0)
%             Rlag = interpolateRowwise(time,Rw,time-lagValues(lagIndex));
%             Rlag = Rlag(cycleMask);
%             residuals = Rlag - Dw*(Dw \ Rlag);
%             ssLag = sum(residuals.^2);
%             f = (ssRw-ssLag)/(
%             dirLag{day}.(fields{unit})(lagIndex) = log(sum(residuals.^2)./ssRw);
%         end
    end
    fprintf('\n');
end