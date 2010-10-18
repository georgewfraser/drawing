function peak = snipPeak(centerOut)
trials = centerOut.trials;
nTotal = numel(trials.PlexonTrialTime);

peak = struct();
peak.time = nan(nTotal, 20);
peak.holds = nan(nTotal, 4);
peak.trial = (1:nTotal)';
peak.startPos = trials.StartPos;
peak.targetPos = trials.TargetPos;

for iit=1:nTotal   
    holds = trials.PlexonTrialTime(iit) + [trials.HoldAStart(iit) trials.HoldAFinish(iit) trials.HoldBStart(iit) trials.HoldBFinish(iit)];
    increment = (holds(3)-holds(2))/(9);
    timepoints = holds(2)-5*increment:increment:holds(3)+5*increment;
    
    peak.time(iit,:) = timepoints;
    peak.holds(iit,:) = holds;
end

% Attempt to recognize if we have a few aberrant center-out targets
vector = trials.TargetPos-trials.StartPos;
distance = sqrt(sum(vector.^2,2));
distance = round(distance*10^6)./10^6;
dmode = mode(distance);
if(0 < mean(distance~=dmode)&&mean(distance~=dmode) < .1)
    warning('ANALYSIS:baddata','It appears that a %0.2f of center-out targets are erroneous.',mean(distance~=dmode));
    valid = find(distance==dmode)';
else
    valid = 1:length(distance);
end

peak.time = peak.time(valid,:);
peak.holds = peak.holds(valid,:);
peak.trial = peak.trial(valid,:);
peak.startPos = peak.startPos(valid,:);
peak.targetPos = peak.targetPos(valid,:);
end