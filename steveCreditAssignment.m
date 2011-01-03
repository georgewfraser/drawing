function [deltaE, deltaD] = steveCreditAssignment(controlData, perturbData, controlPd, perturbPd)
controlEmpiricalPd = allPds(controlData);
perturbEmpiricalPd = allPds(perturbData);

[controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd] = ...
    synchFields(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd);

meanChange = cell(size(controlEmpiricalPd));
for day=1:length(controlEmpiricalPd)
    cday = unravel(controlEmpiricalPd{day});
    cday = cart2pol(cday(1,:),cday(2,:));
    pday = unravel(perturbEmpiricalPd{day});
    pday = cart2pol(pday(1,:),pday(2,:));
    mday = mean(wrapToPi(pday-cday));
    fields = fieldnames(controlEmpiricalPd{day});
    meanChange{day} = struct();
    for unit=1:length(fields)
        meanChange{day}.(fields{unit}) = mday;
    end
end
meanChange = unravelAll(meanChange);

controlD = unravelAll(controlPd);
perturbD = unravelAll(perturbPd);
controlE = unravelAll(controlEmpiricalPd);
perturbE = unravelAll(perturbEmpiricalPd);

controlD = cart2pol(controlD(1,:),controlD(2,:));
perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
controlE = cart2pol(controlE(1,:),controlE(2,:));
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));

deltaD = wrapToPi(perturbD-controlD);
deltaE = wrapToPi(perturbE-controlE);

deltaE = deltaE.*sign(meanChange);
deltaD = deltaD.*sign(meanChange);

subplot(2,1,1);
hist(deltaE(deltaD~=0),-pi:pi/50:pi);
title(sprintf('Perturbed %0.2f',mean(deltaE(deltaD~=0)*180/pi)));
subplot(2,1,2);
hist(deltaE(deltaD==0),-pi:pi/50:pi);
title(sprintf('Unperturbed %0.2f',mean(deltaE(deltaD==0)*180/pi)));

end

function pd = allPds(data)
pd = cell(size(data));
for day=1:length(data)
    pd{day} = oneDayPds(data{day}.trials, data{day}.spikes);
end
end
    
function pd = oneDayPds(trials, spikes)
cnames = fieldnames(spikes);
pd = struct();
for iic=1:length(cnames)
    pd.(cnames{iic}) = onePd(trials, spikes.(cnames{iic}));
end
end

function pd = onePd(trials, spk)
firing = nan(size(trials.TargetPos,1),1);
for iit=1:length(firing)
    % Reaction time -> halfway
    window = trials.PlexonTrialTime(iit)+[trials.HoldAFinish(iit)+.150 (trials.HoldAFinish(iit)+trials.HoldBStart(iit))/2];
    firing(iit) = sum(window(1)<spk&spk<window(2));
end
pd = regress(firing, [ones(size(firing)) trials.TargetPos(:,1:2)]);
pd = pd(2:end);
end