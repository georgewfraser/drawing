function perturbPdFake = fakePerturbation(controlPd, perturbPd)
perturbPdFake = cell(size(controlPd));
for day=1:length(controlPd)
    controlTh = structfun(@(x) cart2pol(x(1),x(2)), controlPd{day}, 'UniformOutput', false);
    controlR = structfun(@(x) norm(x), controlPd{day})';
    perturbTh = structfun(@(x) cart2pol(x(1),x(2)), perturbPd{day}, 'UniformOutput', false);
    deltaTh = wrapToPi(unravel(perturbTh)-unravel(controlTh));
    deltaTh = deltaTh(randperm(length(deltaTh)));
    deltaTh = wrapToPi(unravel(controlTh)+deltaTh);
    [x, y] = pol2cart(deltaTh, controlR);
    perturbPdFake{day} = reravel([x; y; zeros(size(x))],controlPd{day});
end