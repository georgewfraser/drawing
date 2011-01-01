function showPreferredPixelHist(coutSnipsMean, pixel)
clf

target = coutSnipsMean{1}.targetPos-coutSnipsMean{1}.startPos;
outward = sum(abs(coutSnipsMean{1}.startPos),2)==0;

subplot(6,1,1);
bar(sum(pixel(outward,:)),'FaceColor',[0 0 0]);
ymax = max(sum(pixel(outward,:)));
ylabel('# Cells');
set(gca,'XTick',[5 16]);
set(gca,'XTickLabel',{'Target presentation', 'Target contact'});
line([5 5],[0 ymax],'Color',[0.8 0.8 0.8]);
line([16 16],[0 ymax],'Color',[0.8 0.8 0.8]);
axis tight, box off
title('Center-out');

subplot(6,1,2);
bar(sum(pixel(~outward,:)),'FaceColor',[0 0 0]);
ymax = max(sum(pixel(~outward,:)));
ylabel('# Cells');
set(gca,'XTick',[5 16]);
set(gca,'XTickLabel',{'Target presentation', 'Target contact'});
line([5 5],[0 ymax],'Color',[0.8 0.8 0.8]);
line([16 16],[0 ymax],'Color',[0.8 0.8 0.8]);
axis tight, box off
title('Out-center');

% Coordinate wierdness.  I want z+ to be az=0 el=0
[az,el] = cart2sph(target(:,3),target(:,1),target(:,2));
tCount = sum(pixel,2);
fprintf('Max blob = %d\n',max(tCount));
tHist = tCount/max(tCount);
tHist = sqrt(tHist)*72/3.5;
tSig = binocdf(tCount,sum(tCount),1/numel(tCount));
sigLevel = .05/2/numel(tSig);
tSig = tSig<sigLevel | tSig>1-sigLevel;

subplot(6,1,3:4), hold on
for iit=find(outward)'
    plot(az(iit),el(iit),'o','MarkerSize',tHist(iit),'MarkerFaceColor',[.5 .5 .5]-tSig(iit)*.5,'MarkerEdgeColor','none');
end
set(gca,'XTick',[-pi/2 0 pi/2 pi]);
set(gca,'XTickLabel',{'Left','Towards','Right','Away'});
set(gca,'YTick',[-pi/2 pi/2]);
set(gca,'YTickLabel',{'Down','Up'});
axis image, box off
xlim([-pi*.75 pi]*1.1);
ylim([-pi/2 pi/2]*1.2);
title('Center-out');

subplot(6,1,5:6), hold on
for iit=find(~outward)'
    plot(az(iit),el(iit),'o','MarkerSize',tHist(iit),'MarkerFaceColor',[.5 .5 .5]-tSig(iit)*.5,'MarkerEdgeColor','none');
end
set(gca,'XTick',[-pi/2 0 pi/2 pi]);
set(gca,'XTickLabel',{'Left','Towards','Right','Away'});
set(gca,'YTick',[-pi/2 pi/2]);
set(gca,'YTickLabel',{'Down','Up'});
axis image, box off
xlim([-pi*.75 pi]*1.1);
ylim([-pi/2 pi/2]*1.2);
title('Out-center');

set(gcf,'PaperPosition',[1 1 3.35 3.35*2]);


