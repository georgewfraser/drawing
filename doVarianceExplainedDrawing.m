[drawingRateExplained, drawingRateRecon, drawingCoeff] = varianceExplainedCrossValidated(drawingRate);

figure(1);
clf;
hold on;
R2 = mean(drawingRateExplained);
plot(R2,'LineWidth',2);
best = find(R2==max(R2));
line(best.*[1 1], R2(best)+[0 .05],'Color',[0 0 0]);
% plot(2,mean(controlRateReaimedExplained),'x','Color',[0 0 0]);
text(best,R2(best)+.05,num2str(best));
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('R^2')
ylim([0 .5]);
box off;