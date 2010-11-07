function peak = snipPeakWithFakeOutCenter(centerOut)
trials = centerOut.trials;
nTotal = numel(trials.PlexonTrialTime);

peak = struct();
peak.time = nan(nTotal*2-1, 20);
peak.holds = nan(nTotal*2-1, 4);
peak.trial = (1:nTotal*2-1)';
peak.startPos = [trials.StartPos; trials.TargetPos(1:end-1,:)];
peak.targetPos = [trials.TargetPos; trials.StartPos(2:end,:)];

for iit=1:nTotal   
    holds = trials.PlexonTrialTime(iit) + [trials.HoldAStart(iit) trials.HoldAFinish(iit) trials.HoldBStart(iit) trials.HoldBFinish(iit)];
    increment = (holds(3)-holds(2))/(9);
    timepoints = holds(2)-5*increment:increment:holds(3)+5*increment;
    
    peak.time(iit,:) = timepoints;
    peak.holds(iit,:) = holds;
end

% These are fake trials using the return-to-center movement
for iit=1:nTotal-1
    holdA = trials.PlexonTrialTime(iit) + [trials.HoldBStart(iit) trials.HoldBFinish(iit)];
    holdB = trials.PlexonTrialTime(iit+1) + [trials.HoldAStart(iit+1) trials.HoldAFinish(iit+1)];
    holds = [holdA holdB];
    increment = (holds(3)-holds(2))/(9);
    timepoints = holds(2)-5*increment:increment:holds(3)+5*increment;
    
    peak.time(nTotal+iit,:) = timepoints;
    peak.holds(nTotal+iit,:) = holds;
end

% Attempt to recognize if we have a few aberrant center-out targets
vector = peak.targetPos-peak.startPos;
distance = sqrt(sum(vector.^2,2));
distance = round(distance*10^6)./10^6;
dmode = mode(distance);
if(0 < mean(distance~=dmode)&&mean(distance~=dmode) < .1)
    warning('ANALYSIS:baddata','It appears that a %0.2f of center-out targets are erroneous.',mean(distance~=dmode));
    valid = distance==dmode;
else
    valid = true(size(distance));
end

% Throw out any trials with a movement time that is too long
tooLong = (peak.holds(:,3)-peak.holds(:,2))>(double(centerOut.header.cout.MovementTime)/1000);
valid = valid & ~tooLong;

peak.time = peak.time(valid,:);
peak.holds = peak.holds(valid,:);
peak.trial = peak.trial(valid,:);
peak.startPos = peak.startPos(valid,:);
peak.targetPos = peak.targetPos(valid,:);
end