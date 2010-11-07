% drawingCoeff = dayByDayFactors(drawingRate);
[motor, discrepancy, absDiscrepancy] = covariateRepresentationDrawing(drawingCoeff, drawingSnips, drawingRate, drawingKin);

figure(1); clf;
plot([mean(motor); mean(discrepancy); mean(absDiscrepancy)]','LineWidth',2);
legend('Motor', 'Discrepancy', 'Absolute discrepancy');
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('Covariate R^2')
ylim([0 1]);
box off;