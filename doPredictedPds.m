% % Now uncombine the reconstructions into control and perturb
controlCoeff = dayByDayFactors(controlRate);
[controlRateExplained, controlRateRecon] = varianceExplainedLeaveOneOut(controlRate, controlCoeff);
[perturbRateExplained, perturbRateRecon] = varianceExplainedLeaveOneOut(perturbRate, controlCoeff);
controlReconPd = cell(15,1);
perturbReconPd = cell(15,1);
for nFactors=1:length(controlRateRecon)
    controlReconPd{nFactors} = empiricalPd(controlSnips, controlRateRecon{nFactors});
    perturbReconPd{nFactors} = empiricalPd(perturbSnips, perturbRateRecon{nFactors});
%     controlReconPd{nFactors} = reaimedHighDimensional(controlRateMean, controlCoeff{nFactors});
%     perturbReconPd{nFactors} = reaimedHighDimensional(perturbRateMean, controlCoeff{nFactors});
end

controlEmpiricalPd = empiricalPd(controlSnips, controlRate);
perturbEmpiricalPd = empiricalPd(perturbSnips, perturbRate);

[controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd, controlReconPd{:}, perturbReconPd{:}] = ...
    synchFields(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd, controlReconPd{:}, perturbReconPd{:});
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
% 
% controlD = unravelAll(controlPd);
% controlD = cart2pol(controlD(1,:),controlD(2,:));
% perturbD = unravelAll(perturbPd);
% perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
% decoderChange = wrapToPi(perturbD-controlD);

controlE = unravelAll(controlEmpiricalPd);
controlE = cart2pol(controlE(1,:),controlE(2,:));
perturbE = unravelAll(perturbEmpiricalPd);
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));

controlPdExplained = nan(15,1);
perturbPdExplained = nan(15,1);
changePdExplained = nan(15,1);

tick = -pi:pi/4:pi;
for nFactors=1:15
    figure(nFactors);
    controlF = unravelAll(controlReconPd{nFactors});
    controlF = cart2pol(controlF(1,:),controlF(2,:));
    perturbF = unravelAll(perturbReconPd{nFactors});
    perturbF = cart2pol(perturbF(1,:),perturbF(2,:));
    
%     subplot(7,9,(nFactors-1)*3+1);
    subplot(1,3,1);
    x = controlF';
    y = controlE';
    y = x+wrapToPi(y-x);
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*1.1);
    ylim([-pi pi]*1.1);
    set(gca,'XTick',tick);
    set(gca,'YTick',tick);
    set(gca,'XTickLabel',tick*180/pi);
    set(gca,'YTickLabel',tick*180/pi);
    xlabel('R. PD');
    ylabel('PD');
    title('Control');
    text(-pi,pi,sprintf('r = %0.2f',corr(x,y)));
    controlPdExplained(nFactors) = corr(x,y);
    
%     subplot(7,9,(nFactors-1)*3+2);
    subplot(1,3,2);
    x = perturbF';
    y = perturbE';
    y = x+wrapToPi(y-x);
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*1.1);
    ylim([-pi pi]*1.1);
    set(gca,'XTick',tick);
    set(gca,'YTick',tick);
    set(gca,'XTickLabel',tick*180/pi);
    set(gca,'YTickLabel',tick*180/pi);
    xlabel('R. PD');
    ylabel('PD');
    title('Perturb');
    text(-pi,pi,sprintf('r = %0.2f',corr(x,y)));
    perturbPdExplained(nFactors) = corr(x,y);
    
%     subplot(7,9,(nFactors-1)*3+3);
    subplot(1,3,3);
    x = (wrapToPi(perturbF-controlF).*sign(meanChange))';
    y = (wrapToPi(perturbE-controlE).*sign(meanChange))';
    % Note that this subtracts a different mean in the real versus recon
%     x = localPdChange(controlF,perturbF);
%     y = localPdChange(controlE,perturbE);
%     y = x+wrapToPi(y-x);
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*.5);
    ylim([-pi pi]*.5);
    set(gca,'XTick',tick);
    set(gca,'YTick',tick);
    set(gca,'XTickLabel',tick*180/pi);
    set(gca,'YTickLabel',tick*180/pi);
    xlabel('\Delta R. PD');
    ylabel('\Delta PD');
    title('Change');
    text(-pi*.4,pi*.4,sprintf('r = %0.2f',corr(x,y)));
    changePdExplained(nFactors) = corr(x,y);
end
% reaimedPd = reaimedCombinedPd(controlRateMean, perturbRateMean);
% 
% [controlRateReaimedExplained, controlRateReaimedRecon] = varianceExplainedLeaveOneOut(controlRate, {reaimedPd});
% [perturbRateReaimedExplained, perturbRateReaimedRecon] = varianceExplainedLeaveOneOut(perturbRate, {reaimedPd});

