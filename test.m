motor = sin(0:pi/100:pi*8);
illusion = (1:length(motor))./length(motor);
visual = motor .* illusion;
data = [motor; visual]';

pd_true = nan(2,1000);
pd_fit = nan(2,1000);
pd_std = nan(2,1000);
th_true = nan(1000,1);
th_fit = nan(1000,1);

for sample=1:1000
    pd_true(:,sample) = randn(2,1);
    firing = data*pd_true(:,sample) + randn(size(data,1),1);
    pd_fit(:,sample) = regress(firing,data);
    pd_std(:,sample) = pd_fit(:,sample).*var(data)'./var(firing);

    th_true(sample) = cart2pol(pd_true(1),pd_true(2));
    th_fit(sample) = cart2pol(pd_fit(1),pd_fit(2));
end
figure(1);
plot(data);
figure(2);
subplot(2,1,1);
plot(data*pd_true(:,sample));
subplot(2,1,2);
plot(firing);
figure(3);
subplot(1,2,1)
plot(pd_true(1,:),pd_fit(1,:),'.');
line([-4 4],[-4 4]);
axis image;
subplot(1,2,2)
plot(pd_true(2,:),pd_fit(2,:),'.');
line([-4 4],[-4 4]);
axis image;
figure(4);
subplot(1,2,1)
plot(pd_true(1,:),pd_std(1,:),'.');
line([-4 4],[-4 4]);
axis image;
subplot(1,2,2)
plot(pd_true(2,:),pd_std(2,:),'.');
line([-4 4],[-4 4]);
axis image;
% figure(4);
% x = th_true;
% y = th_fit;
% y = x+wrapToPi(y-x);
% plot(x,y,'.')