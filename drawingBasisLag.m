function [basis, mask] = drawingBasisLag(snips, drawing, lag)
basis = cell(size(snips));
mask = cell(size(snips));
for day=1:length(snips)
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
    
    basis{day} = struct();
    dim = size(snips{day}.time);
    
    % Times we are going to be looking at
    snipsTime = snips{day}.time(:);
    [snipsTime,idx] = sort(snipsTime);
    postStart = bsxfun(@minus, snips{day}.time, snips{day}.time(:,20));
    preEnd = bsxfun(@minus, snips{day}.time, snips{day}.time(:,121));
    mask{day} = postStart+lag>0 & preEnd+lag<0;
    
    D = nan(numel(snipsTime),2);
    D(idx,1) = interpolate(time,dir(:,1),snipsTime+lag);
    D(idx,2) = interpolate(time,dir(:,2),snipsTime+lag);
    
    cycle = nan(size(snips{day}.time));
    for c=1:5
        leftCondition = bsxfun(@le, snips{day}.edges(:,c), snips{day}.time+lag);
        rightCondition = bsxfun(@lt, snips{day}.time+lag, snips{day}.edges(:,c+1));
        cycle(leftCondition&rightCondition) = c;
    end
    cycle = cycle(:);
    % Basis variables
    data = [bsxfun(@times,D,cycle==1),...
            bsxfun(@times,D,cycle==2),...
            bsxfun(@times,D,cycle==3),...
            bsxfun(@times,D,cycle==4),...
            bsxfun(@times,D,cycle==5)];
    data = [data bsxfun(@times,data,illusion) ramp]; %#ok<AGROW>
    
    for b=1:size(data,2)
        basis{day}.(sprintf('basis%0.2d',b)) = reshape(data(:,b),dim);
    end
end
    