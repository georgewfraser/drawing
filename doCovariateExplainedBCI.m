controlFactorsMean = cell(size(controlFactors));
for col=1:size(controlFactorsMean,2)
    controlFactorsMean(:,col) = meanByTarget(controlSnips, controlFactors(:,col));
end
[pos, vel, acc, hold, holdA, holdB] = covariateRepresentation(controlFactorsMean, controlKinMean);

figure(1); clf;
plot([mean(pos); mean(vel); mean(acc); mean(hold)]','LineWidth',2);
legend('Position', 'Velocity', 'Acceleration', 'Hold');
set(gcf,'PaperPosition',[0 0 3.35 3.35/2])
xlabel('# Factors');
ylabel('Covariate R^2')
ylim([0 1]);
box off;