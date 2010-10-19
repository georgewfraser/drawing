controlEmpiricalPd = reaimedPd(controlRateMean);
perturbEmpiricalPd = reaimedPd(perturbRateMean);
controller = rateController(controlPd, controlRate, controlKin);

[controlTh, perturbTh, decoderChange, globalChange, meanChange] = pdChange(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd);

decoderChangeMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), decoderChange, 'UniformOutput', false));
globalChangeMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), globalChange, 'UniformOutput', false));
controlThMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), controlTh, 'UniformOutput', false));
perturbThMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), perturbTh, 'UniformOutput', false));
empiricalChangeMat = wrapToPi(perturbThMat-controlThMat);
meanChangeMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), meanChange, 'UniformOutput', false));
    
subplot(2,1,1);
mask = decoderChangeMat~=0;
perturbedUnitDelta = empiricalChangeMat(mask).*sign(globalChangeMat(mask));
hist(perturbedUnitDelta,100);
title(mean(perturbedUnitDelta)*180/pi);
xlim([-pi pi]);
subplot(2,1,2);
mask = decoderChangeMat==0;
unperturbedUnitDelta = empiricalChangeMat(mask).*sign(globalChangeMat(mask));
hist(unperturbedUnitDelta,100);
title(mean(unperturbedUnitDelta)*180/pi);
xlim([-pi pi]);