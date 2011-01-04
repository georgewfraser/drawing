function showIllusionResponse(channel, slope, modulation)
edges = 0:.05:2;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
ant = histc(slope(channel<100 & modulation>quantile(modulation,.5)),edges);
post = histc(slope(channel>100 & modulation>quantile(modulation,.5)),edges);
% ant = histc(slope(channel<100),edges);
% post = histc(slope(channel>100),edges);

subplot(2,1,1);
bar(edgeCenters,ant(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',0:.5:2);
xlabel('\Delta Modulation');
ylabel('# Cells');
title('PMv');
axis tight
box off
subplot(2,1,2);
bar(edgeCenters,post(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',0:.5:2);
xlabel('\Delta Modulation');
ylabel('# Cells');
title('M1');
axis tight
box off

set(gcf,'PaperPosition',[0 0 3.35 3.35])