function showAllDrawingImages(rateMean)
fields = fieldnames(rateMean);
% plotDim = ceil(sqrt(length(fields)));
for iif=1:min(8*15,length(fields))
    subplot(8,15,iif);
    img = rateMean.(fields{iif});
    img = [reshape(img(1,21:120),20,5)'; nan(1,20); reshape(img(2,21:120),20,5)'; nan(1,20); reshape(img(3,21:120),20,5)'; nan(1,20); reshape(img(4,21:120),20,5)'];
    imagesc(img);
    axis off;
    box off;
    axis image;
end