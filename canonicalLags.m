function lagProfiles = canonicalLags(snips, drawing, canDrawing, canDrawingLag)
lagValues = -.5:.010:.5;
lagProfiles = cell(size(snips));
for day=1:length(snips)
    fprintf('.');
    % n trials x n timepoints
    dim = size(snips{day}.time);
    
    % Basis variables.  This needs to be the same as drawingBasis.m!
    illusion = repmat(snips{day}.is_illusion,1,dim(2));
    illusion = illusion(:);
    ramp = repmat((0:dim(2)-1)/(dim(2)-1),dim(1),1);
    ramp = ramp(:);
    
    % Direction of movement
    [posTime, pos] = transformAndFilterPosition(drawing{day});
    time = (posTime(1:end-1)+posTime(2:end)) ./ 2;
    dir = bsxfun(@rdivide, diff(pos), diff(posTime));
    dir = dir(:,1:2);
    dir = bsxfun(@rdivide,dir,sqrt(sum(dir.^2,2)));
    dir(isnan(dir)) = 0;
    
    % Times we are going to be looking at
    snipsTime = snips{day}.time(:);
    [snipsTime,idx] = sort(snipsTime);
%     postStart = bsxfun(@minus, snips{day}.time, snips{day}.time(:,20));
%     postStart = postStart(:);
%     preEnd = bsxfun(@minus, snips{day}.time, snips{day}.time(:,121));
%     preEnd = preEnd(:);
    
    D = nan(numel(snipsTime),2);

    for lag=1:length(lagValues)
        cycle = nan(size(snips{day}.time));
        for c=1:5
            leftCondition = bsxfun(@le, snips{day}.edges(:,c), snips{day}.time+lagValues(lag));
            rightCondition = bsxfun(@lt, snips{day}.time+lagValues(lag), snips{day}.edges(:,c+1));
            cycle(leftCondition&rightCondition) = c;
        end
        cycle = cycle(:);
        % Mask out circle illusion
        mask = true(size(snips{day}.time));
        mask(~snips{day}.is_ellipse & snips{day}.is_illusion) = false;
        mask = mask(:);
        % Lagged movement direction
        D(idx,1) = interpolate(time,dir(:,1),snipsTime+lagValues(lag));
        D(idx,2) = interpolate(time,dir(:,2),snipsTime+lagValues(lag));
        % Basis variables
        data = [bsxfun(@times,D,cycle==1),...
                bsxfun(@times,D,cycle==2),...
                bsxfun(@times,D,cycle==3),...
                bsxfun(@times,D,cycle==4),...
                bsxfun(@times,D,cycle==5)];
        data = [data bsxfun(@times,data,illusion) ramp]; %#ok<AGROW>=
        Dw = nan(size(D));
        Dw(idx,1) = interpolate(time,dir(:,1),snipsTime+lagValues(lag)-.1);
        Dw(idx,2) = interpolate(time,dir(:,2),snipsTime+lagValues(lag)-.1);
        D = bsxfun(@minus,D,mean(D));
        Dw = bsxfun(@minus,Dw,mean(Dw));
        Dw = D-Dw*(Dw\D);
        dataW = [bsxfun(@times,Dw,cycle==1),...
                bsxfun(@times,Dw,cycle==2),...
                bsxfun(@times,Dw,cycle==3),...
                bsxfun(@times,Dw,cycle==4),...
                bsxfun(@times,Dw,cycle==5)];
        dataW = [dataW bsxfun(@times,dataW,illusion) ramp]; %#ok<AGROW>=
        
        fields = fieldnames(canDrawing{day});
        for unit=1:length(fields)
%             coeff = repmat(canA{day}(1:20,unit),1,2);
%             coeff(2:2:end,1) = 0;
%             coeff(1:2:end,2) = 0;
%             dataUnit = data*coeff;
%             % Don't forget the ramp!
%             dataUnit = [dataUnit ramp]; %#ok<AGROW>
            
            R = canDrawing{day}.(fields{unit})(:);
            Rw = canDrawingLag{day}.(fields{unit})(:);
            R = R-mean(R);
            Rw = Rw-mean(Rw);
            Rw = R-Rw*(Rw\R);
            Rw = Rw-mean(Rw);
%             R(2:end) = R(2:end)-R(1:end-1)*(R(1:end-1)\R(2:end));
            [A,B,r] = canoncorr(R(mask), data(mask,:));
%             [A,B,r] = canoncorr(R, data);
            r = corr(Rw(mask)*A, dataW(mask,:)*B);
            lagProfiles{day}.(fields{unit})(lag) = r;
        end
    end
end
fprintf('\n');