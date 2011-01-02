function showInfoPlot(infoEnd, infoDir, coinfo)
plot([infoDir infoEnd coinfo])
ymin = min(min([infoDir infoEnd coinfo]));
ymax = max(max([infoDir infoEnd coinfo]));
legend('Direction','Endpoint','Coinformation');
ylabel('Information (bits)');
set(gca,'XTick',[5 16]);
line([5 5],[ymin ymax],'Color',[0.8 0.8 0.8]);
line([16 16],[ymin ymax],'Color',[0.8 0.8 0.8]);
set(gca,'XTickLabel',{'Target presentation','Target contact'});
axis tight, box off
set(gcf,'PaperPosition',[1 1 3.35 3.35/1.61803399]);