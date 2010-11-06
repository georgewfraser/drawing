function [velocityDisparity, positionDisparity, direction, acceleration] = computeDisparityLags(coutSnips, coutKin, coutRate, drawingSnips, drawingKin, drawingRate)
covariates = drawingCovariates(drawingKin, drawingSnips);
lagValue = -.750:.010:.750;
velocityDisparity = cell(size(drawingSnips));
positionDisparity = cell(size(drawingSnips));
direction = cell(size(drawingSnips));
acceleration = cell(size(drawingSnips));
for day=1:length(velocityDisparity)
    fprintf('%d \t', day);
    velocityDisparity{day} = struct();
    positionDisparity{day} = struct();
    direction{day} = struct();
    acceleration{day} = struct();
    
    nDrawing = size(drawingSnips{day}.time,1);
    cycleMask = [false(nDrawing,20) true(nDrawing,20*5) false(nDrawing,20)];
    % Don't use circle ellipse data
    cycleMask(~drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:) = false;
    cycleMask = cycleMask';
    
    % Target direction in the center-out task
    T = coutSnips{day}.targetPos-coutSnips{day}.startPos;
    T = bsxfun(@rdivide,T,sqrt(sum(T.^2,2)));
    % Movement direction in the drawing task
    Vx = drawingKin{day}.velX;
    Vy = drawingKin{day}.velY;
    Vz = drawingKin{day}.velZ;
    Vnorm = sqrt(Vx.^2+Vy.^2+Vz.^2);
    Vx = Vx ./ Vnorm;
    Vy = Vy ./ Vnorm;
    Vz = Vz ./ Vnorm;
    Vnan = isnan(Vnorm);
    Vx(Vnan) = 0;
    Vy(Vnan) = 0;
    Vz(Vnan) = 0;
    
    % Disparity in the drawing task
    Dv = covariates{day}.velocityDisparity';
    Dp = covariates{day}.positionDisparity';
    time = drawingSnips{day}.time';
    
    fields = fieldnames(drawingRate{day});
    for unit=1:length(fields)
        fprintf('.');
        % Extract per-target firing rates
        R = coutRate{day}.(fields{unit});
        R = mean(R(:,6:15),2);
        % Compute preferred directions
        % T*P = R
        P = T \ R;
        
        % Calculate a predicted firing rate for the drawing task
        Vrate = (P(1)*Vx+P(2)*Vy+P(3)*Vz)';
        
        % Extract the actual firing rate
        R = drawingRate{day}.(fields{unit})';
        
        velocityDisparity{day}.(fields{unit}) = nan(size(lagValue));
        positionDisparity{day}.(fields{unit}) = nan(size(lagValue));
        direction{day}.(fields{unit}) = nan(size(lagValue));
        for lagIndex=1:length(lagValue)
%             Rlag = nan(size(R));
%             for col=1:size(Rlag,2)
%                 Rlag(:,col) = interpolate(time(:,col),R(:,col),time(:,col)-lagValue(lagIndex));
%             end
            Rlag = interpolateColumnwise(time,R,time-lagValue(lagIndex));
            Rlag = Rlag(cycleMask);
            velocityDisparity{day}.(fields{unit})(lagIndex) = corr(Rlag,Dv(cycleMask));
            positionDisparity{day}.(fields{unit})(lagIndex) = corr(Rlag,Dp(cycleMask));
            direction{day}.(fields{unit})(lagIndex) = corr(Rlag,Vrate(cycleMask));
        end
        
        % Extract center-out firing rate for calculating acceleration
        [gx, A] = gradient(sqrt(coutKin{day}.velX+coutKin{day}.velY+coutKin{day}.velZ));
        A = A';
        keyboard;
        R = coutRate{day}.(fields{unit})';
        acceleration{day}.(fields{unit}) = nan(size(lagValue));
        for lagIndex=1:length(lagValue)
            Rlag = interpolateColumnwise(time,R,time-lagValue(lagIndex));
            Rlag = Rlag(cycleMask);
            acceleration{day}.(fields{unit})(lagIndex) = corr(Rlag,A(cycleMask));
        end
        
%         if(unit==6)
%         R = R-mean(R(:));
%         t = 1:size(R,1);
%         
%         subplot(6,2,1);
%         sel = ~drawingSnips{day}.is_ellipse & ~drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dv(:,sel),2));
%         subplot(6,2,2);
%         sel = ~drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dv(:,sel),2));
%         subplot(6,2,3);
%         sel = drawingSnips{day}.is_ellipse & ~drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dv(:,sel),2));
%         subplot(6,2,4);
%         sel = drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dv(:,sel),2));
%         subplot(6,2,5);
%         plot(lagValue,velocityDisparity{day}.(fields{unit}));
%         
%         subplot(6,2,6+1);
%         sel = ~drawingSnips{day}.is_ellipse & ~drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dp(:,sel),2));
%         subplot(6,2,6+2);
%         sel = ~drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dp(:,sel),2));
%         subplot(6,2,6+3);
%         sel = drawingSnips{day}.is_ellipse & ~drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dp(:,sel),2));
%         subplot(6,2,6+4);
%         sel = drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion;
%         plotyy(t,mean(R(:,sel),2),t,mean(Dp(:,sel),2));
%         subplot(6,2,6+5);
%         plot(lagValue,positionDisparity{day}.(fields{unit}));
%         
%         keyboard;
%         end
    end
    fprintf('\n');
end