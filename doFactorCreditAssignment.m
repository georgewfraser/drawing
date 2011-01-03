function doFactorCreditAssignment(controlSnips, controlRate, controlRateExplained, model, controlFactors, perturbSnips, perturbRate, perturbFactors, controlPd, perturbPd)
best = bsxfun(@eq,controlRateExplained,max(controlRateExplained,[],2));
controlFactors = controlFactors'; controlFactors = controlFactors(best');
perturbFactors = perturbFactors'; perturbFactors = perturbFactors(best');
model = model'; model = model(best');

t=6:15;

controlEmpiricalPd = empiricalPd(controlSnips, controlFactors, t);
perturbEmpiricalPd = empiricalPd(perturbSnips, perturbFactors, t);

controlD = cell(size(controlPd));
perturbD = cell(size(perturbPd));
for day=1:length(model)
    % Convert factors->neurons model to factors->[x,y] model
    controlD{day} = model{day}*unravel(controlPd{day})';
    perturbD{day} = model{day}*unravel(perturbPd{day})';
end
controlD = cell2mat(controlD)';
perturbD = cell2mat(perturbD)';
controlE = unravelAll(controlEmpiricalPd);
perturbE = unravelAll(perturbEmpiricalPd);

figure(2), clf, hold on
plot(controlD(1,:),controlD(2,:),'bx')
plot(perturbD(1,:),perturbD(2,:),'rx')
for i=1:length(perturbD)
    line([controlD(1,i) perturbD(1,i)],[controlD(2,i) perturbD(2,i)]); 
end
figure(3), clf, hold on
plot(controlE(1,:),controlE(2,:),'bx')
plot(perturbE(1,:),perturbE(2,:),'rx')
for i=1:length(perturbD)
    line([controlE(1,i) perturbE(1,i)],[controlE(2,i) perturbE(2,i)]); 
end
keyboard;


% Convert to polar coordinates
controlD = cart2pol(controlD(1,:),controlD(2,:));
perturbD = cart2pol(perturbD(1,:),perturbD(2,:));
controlE = cart2pol(controlE(1,:),controlE(2,:));
perturbE = cart2pol(perturbE(1,:),perturbE(2,:));

deltaD = wrapToPi(perturbD-controlD);
deltaE = wrapToPi(perturbE-controlE);

% Day of experiment for each pd in the
pdDay = cell(size(controlFactors));
for day=1:length(pdDay)
    pdDay{day} = repmat(day,length(fieldnames(controlFactors{day})),1);
end
pdDay = cell2mat(pdDay)';

direction = nan(size(pdDay));
for day=1:length(controlPd)
    direction(pdDay==day) = sign(mean(deltaD(pdDay==day)));
end

deltaD = deltaD.*direction;
deltaE = deltaE.*direction;

plot(deltaD,deltaE,'.');
xlabel('\Delta Decode PD');
ylabel('\Delta Empirical PD');

keyboard;
end