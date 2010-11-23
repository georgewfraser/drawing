function cycles = snipDrawingCycles(drawing)
badtrials = [];
%[date, trial, cycle, is_ellipse, is_illusion, time]
nTotal = numel(drawing.trials.PlexonTrialTime);
nPoints = 20;
cycles = struct();
cycles.time = nan(nTotal, nPoints*7);
cycles.edges = nan(nTotal, 6);
cycles.is_ellipse = false(nTotal,1);
cycles.is_illusion = false(nTotal,1);
cycles.is_ccw = false(nTotal,1);
cycles.progress = nan(nTotal, nPoints*7);

trials = drawing.trials;

kPosTime = drawing.kinematics.PlexonTime;
kPos = drawing.kinematics.Markers;
cursor_transform = drawing.header.CursorTransform(1:3,:);
cursor_transform(1,:) = cursor_transform(1,:) ./ abs(sum(cursor_transform(1,1:3)));
kPos = [kPos ones(size(kPos,1),1)] * cursor_transform';
kPos(sqrt(sum(kPos.^2,2))>5,:) = nan;

for iit=1:length(trials.PlexonTrialTime)
    progress = cumsum(diff(trials.Progress{iit}.Position)<0);
    progress = [0; progress] + trials.Progress{iit}.Position;
    progressTime = (trials.PlexonTrialTime(iit)+trials.Progress{iit}.Time);
    
    start = interp1(progress,progressTime,.5);
    finish = interp1(progress,progressTime,6);
    tRange = find(start<kPosTime&kPosTime<finish);
    cross0 = [diff(sign(kPos(tRange,1)))/2; 0]>0;
    if(sum(cross0)~=6)
        badtrials(end+1) = iit; %#ok<AGROW>
        continue;
    end
    leftX = kPos(tRange(cross0),1);
    rightX = kPos(tRange(cross0)+1,1);
    leftT = kPosTime(tRange(cross0));
    rightT = kPosTime(tRange(cross0)+1);
    cycleEdges = leftT.*(rightX)./(rightX-leftX) + rightT.*(-leftX)./(rightX-leftX);
    diffCycleEdges = diff(cycleEdges);
    diffCycleEdges = diffCycleEdges([1 1:end end]) ./ nPoints;
    diffCycleEdges = diffCycleEdges*(0:(nPoints-1));
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
end
if(~isempty(badtrials))
    warning('ANALYSIS:baddata','%d / %d bad drawing trials!',length(badtrials),length(trials.PlexonTrialTime));
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