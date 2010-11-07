combinedRate = cell(size(controlRate));
for day=1:length(combinedRate)
    fields = fieldnames(controlRate{day});
    for unit=1:length(fields)
        combinedRate{day}.(fields{unit}) = [controlRate{day}.(fields{unit}); perturbRate{day}.(fields{unit})];
    end
end

combinedCoeff = dayByDayFactors(combinedRate);
combinedAngles = daySeparationSubspaceAngles(combinedCoeff, survival);

% Generate fake perturbations for comparison
controlEmpiricalPd = empiricalPd(controlSnips, controlRate);
perturbEmpiricalPd = empiricalPd(perturbSnips, perturbRate);
N_SAMPLES = 10;

combinedAnglesFake = cell(N_SAMPLES,1);
for sample=1:N_SAMPLES
    fprintf('Sample %d\n',sample);
    perturbMeanFake = randomizePdChanges(controlEmpiricalPd, perturbEmpiricalPd, controlRateMean);
    combinedFake = cell(size(controlRateMean));
    for day=1:length(controlRateMean)
        fields = fieldnames(controlRateMean{day});
        combinedFake{day} = struct();
        for unit=1:length(fields)
            combinedFake{day}.(fields{unit}) = [controlRateMean{day}.(fields{unit}); perturbMeanFake{day}.(fields{unit})];
        end
    end
    combinedCoeffFake = dayByDayFactors(combinedFake);
    combinedAnglesFake{sample} = daySeparationSubspaceAngles(combinedCoeffFake, survival);
end
combinedAnglesFake = cell2mat(combinedAnglesFake);

clf; hold on;
boot = bootstrp(1000,@mean,cos(combinedAngles(1:end-1,:)));
plot(mean(cos(combinedAngles(1:end-1,:))));
plot(mean(cos(combinedAnglesFake(1:end-1,:))),'g');
legend('Latent','Null');
plot(quantile(boot,.05),'--');
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('Subspace similarity')
ylim([0 1]);
