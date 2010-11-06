function lags = computeLags(coutSnips, coutRate, drawingSnips, drawingKin, drawingRate)
lagValue = -.750:.010:.750;
lags = cell(size(coutSnips));
for day=1:length(lags)
    fprintf('%d \t', day);
    lags{day} = struct();
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
    time = drawingSnips{day}.time';
    
    fields = fieldnames(coutRate{day});
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
        
        lags{day}.(fields{unit}) = nan(size(lagValue));
        for lagIndex=1:length(lagValue)
%             Rlag = nan(size(R));
%             for col=1:size(Rlag,2)
%                 Rlag(:,col) = interpolate(time(:,col),R(:,col),time(:,col)-lagValue(lagIndex));
%             end
            Rlag = interpolateColumnwise(time,R,time-lagValue(lagIndex));
            lags{day}.(fields{unit})(lagIndex) = corr(Rlag(cycleMask),Vrate(cycleMask));
            if(isnan(lags{day}.(fields{unit})(lagIndex)))
                keyboard;
            end
        end
        
%         R = R-mean(R(:));
%         subplot(3,2,1);
%         sel = ~drawingSnips{day}.is_ellipse & ~drawingSnips{day}.is_illusion;
%         plot(mean(time(sel,:)),[mean(R(sel,:)); mean(Vrate(sel,:))]');
%         subplot(3,2,2);
%         sel = ~drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion;
%         plot(mean(time(sel,:)),[mean(R(sel,:)); mean(Vrate(sel,:))]');
%         subplot(3,2,3);
%         sel = drawingSnips{day}.is_ellipse & ~drawingSnips{day}.is_illusion;
%         plot(mean(time(sel,:)),[mean(R(sel,:)); mean(Vrate(sel,:))]');
%         subplot(3,2,4);
%         sel = drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion;
%         plot(mean(time(sel,:)),[mean(R(sel,:)); mean(Vrate(sel,:))]');
%         subplot(3,2,5);
%         plot(lagValue,lags{day}.(fields{unit}));
%         
%         keyboard;
    end
    fprintf('\n');
end