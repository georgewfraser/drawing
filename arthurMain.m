% load factor-crossval.mat
% arthurCollectAllSnips
% [controlPd, perturbPd] = extractionModulePD('B:/Data/Arthur/%s/Arthur.BC.%0.5d.CenterOut.mat', 'mm-dd-yy', dates, control, perturb);
load b:\data\arthur\survival.mat survival
doAllVarianceExplained
controlEmpiricalPd = empiricalPd(controlSnips, controlRate);
perturbEmpiricalPd = empiricalPd(perturbSnips, perturbRate);
% 1-15 latent variables and reaiming, reaiming with time
controlReconPd = cell(17,1);
perturbReconPd = cell(17,1);
for nFactors=1:15
    controlReconPd{nFactors} = empiricalPd(controlSnips, controlRateRecon{nFactors});
    perturbReconPd{nFactors} = empiricalPd(perturbSnips, perturbRateRecon{nFactors});
end
controlReconPd{16} = empiricalPd(controlSnips, controlRateReaimedRecon{1});
perturbReconPd{16} = empiricalPd(perturbSnips, perturbRateReaimedRecon{1});
controlReconPd{17} = empiricalPd(controlSnips, controlRateReaimedTimeRecon{1});
perturbReconPd{17} = empiricalPd(perturbSnips, perturbRateReaimedTimeRecon{1});
[controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd, controlReconPd{:}, perturbReconPd{:}] = ...
    synchFields(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd, controlReconPd{:}, perturbReconPd{:});

controlD = unravelAll(controlPd);
controlD = cart2pol(controlD(1,:),controlD(2,:));
perturbD = unravelAll(perturbPd);
perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
decoderChange = wrapToPi(perturbD-controlD);

controlE = unravelAll(controlEmpiricalPd);
controlE = cart2pol(controlE(1,:),controlE(2,:));
perturbE = unravelAll(perturbEmpiricalPd);
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));