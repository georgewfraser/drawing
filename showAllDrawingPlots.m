function showAllDrawingPlots(rateMean)
fields = fieldnames(rateMean);
plotDim = min(5,ceil(sqrt(length(fields))));
for iif=1:min(25,length(fields))
    subplot(plotDim,plotDim,iif); hold on;
    img = rateMean.(fields{iif});
    img(isnan(img)) = 0;
    img = img([1 3 4],:);
    maxRange = max(range(img,2));
    for i=1:3
        img(i,:) = img(i,:)-mean(img(i,:));
        img(i,:) = img(i,:)./maxRange;
        img(i,:) = img(i,:)-(i-1);
    end
    plot(img');
    line([145 145],[0 floor(maxRange)/maxRange]);
    text(145,0,num2str(floor(maxRange)));
    box off;
    xtick = 20:20:120;
    set(gca,'XTick',xtick);
    set(gca,'XTickLabel',[]);
    text(0,0,'Circle','HorizontalAlignment','right');
    text(0,-1,'Ellipse','HorizontalAlignment','right');
    text(0,-2,'Illusion','HorizontalAlignment','right');
    axis tight;
end
set(gcf,'PaperPosition',[0 0 plotDim*2 plotDim]);