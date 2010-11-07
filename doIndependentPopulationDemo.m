rate = snipStabilizedSmoothedRate(controlSnips{1},controlData{1});
% Take only right before invisible zone exit
rate = structfun(@(x) x(:,9), rate, 'UniformOutput', false);
rate = unravel(rate);
rate = bsxfun(@minus,rate,mean(rate));

th = -pi+pi/8:pi/8:pi;
trialTargets = controlSnips{1}.targetPos-controlSnips{1}.startPos;
trialTh = cart2pol(trialTargets(:,1),trialTargets(:,2));
ideal = trialTargets(:,1:2);
pd = ideal \ rate;
errors = rate-ideal*pd;

mu = mean(errors);
sigma = cov(errors);

[x, y] = pol2cart(th',norm(trialTargets(1,:)));
targets = [x y];

clf; 
subplot(1,2,1);
hold on;
xtraj = nan(10,16);
ytraj = nan(10,16);
for targ=1:16
    cursor = [0 0];
    for time=1:10
        aim = targets(targ,:)-cursor;
        aim = aim ./ norm(aim) .* norm(targets(targ,:));
        population = aim*pd+mvnrnd(mu,sigma);
        out = population*pinv(pd)./10;
        xtraj(time,targ) = out(1);
        ytraj(time,targ) = out(2);
    end
    plot(targets(targ,1),targets(targ,2),'o');
end

plot(cumsum(xtraj),cumsum(ytraj),'LineWidth',2)
axis image;
axis off; 
box off;
title('Covariance noise model');

subplot(1,2,2);
hold on;
sigma = diag(var(errors));
xtraj = nan(10,16);
ytraj = nan(10,16);
for targ=1:16
    cursor = [0 0];
    for time=1:10
        aim = targets(targ,:)-cursor;
        aim = aim ./ norm(aim) .* norm(targets(targ,:));
        population = aim*pd+mvnrnd(mu,sigma);
        out = population*pinv(pd)./10;
        xtraj(time,targ) = out(1);
        ytraj(time,targ) = out(2);
    end
    plot(targets(targ,1),targets(targ,2),'o');
end

plot(cumsum(xtraj),cumsum(ytraj),'LineWidth',2);
axis image;
axis off; 
box off;
title('Independent noise model');