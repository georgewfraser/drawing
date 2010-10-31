

rate = snipRate(controlSnips{1},controlData{1});
controlEmpiricalPd = empiricalPd(controlSnips(1), {rate});
% Scramble the trials within target directions
th = -pi+pi/8:pi/8:pi;
trialTargets = controlSnips{1}.targetPos-controlSnips{1}.startPos;
trialTh = cart2pol(trialTargets(:,1),trialTargets(:,2));
for i=1:length(th)
    sel = find(abs(wrapToPi(th(i)-trialTh))<.001);
    fields = fieldnames(rate);
    for j=1:length(fields)
        % 5 point smoother
        rate.(fields{j})(sel,:) = rate.(fields{j})(sel(randperm(length(sel))),:)+rate.(fields{j})(sel(randperm(length(sel))),:)+rate.(fields{j})(sel(randperm(length(sel))),:)+rate.(fields{j})(sel(randperm(length(sel))),:)+rate.(fields{j})(sel(randperm(length(sel))),:);
    end
end
% Take only right before invisible zone exit
rate = structfun(@(x) x(:,9), rate, 'UniformOutput', false);
rate = unravel(rate);
rate = bsxfun(@minus,rate,mean(rate));

ideal = trialTargets(:,1:2);% repmat(trialTargets(:,1:2),5,1);
pd = ideal \ rate;
pva = rate*pinv(pd);

% Fix any global distortions
pva = pva * (pva \ ideal);
errors = pva-ideal;

[x, y] = pol2cart(th',norm(trialTargets(1,:)));
targets = [x y];

xtraj = nan(10,16);
ytraj = nan(10,16);
for targ=1:16
    cursor = [0 0];
    for time=1:10
        aim = targets(targ,:)-cursor;
        out = aim+errors(ceil(rand(1)*size(errors,1)),:);
        xtraj(time,targ) = out(1);
        ytraj(time,targ) = out(2);
    end
end
