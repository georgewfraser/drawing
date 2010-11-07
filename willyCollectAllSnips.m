willyMetadata;
controlData = loadSelectedFiles('B:/Data/Willy/%s/Willy.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, control);
latePerturb = [perturb(:,1)+5 perturb(:,2)];
perturbData = loadSelectedFiles('B:/Data/Willy/%s/Willy.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, latePerturb);

controlSnips = cell(size(controlData));
controlRate = cell(size(controlData));
controlRateMean = cell(size(controlData));
perturbSnips = cell(size(controlData));
perturbRate = cell(size(controlData));
perturbRateMean = cell(size(controlData));
controlKin = cell(size(controlData));
controlKinMean = cell(size(controlData));
perturbKin = cell(size(controlData));
perturbKinMean = cell(size(controlData));
for iid=1:length(controlData)
    controlSnips{iid} = snipPeak(controlData{iid});
    controlRate{iid} = snipStabilizedSmoothedRate(controlSnips{iid},controlData{iid});
    controlKin{iid} = snipKinematics(controlSnips{iid}, controlData{iid});
    controlKinMean{iid} = structfun(@(X) meanByTarget(controlSnips{iid}, X), controlKin{iid}, 'UniformOutput', false);
    
    perturbSnips{iid} = snipPeak(perturbData{iid});
    perturbKin{iid} = snipKinematics(perturbSnips{iid}, perturbData{iid});
    perturbRate{iid} = snipStabilizedSmoothedRate(perturbSnips{iid},perturbData{iid});
    perturbKinMean{iid} = structfun(@(X) meanByTarget(perturbSnips{iid}, X), perturbKin{iid}, 'UniformOutput', false);
    
    controlRateMean{iid} = structfun(@(X) meanByTarget(controlSnips{iid}, X), controlRate{iid}, 'UniformOutput', false);
    perturbRateMean{iid} = structfun(@(X) meanByTarget(perturbSnips{iid}, X), perturbRate{iid}, 'UniformOutput', false);
end
[controlRate, perturbRate] = synchFields(controlRate, perturbRate);
[controlRateMean, perturbRateMean] = synchFields(controlRateMean, perturbRateMean);

[controlPd, perturbPd] = extractionModulePD('B:/Data/Willy/%s/Willy.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, control, perturb);
[controlPd, perturbPd] = synchFields(controlPd, perturbPd);

err = nan(length(controlRateMean),1);
for day=1:length(err)
    cursor = cart2pol(controlKin{day}.velX(:,15), controlKin{day}.velY(:,15));
    target = cart2pol(controlSnips{day}.targetPos(:,1), controlSnips{day}.targetPos(:,2));
    err(day) = mean(abs(wrapToPi(cursor-target)));
end
    

load b:\data\willy\survival.mat survival;