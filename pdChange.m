function [controlTh, perturbTh, decoderChange, globalChange, meanChange] = pdChange(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd)
controlTh = cell(size(controlPd));
perturbTh = cell(size(controlPd));
decoderChange = cell(size(controlPd));
globalChange = cell(size(controlPd));
meanChange = cell(size(controlPd));
for day=1:length(controlPd)
    fields = fieldnames(controlPd{day});
    controlTh{day} = struct();
    perturbTh{day} = struct();
    decoderChange{day} = struct();
    for iif=1:length(fields)
        f = fields{iif};
        controlTh{day}.(f) = cart2pol(controlEmpiricalPd{day}.(f)(2), controlEmpiricalPd{day}.(f)(3));
        perturbTh{day}.(f) = cart2pol(perturbEmpiricalPd{day}.(f)(2), perturbEmpiricalPd{day}.(f)(3));
        th1 = cart2pol(controlPd{day}.(f)(1), controlPd{day}.(f)(2));
        th2 = cart2pol(perturbPd{day}.(f)(1), perturbPd{day}.(f)(2));
        decoderChange{day}.(f) = wrapToPi(th2-th1);
    end
    globalChange{day} = struct();
    meanChange{day} = struct();
    gc = mean(cell2mat(struct2cell(decoderChange{day})));
    mc = mean(wrapToPi(cell2mat(struct2cell(perturbTh{day}))-cell2mat(struct2cell(controlTh{day}))));
    for iif=1:length(fields)
        globalChange{day}.(fields{iif}) = gc;
        meanChange{day}.(fields{iif}) = mc;
    end
end