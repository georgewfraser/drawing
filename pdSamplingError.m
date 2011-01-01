function [err, maxR2] = pdSamplingError(controlSnips, controlRate, perturbSnips, perturbRate, controlPd, perturbPd)
controlD = unravelAll(controlPd);
controlD = cart2pol(controlD(1,:),controlD(2,:));
perturbD = unravelAll(perturbPd);
perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
D = wrapToPi(perturbD-controlD);

controlE = empiricalPd(controlSnips, controlRate);
controlE = unravelAll(controlE);
controlE = cart2pol(controlE(1,:),controlE(2,:));
perturbE = empiricalPd(perturbSnips, perturbRate);
perturbE = unravelAll(perturbE);
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));
E = wrapToPi(perturbE-controlE);

Esample = cell(1,100);
for iis=1:100
    Esample{iis} = sample(controlSnips, controlRate, perturbSnips, perturbRate);
end
Esample = cell2mat(Esample);
E = repmat(E,1,100);
D = repmat(D,1,100);
E = E.*sign(D);
Esample = Esample.*sign(D);

% keyboard;

err = std(Esample-E);
maxR2 = corr(E',Esample')^2;
end
    
function deltaE = sample(controlSnips, controlRate, perturbSnips, perturbRate)
for day=1:length(controlSnips)
    n = size(controlSnips{day}.time,1);
    sample = randsample(n,n,true);
    fields = fieldnames(controlSnips{day});
    for iif=1:length(fields)
        controlSnips{day}.(fields{iif}) = controlSnips{day}.(fields{iif})(sample,:);
    end
    fields = fieldnames(controlRate{day});
    for iif=1:length(fields)
        controlRate{day}.(fields{iif}) = controlRate{day}.(fields{iif})(sample,:);
    end
    n = size(perturbSnips{day}.time,1);
    sample = randsample(n,n,true);
    fields = fieldnames(perturbSnips{day});
    for iif=1:length(fields)
        perturbSnips{day}.(fields{iif}) = perturbSnips{day}.(fields{iif})(sample,:);
    end
    fields = fieldnames(perturbRate{day});
    for iif=1:length(fields)
        perturbRate{day}.(fields{iif}) = perturbRate{day}.(fields{iif})(sample,:);
    end
end

controlE = empiricalPd(controlSnips, controlRate);
controlE = unravelAll(controlE);
controlE = cart2pol(controlE(1,:),controlE(2,:));

perturbE = empiricalPd(perturbSnips, perturbRate);
perturbE = unravelAll(perturbE);
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));

deltaE = wrapToPi(perturbE-controlE);
end