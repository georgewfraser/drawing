function plotMap(X, maxX)
clf
set(gcf,'Units','inches');
set(gcf,'Position',[1 1 2 2]);
set(gcf,'PaperPosition',[1 1 1 1]);
axes('Position',[0 0 1 1]);
xlim([0 11]);
ylim([0 11]);
hold on
axis off
box off

X = X/maxX;
X = sqrt(X);

for row=1:size(X,1)
    for col=1:size(X,2)
        if(~isnan(X(row,col)))
            plot(col,11-row,'o','MarkerSize',X(row,col)/11*72,'MarkerEdgeColor','none','MarkerFaceColor',[0 0 0]);
        end
    end
end

plot([0 11 11 0 0],[0 0 11 11 0]);