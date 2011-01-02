function showBCIPixelHist(controlSnipsMean, pixel, speed)
clf
speed = speed ./ max(speed) .* max(sum(pixel));

target = controlSnipsMean{1}.targetPos;
az = cart2pol(target(:,1),target(:,2));

subplot(2,1,1), hold on
bar(sum(pixel));
plot(speed);
set(gca,'XTick',[5 16]);
set(gca,'XTickLabel',{'Target presentation', 'Target contact'});
xlabel('Time');
ylabel('# Neurons');
axis tight, box off

tCount = sum(pixel,2);
tSig = binocdf(tCount,sum(tCount),1/numel(tCount));
sigLevel = .05/2/numel(tSig);
tSig = tSig<sigLevel | tSig>1-sigLevel;

subplot(2,1,2);
bar(az,tCount);
for x=find(tSig)'
    text(az(x),tCount(x),'*');
end
set(gca,'XTick',[-pi/2 0 pi/2 pi]);
set(gca,'XTickLabel',{'Down','Right','Up','Left'});
xlabel('Direction');
ylabel('# Neurons');
axis tight, box off


set(gcf,'PaperPosition',[1 1 3.35 3.35]);