arthurMetadata;
controlData = loadSelectedFiles('B:/Data/Arthur/%s/Arthur.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, control);
latePerturb = [perturb(:,1)+5 perturb(:,2)];
perturbData = loadSelectedFiles('B:/Data/Arthur/%s/Arthur.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, latePerturb);

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
    controlRate{iid} = snipRate(controlSnips{iid},controlData{iid});
    controlRateMean{iid} = structfun(@(X) meanByTarget(controlSnips{iid}, X), controlRate{iid}, 'UniformOutput', false);
    perturbSnips{iid} = snipPeak(perturbData{iid});
    perturbRate{iid} = snipRate(perturbSnips{iid},perturbData{iid});
    perturbRateMean{iid} = structfun(@(X) meanByTarget(perturbSnips{iid}, X), perturbRate{iid}, 'UniformOutput', false);
    fields = fieldnames(controlRateMean{iid});
    for iif=1:length(fields)
        if(~isfield(controlRateMean{iid},fields{iif}))
            controlRateMean{iid}.(fields{iif}) = zeros(size(perturbRateMean{iid}.(fields{iif})));
        end
        if(~isfield(perturbRateMean{iid},fields{iif}))
            perturbRateMean{iid}.(fields{iif}) = zeros(size(controlRateMean{iid}.(fields{iif})));
        end
    end
    controlKin{iid} = snipKinematics(controlSnips{iid}, controlData{iid});
    controlKinMean{iid} = structfun(@(X) meanByTarget(controlSnips{iid}, X), controlKin{iid}, 'UniformOutput', false);
    perturbKin{iid} = snipKinematics(perturbSnips{iid}, perturbData{iid});
    perturbKinMean{iid} = structfun(@(X) meanByTarget(perturbSnips{iid}, X), perturbKin{iid}, 'UniformOutput', false);
end