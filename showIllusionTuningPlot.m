function showIllusionTuningPlot(model, separation, channel)
edges = -1:.10:2;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
% ant = histc(1-model(separation > quantile(separation, .75) & channel<100),edges);
% post = histc(1-model(separation > quantile(separation, .75) & channel>100),edges);
ant = histc(1-model(channel<100),edges);
post = histc(1-model(channel>100),edges);

subplot(2,1,1);
bar(edgeCenters,ant(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',[0 1]);
set(gca,'XTickLabel',{'Actual', 'Visual'});
ylabel('# Cells');
title('Anterior array');
axis tight
box off
subplot(2,1,2);
bar(edgeCenters,post(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',[0 1]);
set(gca,'XTickLabel',{'Actual', 'Visual'});
ylabel('# Cells');
title('Posterior array');
axis tight
box off

set(gcf,'PaperPosition',[0 0 3.35 3.35]/2)