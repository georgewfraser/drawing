function cycles = snipDrawingCycles(drawing)
%[date, trial, cycle, is_ellipse, is_illusion, time]
nTotal = numel(drawing.trials.PlexonTrialTime);
cycles = struct();
cycles.time = nan(nTotal, 20*7);
cycles.edges = nan(nTotal, 6);
cycles.is_ellipse = false(nTotal,1);
cycles.is_illusion = false(nTotal,1);
cycles.is_ccw = false(nTotal,1);
cycles.progress = nan(nTotal, 20*7);

trials = drawing.trials;

kPosTime = drawing.kinematics.PlexonTime;
kPos = drawing.kinematics.Markers;
cursor_transform = drawing.header.CursorTransform(1:3,:);
cursor_transform(1,:) = cursor_transform(1,:) ./ abs(sum(cursor_transform(1,1:3)));
kPos = [kPos ones(size(kPos,1),1)] * cursor_transform';
kPos(sqrt(sum(kPos.^2,2))>5,:) = nan;
kVelTime = (drawing.kinematics.PlexonTime(1:end-1)+drawing.kinematics.PlexonTime(2:end))./2;
kVel = bsxfun(@rdivide,diff(kPos),diff(kPosTime));

%kveltime = (kPosTime(1:end-1)+kPosTime(2:end)) ./ 2;
%kvel = bsxfun(@rdivide, diff(kPos), diff(kPosTime));

for iit=1:length(trials.PlexonTrialTime)
    progress = cumsum(diff(trials.Progress{iit}.Position)<0);
    progress = [0; progress] + trials.Progress{iit}.Position;
    progressTime = (trials.PlexonTrialTime(iit)+trials.Progress{iit}.Time);
    
    start = interp1(progress,progressTime,.5);
    finish = interp1(progress,progressTime,6);
    tRange = find(start<kPosTime&kPosTime<finish);
    cross0 = [diff(sign(kPos(tRange,1)))/2; 0]>0;
    if(sum(cross0)~=6)
        warning('ANALYSIS:baddata','Bad drawing trial %d!',iit);
        continue;
    end
    leftX = kPos(tRange(cross0),1);
    rightX = kPos(tRange(cross0)+1,1);
    leftT = kPosTime(tRange(cross0));
    rightT = kPosTime(tRange(cross0)+1);
    cycleEdges = leftT.*(rightX)./(rightX-leftX) + rightT.*(-leftX)./(rightX-leftX);
    diffCycleEdges = diff(cycleEdges);
    diffCycleEdges = diffCycleEdges([1 1:end end]) ./ 20;
    diffCycleEdges = diffCycleEdges*(0:19);
    diffCycleEdges = diffCycleEdges';
    extraEdges = [cycleEdges(1)-diff(cycleEdges(1:2)); cycleEdges(1:end)]';
    time = bsxfun(@plus,extraEdges,diffCycleEdges);
    cycles.time(iit,:) = time(:);
    cycles.edges(iit,:) = cycleEdges;
    cycles.progress(iit,:) = interpolate(progressTime, progress, time);
    
    label = deblank(char(trials.Label{iit}));
    [tok1, rem] = strtok(label,'_');
    [tok2, rem] = strtok(rem,'_');
    cycles.is_ellipse(iit) = strcmp('ellipse',tok1);
    cycles.is_illusion(iit) = strcmp('illusion',tok2);
    cycles.is_ccw(iit) = ~strcmp('_cw',label(end-2:end));
    
    
%     tRange = (tRange(1)-120):(tRange(end)+120);
%     pos = interpolate(kPosTime(tRange),kPos(tRange,:),time);
%     vel = interpolate(kVelTime(tRange),kVel(tRange,:),time);
%     
%     clf;
%     subplot(3,1,1);
%     hold on;
%     plot(progressTime,progress);
%     plot(cycleEdges,zeros(size(cycleEdges)),'ro');
%     plot(time,zeros(size(time)),'.');
%     subplot(3,1,2);
%     hold on;
%     plot(time,pos);
%     plot(cycleEdges,zeros(size(cycleEdges)),'ro');
%     plot(time,zeros(size(time)),'.');
%     subplot(3,1,3);
%     hold on;
%     plot(time,vel);
%     plot(cycleEdges,zeros(size(cycleEdges)),'ro');
%     plot(time,zeros(size(time)),'.');
%     pause(.5);
end


% Eliminate outliers
outliers = diff(cycles.edges,1,2);
outliers = isnan(outliers) | outliers > median(outliers(:))+2*iqr(outliers(:));
outliers = sum(outliers,2)>0;

fnames = fieldnames(cycles);
for iif=1:length(fnames)
    cycles.(fnames{iif})(outliers,:) = [];
end
end