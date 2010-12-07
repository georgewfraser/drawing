function lagProfiles = directionLags(snips, drawing, rate)
lagValues = -.5:.010:.5;
lagProfiles = cell(size(snips));
% order = 1;
for day=1:length(snips)
    fields = fieldnames(rate{day});
    
    % Direction of movement
    [posTime, pos] = transformAndFilterPosition(drawing{day});
    time = (posTime(1:end-1)+posTime(2:end)) ./ 2;
    dir = bsxfun(@rdivide, diff(pos), diff(posTime));
    dir = dir(:,1:2);
    dir = bsxfun(@rdivide,dir,sqrt(sum(dir.^2,2)));
    dir(isnan(dir)) = 0;
    
%     % Whiten direction
%     dirEarly = nan(size(dir,1),size(dir,2)*order);
%     for auto=1:order
%         dirEarly(:,(auto-1)*2+(1:2)) = circshift(dir,auto*3);
%     end
%     dir = dir - dirEarly*(dirEarly\dir);
    
    % Times we are going to be looking at
    snipsTime = snips{day}.time(:);
    [snipsTime,idx] = sort(snipsTime);
    postStart = bsxfun(@minus, snips{day}.time, snips{day}.time(:,20));
    postStart = postStart(:);
    preEnd = bsxfun(@minus, snips{day}.time, snips{day}.time(:,121));
    preEnd = preEnd(:);
    
    % Precompute the lagged movement directions
    D = cell(size(lagValues));
    for lag=1:length(lagValues)
        D{lag} = nan(numel(snipsTime),2);
        D{lag}(idx,1) = interpolate(time,dir(:,1),snipsTime+lagValues(lag));
        D{lag}(idx,2) = interpolate(time,dir(:,2),snipsTime+lagValues(lag));
    end
    
    for unit=1:length(fields)
        fprintf('.');
        R = rate{day}.(fields{unit})(:);
%         % Whiten R
%         Rearly = nan(size(R,1),order);
%         for auto=1:order
%             Rearly(:,auto) = circshift(R,auto);
%         end
%         R = R - Rearly*(Rearly\R);
        
        for lag=1:length(lagValues)
            mask = postStart+lagValues(lag)>0 & preEnd+lagValues(lag)<0;
            [A,B,r] = canoncorr(R(mask),D{lag}(mask,:));
            lagProfiles{day}.(fields{unit})(lag) = r;
        end
    end
    fprintf('\n');
end