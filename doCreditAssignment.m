function doCreditAssignment(controlSnips, controlRate, perturbSnips, perturbRate, controlPd, perturbPd)
t=6:15;

controlEmpiricalPd = empiricalPd(controlSnips, controlRate, t);
perturbEmpiricalPd = empiricalPd(perturbSnips, perturbRate, t);
controlEmpiricalDist = empiricalThetaInterval(controlSnips, controlRate, t);
perturbEmpiricalDist = empiricalThetaInterval(perturbSnips, perturbRate, t);

[controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd] = ...
    synchFields(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd);

% Day of experiment for each pd in the
pdDay = cell(size(controlPd));
for day=1:length(pdDay)
    pdDay{day} = repmat(day,length(fieldnames(controlPd{day})),1);
end
pdDay = cell2mat(pdDay)';

% Decode and empirical pds
controlD = unravelAll(controlPd);
perturbD = unravelAll(perturbPd);
controlE = unravelAll(controlEmpiricalPd);
perturbE = unravelAll(perturbEmpiricalPd);
controlEDist = unravelAll(controlEmpiricalDist);
perturbEDist = unravelAll(perturbEmpiricalDist);

% Convert to polar coordinates
controlD = cart2pol(controlD(1,:),controlD(2,:));
perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
controlE = cart2pol(controlE(1,:),controlE(2,:));
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));

deltaD = wrapToPi(perturbD-controlD);
deltaE = wrapToPi(perturbE-controlE);
deltaEDist = wrapToPi(perturbEDist-controlEDist);
pgroup = deltaD~=0;

% Mean empirical pd change
meanChange = nan(size(pdDay));
meanChangeGroup = nan(size(pdDay));
for day=1:length(meanChange)
    meanChange(pdDay==day) = mean(deltaE(pdDay==day));
    meanChangeGroup(pdDay==day&pgroup) = mean(deltaE(pdDay==day&pgroup));
    meanChangeGroup(pdDay==day&~pgroup) = mean(deltaE(pdDay==day&~pgroup));
end

deltaEDist = bsxfun(@minus,deltaEDist,meanChangeGroup);
significant = prod(sign(quantile(deltaEDist,[.025 .975])))==1;

deltaE = deltaE.*sign(meanChange);
deltaD = deltaD.*sign(meanChange);

edges = -pi/4:pi/20:pi/2;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
subplot(2,1,1);
hSig = histc(deltaE(pgroup&significant),edges);
hNon = histc(deltaE(pgroup&~significant),edges);
bar(edgeCenters,[hSig(1:end-1); hNon(1:end-1)]','stacked');
% title(sprintf('Perturbed %0.2f',mean(deltaE(deltaD~=0)*180/pi)));
title('Perturbed');
box off, axis tight
xlabel('\Delta PD (^\circ)');
ylabel('# Neurons');
set(gca,'XTick',[-pi/4 0 pi/4]);
set(gca,'XTickLabel',[-45 0 45]);
subplot(2,1,2);
hSig = histc(deltaE(~pgroup&significant),edges);
hNon = histc(deltaE(~pgroup&~significant),edges);
bar(edgeCenters,[hSig(1:end-1); hNon(1:end-1)]','stacked');
% title(sprintf('Unperturbed %0.2f',mean(deltaE(deltaD==0)*180/pi)));
title('Unperturbed');
box off, axis tight
xlabel('\Delta PD (^\circ)');
ylabel('# Neurons');
set(gca,'XTick',[-pi/4 0 pi/4]);
set(gca,'XTickLabel',[-45 0 45]);

set(gcf,'PaperPosition',[1 1 3.35/2 3.35/1.61803399]);

keyboard;
end