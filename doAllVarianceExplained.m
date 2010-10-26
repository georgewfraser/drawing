% % WARNING! These functions take a very long time
[controlRateExplained, controlRateRecon, controlCoeff] = varianceExplainedCrossValidated(controlRate);
% controlRateSurvivorsExplained = varianceExplainedSurvivors(controlRate, survival);
% % Other functions not as ridiculously slow
% [perturbRateExplained, perturbRateRecon] = varianceExplainedLeaveOneOut(perturbRate, controlCoeff);
controlReaimedPd = reaimedPd(controlRateMean);
[controlRateReaimedExplained, controlRateReaimedRecon] = varianceExplainedLeaveOneOut(controlRate, {controlReaimedPd});
[perturbRateReaimedExplained, perturbRateReaimedRecon] = varianceExplainedLeaveOneOut(perturbRate, {controlReaimedPd});
% controlReaimedTimePd = reaimedTimePd(controlRateMean);
% [controlRateReaimedTimeExplained, controlRateReaimedTimeRecon] = varianceExplainedLeaveOneOut(controlRate, {controlReaimedTimePd});
% [perturbRateReaimedTimeExplained, perturbRateReaimedTimeRecon] = varianceExplainedLeaveOneOut(perturbRate, {controlReaimedTimePd});
% controlRateCrossExplained = varianceExplainedCrossDay(controlRate, coeff, survival);
%perturbRateCrossExplained = varianceExplainedCrossDay(perturbRate, coeff, survival);

figure(1);
clf;
hold on;
R2 = mean(controlRateExplained);
plot(R2,'k');
best = find(R2==max(R2));
line(best.*[1 1], R2(best)+[0 .05],'Color',[0 0 0]);
text(best,R2(best)+.05,num2str(best));

% R2 = mean(perturbRateExplained);
% plot(R2,'Color',[.8 .8 .8]);
% best = find(R2==max(R2));
% line(best.*[1 1], R2(best)-[0 .05],'Color',[.8 .8 .8]);
% text(best,R2(best)-.05,num2str(best));

plot(2,mean(controlRateReaimedExplained),'x','Color',[0 0 0]);
% plot(2,mean(perturbRateReaimedExplained),'x','Color',[.8 .8 .8]);
% plot(4,mean(controlRateReaimedTimeExplained),'x','Color',[0 0 0]);
% plot(4,mean(perturbRateReaimedTimeExplained),'x','Color',[.8 .8 .8]);

% legend('Control','Perturb')
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('R^2')
ylim([0 .6]);

% figure(2);
% clf;
% hold on;
% R2 = mean(controlRateCrossExplained(2:end,:));
% plot(R2,'k');
% best = find(R2==max(R2));
% line(best.*[1 1], R2(best)+[0 .05],'Color',[0 0 0]);
% text(best,R2(best)+.05,num2str(best));
% 
% R2 = mean(controlRateSurvivorsExplained(1:end-1,:));
% plot(R2,'Color',[.8 .8 .8]);
% best = find(R2==max(R2));
% line(best.*[1 1], R2(best)-[0 .05],'Color',[.8 .8 .8]);
% text(best,R2(best)-.05,num2str(best));
% 
% legend('Cross-day','Same-day')
% set(gcf,'PaperPosition',[0 0 3.35 2])
% xlabel('# Factors');
% ylabel('R^2')
% ylim([0 .6]);

% controlExplained = varianceExplained(controlRate, coeff);
% perturbExplained = varianceExplained(perturbRate, coeff);
% coeffReaim = reaimedPd(controlRateMean);
% reaimControlExplained = varianceExplained(controlRate, {coeffReaim});
% reaimPerturbExplained = varianceExplained(perturbRate, {coeffReaim});
% coeffReaimTime = reaimedTimePd(controlRateMean);
% reaimTimeControlExplained = varianceExplained(controlRate, {coeffReaimTime});
% reaimTimePerturbExplained = varianceExplained(perturbRate, {coeffReaimTime});
% coeffPd = empiricalPd(controlRateMean);
% velControlExplained = varianceExplained(controlRate, {coeffPd});
% velPerturbExplained = varianceExplained(perturbRate, {coeffPd});
% 
% figure(1);
% clf;
% hold on;
% plot(mean(controlExplained));
% plot(mean(perturbExplained),'r');
% plot(2,mean(reaimControlExplained),'o');
% plot(2,mean(reaimPerturbExplained),'ro');
% plot(4,mean(reaimTimeControlExplained),'o');
% plot(4,mean(reaimTimePerturbExplained),'ro');
% plot(2,mean(velControlExplained),'x');
% plot(2,mean(velPerturbExplained),'rx');
% 
% 
% controlExplained = varianceExplained(controlRateMean, coeff);
% perturbExplained = varianceExplained(perturbRateMean, coeff);
% coeffReaim = reaimedPd(controlRateMean);
% reaimControlExplained = varianceExplained(controlRateMean, {coeffReaim});
% reaimPerturbExplained = varianceExplained(perturbRateMean, {coeffReaim});
% coeffReaimTime = reaimedTimePd(controlRateMean);
% reaimTimeControlExplained = varianceExplained(controlRateMean, {coeffReaimTime});
% reaimTimePerturbExplained = varianceExplained(perturbRateMean, {coeffReaimTime});
% coeffPd = empiricalPd(controlRateMean);
% velControlExplained = varianceExplained(controlRateMean, {coeffPd});
% velPerturbExplained = varianceExplained(perturbRateMean, {coeffPd});
% 
% figure(2);
% clf;
% hold on;
% plot(mean(controlExplained));
% plot(mean(perturbExplained),'r');
% plot(2,mean(reaimControlExplained),'o');
% plot(2,mean(reaimPerturbExplained),'ro');
% plot(4,mean(reaimTimeControlExplained),'o');
% plot(4,mean(reaimTimePerturbExplained),'ro');
% plot(2,mean(velControlExplained),'x');
% plot(2,mean(velPerturbExplained),'rx');
