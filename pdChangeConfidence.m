function [empiricalChange, decoderChange, globalChange, confidence] = pdChangeConfidence(controlPd, perturbPd, controlEmpiricalPd, controlEmpiricalPdCov, perturbEmpiricalPd, perturbEmpiricalPdCov)
empiricalChange = cell(size(controlPd));
decoderChange = cell(size(controlPd));
globalChange = cell(size(controlPd));
confidence = cell(size(controlPd));
for day=1:length(controlPd)
    fields = fieldnames(controlPd{day});
    empiricalChange{day} = struct();
    decoderChange{day} = struct();
    confidence{day} = struct();
    for iif=1:length(fields)
        f = fields{iif};
        th1 = cart2pol(controlEmpiricalPd{day}.(f)(2), controlEmpiricalPd{day}.(f)(3));
        th2 = cart2pol(perturbEmpiricalPd{day}.(f)(2), perturbEmpiricalPd{day}.(f)(3));
        empiricalChange{day}.(f) = wrapToPi(th2-th1);
        th1 = cart2pol(controlPd{day}.(f)(1), controlPd{day}.(f)(2));
        th2 = cart2pol(perturbPd{day}.(f)(1), perturbPd{day}.(f)(2));
        decoderChange{day}.(f) = wrapToPi(th2-th1);
        dist1 = mvnrnd(controlEmpiricalPd{day}.(f), controlEmpiricalPdCov{day}.(f), 1000);
        dist2 = mvnrnd(perturbEmpiricalPd{day}.(f), perturbEmpiricalPdCov{day}.(f), 1000);
        th1 = cart2pol(dist1(:,2),dist1(:,3));
        th2 = cart2pol(dist2(:,2),dist2(:,3));
        dTh = wrapToPi(th2-th1);
        confidence{day}.(f) = std(dTh);%mean((th1-th2)*sign(mean(th1-th2))<0);
    end
    globalChange{day} = struct();
    gc = mean(cell2mat(struct2cell(decoderChange{day})));
    for iif=1:length(fields)
        globalChange{day}.(fields{iif}) = gc;
    end
end