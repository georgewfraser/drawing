[explained, controlRateRecon] = varianceExplainedLeaveOneOut(controlRate, controlCoeff);
[explained, perturbRateRecon] = varianceExplainedLeaveOneOut(perturbRate, controlCoeff);

controlEmpiricalPd = empiricalPd(controlSnips, controlRate);
perturbEmpiricalPd = empiricalPd(perturbSnips, perturbRate);
% 1-15 latent variables and reaiming, reaiming with time
controlReconPd = cell(16,1);
perturbReconPd = cell(16,1);
for nFactors=1:15
    controlReconPd{nFactors} = empiricalPd(controlSnips, controlRateRecon{nFactors});
    perturbReconPd{nFactors} = empiricalPd(perturbSnips, perturbRateRecon{nFactors});
end
controlReconPd{16} = empiricalPd(controlSnips, controlRateReaimedRecon{1});
perturbReconPd{16} = empiricalPd(perturbSnips, perturbRateReaimedRecon{1});
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

controlPdExplained = nan(17,1);
perturbPdExplained = nan(17,1);
changePdExplained = nan(17,1);
figure(1);
clf;
for nFactors=1:16
    controlF = unravelAll(controlReconPd{nFactors});
    controlF = cart2pol(controlF(1,:),controlF(2,:));
    perturbF = unravelAll(perturbReconPd{nFactors});
    perturbF = cart2pol(perturbF(1,:),perturbF(2,:));
    
    subplot(7,9,(nFactors-1)*3+1);
    x = controlF;
    y = controlE;
    y = x+wrapToPi(y-x);
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*1.1);
    ylim([-pi pi]*1.1);
    xlabel('R. PD');
    ylabel('PD');
    title('Control');
    text(-pi,pi,sprintf('R^2 = %0.2f',corr(x,y)^2));
    controlPdExplained(nFactors) = corr(x,y)^2;
    
    subplot(7,9,(nFactors-1)*3+2);
    x = perturbF;
    y = perturbE;
    y = x+wrapToPi(y-x);
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*1.1);
    ylim([-pi pi]*1.1);
    xlabel('R. PD');
    ylabel('PD');
    title('Perturb');
    text(-pi,pi,sprintf('R^2 = %0.2f',corr(x,y)^2));
    perturbPdExplained(nFactors) = corr(x,y)^2;
    
    subplot(7,9,(nFactors-1)*3+3);
    x = wrapToPi(perturbF-controlF).*sign(decoderChange);
    y = wrapToPi(perturbE-controlE).*sign(decoderChange);
    % Note that this subtracts a different mean in the real versus recon
%     x = localPdChange(controlF,perturbF);
%     y = localPdChange(controlE,perturbE);
%     y = x+wrapToPi(y-x);
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*.25);
    ylim([-pi pi]*.25);
    xlabel('R. PD');
    ylabel('PD');
    title('Change');
    text(-pi*.2,pi*.2,sprintf('R^2 = %0.2f',corr(x,y)^2));
    changePdExplained(nFactors) = corr(x,y)^2;
end

figure(2);
clf;
hold on;
R2 = controlPdExplained(1:15);
plot(R2,'k');
best = find(R2==max(R2));
line(best.*[1 1], R2(best)+[0 .05],'Color',[0 0 0]);
text(best,R2(best)+.05,num2str(best));

R2 = perturbPdExplained(1:15);
plot(R2,'Color',[.8 .8 .8]);
best = find(R2==max(R2));
line(best.*[1 1], R2(best)-[0 .05],'Color',[.8 .8 .8]);
text(best,R2(best)-.05,num2str(best));

R2 = changePdExplained(1:15);
plot(R2,'Color',[.8 .8 .8]);
best = find(R2==max(R2));
line(best.*[1 1], R2(best)-[0 .05],'Color',[.8 .8 .8]);
text(best,R2(best)-.05,num2str(best));

% plot(1,globalRotationExplained,'o','Color',[0 0 0]);
% Re-aiming
plot(2,changePdExplained(16),'x','Color',[0 0 0]);
% Re-aiming with time
plot(4,changePdExplained(17),'x','Color',[0 0 0]);

legend('Control','Perturb')
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('R^2')
ylim([0 1]);
