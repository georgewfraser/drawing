% % Now uncombine the reconstructions into control and perturb
[factors1, controlRateRecon, controlRateExplained, factors2, perturbRateRecon, perturbRateExplained] = dayByDayFactors(controlRate, perturbRate);

best = bsxfun(@eq,controlRateExplained,max(controlRateExplained,[],2));
crrBest = controlRateRecon'; crrBest = crrBest(best');
prrBest = perturbRateRecon'; prrBest = prrBest(best');
controlReconPd = empiricalPd(controlSnips, crrBest);
perturbReconPd = empiricalPd(perturbSnips, prrBest);

controlEmpiricalPd = empiricalPd(controlSnips, controlRate);
perturbEmpiricalPd = empiricalPd(perturbSnips, perturbRate);

[controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd, controlReconPd, perturbReconPd] = ...
    synchFields(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd, controlReconPd, perturbReconPd);
% 
meanChange = cell(size(controlEmpiricalPd));
for day=1:length(controlEmpiricalPd)
    cday = unravel(controlEmpiricalPd{day});
    cday = cart2pol(cday(1,:),cday(2,:));
    pday = unravel(perturbEmpiricalPd{day});
    pday = cart2pol(pday(1,:),pday(2,:));
    mday = mean(wrapToPi(pday-cday));
    fields = fieldnames(controlEmpiricalPd{day});
    meanChange{day} = struct();
    for unit=1:length(fields)
        meanChange{day}.(fields{unit}) = mday;
    end
end
meanChange = unravelAll(meanChange);

controlD = unravelAll(controlPd);
controlD = cart2pol(controlD(1,:),controlD(2,:));
perturbD = unravelAll(perturbPd);
perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
decoderChange = wrapToPi(perturbD-controlD);

controlE = unravelAll(controlEmpiricalPd);
controlE = cart2pol(controlE(1,:),controlE(2,:));
perturbE = unravelAll(perturbEmpiricalPd);
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));

controlPdExplained = nan(15,1);
perturbPdExplained = nan(15,1);
changePdExplained = nan(15,1);

x = (wrapToPi(perturbD-controlD).*sign(meanChange))';
y = (wrapToPi(perturbE-controlE).*sign(meanChange))';
creditAssignment = corr(x,y);

tick = -pi:pi/4:pi;
controlF = unravelAll(controlReconPd);
controlF = cart2pol(controlF(1,:),controlF(2,:));
perturbF = unravelAll(perturbReconPd);
perturbF = cart2pol(perturbF(1,:),perturbF(2,:));

% subplot(1,3,1);
% x = controlF';
% y = controlE';
% y = x+wrapToPi(y-x);
% plot(x, y,'.');
% line([-pi pi],[-pi pi]);
% axis image;
% xlim([-pi pi]*1.1);
% ylim([-pi pi]*1.1);
% set(gca,'XTick',tick);
% set(gca,'YTick',tick);
% set(gca,'XTickLabel',tick*180/pi);
% set(gca,'YTickLabel',tick*180/pi);
% xlabel('R. PD');
% ylabel('PD');
% title('Control');
% text(-pi,pi,sprintf('r = %0.2f',corr(x,y)));
% 
% subplot(1,3,2);
% x = perturbF';
% y = perturbE';
% y = x+wrapToPi(y-x);
% plot(x, y,'.');
% line([-pi pi],[-pi pi]);
% axis image;
% xlim([-pi pi]*1.1);
% ylim([-pi pi]*1.1);
% set(gca,'XTick',tick);
% set(gca,'YTick',tick);
% set(gca,'XTickLabel',tick*180/pi);
% set(gca,'YTickLabel',tick*180/pi);
% xlabel('R. PD');
% ylabel('PD');
% title('Perturb');
% text(-pi,pi,sprintf('r = %0.2f',corr(x,y)));
% 
% subplot(1,3,3);
x = (wrapToPi(perturbF-controlF).*sign(meanChange)-abs(meanChange))';
y = (wrapToPi(perturbE-controlE).*sign(meanChange)-abs(meanChange))';
% Note that this subtracts a different mean in the real versus recon
%     x = localPdChange(controlF,perturbF);
%     y = localPdChange(controlE,perturbE);
%     y = x+wrapToPi(y-x);
plot(x, y,'k.');
line([-pi pi],[-pi pi]);
axis image;
xlim([-pi pi]*.5);
ylim([-pi pi]*.5);
set(gca,'XTick',tick);
set(gca,'YTick',tick);
set(gca,'XTickLabel',tick*180/pi);
set(gca,'YTickLabel',tick*180/pi);
xlabel('Pred. \Delta PD');
ylabel('\Delta PD');
title('Change');
text(-pi*.4,pi*.4,sprintf('r = %0.2f',corr(x,y)));

set(gcf,'PaperPosition',[0 0 3.35 3.35]./2);