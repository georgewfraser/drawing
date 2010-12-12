function showAllDrawingPlots(rateMean)
fields = fieldnames(rateMean);
plotDim = min(5,ceil(sqrt(length(fields))));
for iif=1:min(25,length(fields))
    subplot(plotDim,plotDim,iif);
    img = rateMean.(fields{iif});
    img(isnan(img)) = 0;
%     img = [reshape(img(1,21:120),20,5)'; nan(1,20); reshape(img(2,21:120),20,5)'; nan(1,20); reshape(img(3,21:120),20,5)'; nan(1,20); reshape(img(4,21:120),20,5)'];
%     imagesc(img);
    img(1,:) = img(1,:)-max(img(1,:));
    for i=2:4
        img(i,:) = img(i,:)-max(img(i,:))+min(img(i-1,:));
    end
    plot(img');
    axis off;
%     box off;
%     axis image;
end