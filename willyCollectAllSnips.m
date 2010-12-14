willyMetadata;
controlData = loadSelectedFiles('B:/Data/Willy/%s/Willy.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, control);
latePerturb = [perturb(:,1)+5 perturb(:,2)];
perturbData = loadSelectedFiles('B:/Data/Willy/%s/Willy.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, latePerturb);

for day=1:length(controlData)
    spkC = controlData{day}.spikes;
    spkP = perturbData{day}.spikes;
    [spkC,spkP] = synchFields({spkC},{spkP});
    controlData{day}.spikes = spkC{1};
    perturbData{day}.spikes = spkP{1};
end

controlSnips = snipPeak(controlData);
controlRate = snipSmoothedRate(controlSnips,controlData, .4, 0);
controlKin = snipKinematics(controlSnips, controlData);

perturbSnips = snipPeak(perturbData);
perturbKin = snipKinematics(perturbSnips, perturbData);
perturbRate = snipSmoothedRate(perturbSnips,perturbData, .4, 0);

controlKinMean = meanByTarget(controlSnips, controlKin);
perturbKinMean = meanByTarget(perturbSnips, perturbKin);
controlRateMean = meanByTarget(controlSnips, controlRate);
perturbRateMean = meanByTarget(perturbSnips, perturbRate);
    
% [controlRate, controlRateMean, perturbRate, perturbRateMean, controlData, perturbData] = synchFields(controlRate, controlRateMean, perturbRate, perturbRateMean, controlData, perturbData);

[controlPd, perturbPd] = extractionModulePD('B:/Data/Willy/%s/Willy.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, control, perturb);
[controlPd, perturbPd] = synchFields(controlPd, perturbPd);

err = nan(length(controlRateMean),1);
for day=1:length(err)
    cursor = cart2pol(controlKin{day}.velX(:,15), controlKin{day}.velY(:,15));
    target = cart2pol(controlSnips{day}.targetPos(:,1), controlSnips{day}.targetPos(:,2));
    err(day) = mean(abs(wrapToPi(cursor-target)));
end
    

load b:\data\willy\survival.mat survival;