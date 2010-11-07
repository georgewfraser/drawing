% Compute control coefficients
% controlCoeff = dayByDayFactors(controlRate);
% perturbCoeff = dayByDayFactors(perturbRate);

% Compute a distribution for the hypothesis that the subspaces are driven
% by the tuning functions and the output preferred directions
controlMeanCoeff = dayByDayFactors(controlRateMean);
perturbMeanCoeff = dayByDayFactors(perturbRateMean);

controlEmpiricalPd = reaimedPd(controlRateMean);
perturbEmpiricalPd = reaimedPd(perturbRateMean);

% This should show very little change in the factors, meaning the
% dependence will be very high.
latentHypothesis = weightedFactorDependence(controlMeanCoeff, perturbMeanCoeff);

% This should show much more change in the factors because the perturbed
% units are moving around their tuning.  The dependence should be lower.
taskHypothesis = cell(10,1);
for sample=1:10
    fprintf('Sample %d\n',sample);
    perturbMeanFake = randomizePdChanges(controlEmpiricalPd, perturbEmpiricalPd, controlRateMean);
    perturbMeanCoeffFake = dayByDayFactors(perturbMeanFake);
    taskHypothesis{sample} = weightedFactorDependence(controlMeanCoeff, perturbMeanCoeffFake);
end
taskHypothesis = cell2mat(taskHypothesis);

clf; hold on;
boot = bootstrp(1000,@mean,latentHypothesis);
plot(mean(latentHypothesis),'LineWidth',2);
plot(mean(taskHypothesis),'g','LineWidth',2);
legend('Latent','Null');
plot(quantile(boot,.05),'--');
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('Subspace similarity')
ylim([0 1]);
