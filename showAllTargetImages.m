function showAllTargetImages(rateMean)
fields = fieldnames(rateMean);
plotDim = ceil(sqrt(length(fields)));
for iif=1:length(fields)
    subplot(plotDim,plotDim,iif);
    imagesc(rateMean.(fields{iif}));
    axis off;
    box off;
    axis image;
end