function showFactorGrid(factors)
clf;

for day=1:10
    fnames = fieldnames(factors{day});
    for f=1:min(10,length(fnames))
        img = factors{day}.(fnames{f});
%         img = bsxfun(@plus, img, 1.*(1:size(img,1))');
        
        subplot(10,10,(day-1)*10+f); hold on;
%         plot(img','k');
        imagesc(img);
        for t=[1 6 11 16]
            text(0,t,sprintf('Target %d',t),'HorizontalAlignment','right');
        end
        text(5.5,-1,'A','HorizontalAlignment','center','VerticalAlignment','top');
        text(15.5,-1,'B','HorizontalAlignment','center','VerticalAlignment','top'); 
        axis off;
        box off;
%         plot([1 size(img,2)],max(rangeImg).*(1:length(rangeImg))'*[1 1],'k:');
    end
end

set(gcf,'PaperPosition',[0 0 30 20]);
set(gcf,'PaperSize',[30 20]);