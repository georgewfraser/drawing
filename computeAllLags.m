function [direction, illusion] = computeAllLags(coutSnips, coutKin, coutRate, drawingSnips, drawingKin, drawingRate, stopAtUnit, commonPD)
% Compute preferred directions
prefDirs = {};
for day=1:length(coutSnips)
    % Target direction in the center-out task
    T = coutSnips{day}.targetPos-coutSnips{day}.startPos;
    T = bsxfun(@rdivide,T,sqrt(sum(T.^2,2)));
    
    fields = fieldnames(coutRate{day});
    for unit=1:min(stopAtUnit,length(fields))
        % Extract per-target firing rates
        R = coutRate{day}.(fields{unit});
        R = mean(R(:,10:13),2);
        % Compute preferred directions
        % T*P = R
        prefDirs{day,unit} = (T \ R)'; %#ok<AGROW>
    end
end

if(commonPD)
    for col=1:size(prefDirs,2)
        common = mean(cell2mat(prefDirs(:,col)));
        for row=1:size(prefDirs,1)
            prefDirs{row,col} = common; %#ok<AGROW>
        end
    end
end

covariates = drawingCovariates(drawingKin, drawingSnips);
lagValues = -.750:.010:.750;
direction = cell(size(drawingSnips));
illusion = cell(size(drawingSnips));
for day=1:length(coutSnips)
    fprintf('%d \t', day);
    direction{day} = struct();
    illusion{day} = struct();
    
    nDrawing = size(drawingSnips{day}.time,1);
    cycleMask = [false(nDrawing,20) true(nDrawing,20*5) false(nDrawing,20)];
    % Don't use circle ellipse data
    cycleMask(~drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:) = false;
    cycleMask = cycleMask';
    
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
    
    ill = covariates{day}.illusion;
    
    % Disparity in the drawing task
    Dv = covariates{day}.velocityDisparity';
    Dp = covariates{day}.positionDisparity';
    
    fields = fieldnames(drawingRate{day});
    for unit=1:min(stopAtUnit,length(fields))
        fprintf('.');
        P = prefDirs{day,unit};
        
        % Calculate a predicted firing rate for the drawing task
        Vrate = (P(1)*Vx+P(2)*Vy+P(3)*Vz)';
        Virate = (P(1).*Vx.*ill+P(2).*Vy.*ill+P(3).*Vz.*ill)';
        Vrate = Vrate(cycleMask);
        Virate = Virate(cycleMask);
        
        % Extract the actual firing rate
        R = drawingRate{day}.(fields{unit})';
        
        time = drawingSnips{day}.time';
        direction{day}.(fields{unit}) = nan(size(lagValues));
        illusion{day}.(fields{unit}) = nan(size(lagValues));
%         if(unit==6)
%             keyboard;
%         end
        for lagIndex=1:length(lagValues)
            Rlag = interpolateColumnwise(time,R,time-lagValues(lagIndex));
            Rlag = Rlag(cycleMask);
            direction{day}.(fields{unit})(lagIndex) = corr(Rlag,Vrate);
            illusion{day}.(fields{unit})(lagIndex) = corr(Rlag,Virate);
        end
    end
    fprintf('\n');
end