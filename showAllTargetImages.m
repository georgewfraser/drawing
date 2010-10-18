function showAllTargetImages(rateMean)
fields = fieldnames(rateMean);
plotDim = ceil(sqrt(length(fields)));
for iif=1:length(fields)
    subplot(plotDim,plotDim,iif);
    imagesc(rateMean.(fields{iif}));
    line([5.5 5.5],[0 -1],'LineWidth',2,'Color',[0 0 0])
    line([15.5 15.5],[0 -1],'LineWidth',2,'Color',[0 0 0])
    axis off;
    box off;
end