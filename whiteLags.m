function lags = whiteLags(drawingSnips, drawingKin, drawingRate)
lagValues = -.500:1/300:.500;
lags = cell(size(drawingKin));
order = 1;

nPoints = size(drawingSnips{1}.time,2);
perCycle = nPoints/7;

for day=1:length(lags)
    fprintf('%d \t', day);
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
    cycleMask = [false(nDrawing,perCycle) true(nDrawing,perCycle*5) false(nDrawing,perCycle)];
    % Don't use circle ellipse data
    cycleMask(~drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:) = false;
    time = drawingSnips{day}.time;
    
    
    % Whiten D, the direction of movement
    D = [X(cycleMask) Y(cycleMask)];
    Dearly = nan(size(D,1),2*order);
    for auto=1:order
        Xearly = interpolateRowwise(time,X,time-.050*auto);
        Yearly = interpolateRowwise(time,Y,time-.050*auto);
        Dearly(:,(auto-1)*2+(1:2)) = [Xearly(cycleMask) Yearly(cycleMask)];
    end
    Dw = D;% - Dearly*(Dearly \ D);
    
    fields = fieldnames(drawingRate{day});
    for unit=1:length(fields)
        fprintf('.');
        
        lags{day}.(fields{unit}) = nan(size(lagValues));
        
        R = drawingRate{day}.(fields{unit});
        Rearly = nan(numel(R),order);
        for auto=1:order
            % Each column of Rearly is an unrolled lagged R
            Rone = interpolateRowwise(time,R,time-.050*auto);
            Rearly(:,auto) = Rone(:);
        end
        if(sum(R(cycleMask))==0)
            continue;
        end
        % We only want to look at the cycleMask period in fitting the model
        model = Rearly(cycleMask(:),:) \ R(cycleMask);
        % The model works on unrolled versions of R so we have to reshape
        Rw = R(:);% - Rearly*model;
        Rw = reshape(Rw,size(cycleMask));
        
        for lagIndex=1:length(lagValues)
            Rlag = interpolateRowwise(time,Rw,time-lagValues(lagIndex));
            Rlag = Rlag(cycleMask);
            [A,B,r] = canoncorr(Rlag,Dw);
            lags{day}.(fields{unit})(lagIndex) = r;
        end
    end
    fprintf('\n');
end