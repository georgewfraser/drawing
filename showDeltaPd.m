function showDeltaPd(deltaPd, deltaMd, pdSig, mdSig)
edges = 0:pi/20:pi;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
hSig = histc(deltaPd(pdSig~=0), edges);
hNon = histc(deltaPd(pdSig==0), edges);
subplot(2,1,1);
bar(edgeCenters,[hSig(1:end-1); hNon(1:end-1)]','stacked');
axis tight, box off
xlim([0 pi]);
set(gca,'XTick',[0 pi/2 pi]);
set(gca,'XTickLabel',[0 90 180]);
xlabel('\Delta PD (^\circ)');
ylabel('# Cells');

edges = 0:1/20:1;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
hSig = histc(deltaMd(mdSig~=0), edges);
hNon = histc(deltaMd(mdSig==0), edges);
subplot(2,1,2);
bar(edgeCenters,[hSig(1:end-1); hNon(1:end-1)]','stacked');
axis tight, box off
xlim([0 1]);
set(gca,'XTick',[0 .5 1]);
xlabel('MD ratio');
ylabel('# Cells');

set(gcf,'PaperPosition',[1 1 3.35 3.35]);