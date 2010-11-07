% dataRoot = 'B:/Data/Chase';
% 
% load B:\Data\Chase\chase-sort-dates.mat
% merged = loadCenterOut(dataRoot, sort_dates);

controlSnips = cell(size(merged));
controlRate = cell(size(merged));
controlRateMean = cell(size(merged));
controlKin = cell(size(merged));
controlKinMean = cell(size(merged));
for iid=1:length(merged)
    fprintf('.');
    controlSnips{iid} = snipPeakWithFakeOutCenter(merged{iid});
    controlRate{iid} = snipStabilizedSmoothedRate(controlSnips{iid}, merged{iid});
    controlKin{iid} = snipKinematics(controlSnips{iid}, merged{iid});
    controlRateMean{iid} = structfun(@(X) meanByTarget3D(controlSnips{iid}, X), controlRate{iid}, 'UniformOutput', false);
    controlKinMean{iid} = structfun(@(X) meanByTarget3D(controlSnips{iid}, X), controlKin{iid}, 'UniformOutput', false);
end
fprintf('\n');

load B:/Data/Chase/survival.mat survival