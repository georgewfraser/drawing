function [model, modulation, channel] = illusionTuning(drawingRateMean, drawingSnipsMean)
model = [];
modulation = [];
channel = [];
for day=1:length(drawingRateMean)
    progress = drawingSnipsMean{day}.progress(4,:);
%     progress = (progress-2)/2;
%     progress = max(progress,0);
%     progress = min(progress,1);
    progress = progress>4;
    
    cnames = fieldnames(drawingRateMean{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
    for unit=1:length(cnames)
        circle = drawingRateMean{day}.(cnames{unit})(1,:);
        ellipse = drawingRateMean{day}.(cnames{unit})(3,:);
        illusion = drawingRateMean{day}.(cnames{unit})(4,:);
        
        circle = circle-mean(circle);
        ellipse = ellipse-mean(ellipse);
        illusion = illusion-mean(illusion);
        
        b = regress(illusion', [ellipse; (circle-ellipse).*progress]');
        
        modulation(end+1) = norm(ellipse-circle);
        model(end+1) = b(2);
        
        if(modulation(end)>10)
            clf;
            showAllDrawingPlots(struct('a',drawingRateMean{day}.(cnames{unit})));
            keyboard;
        end
    end
end

edges = -1:.20:2;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
% ant = histc(model(modulation>quantile(modulation(channel<100),.5) & channel<100),edges);
% post = histc(model(modulation>quantile(modulation(channel>100),.5) & channel>100),edges);
ant = histc(model(channel<100),edges);
post = histc(model(channel>100),edges);
subplot(2,1,1);
bar(edgeCenters,ant(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',[0 1]);
set(gca,'XTickLabel',{'Motor', 'Visual'});
ylabel('# Cells');
title('PMv');
axis tight
box off
subplot(2,1,2);
bar(edgeCenters,post(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',[0 1]);
set(gca,'XTickLabel',{'Motor', 'Visual'});
ylabel('# Cells');
title('M1');
axis tight
box off

set(gcf,'PaperPosition',[0 0 3.35 3.35]/2)
% 
% gscatter(model(:,1),model(:,2),channel>100,'br','.x',4)
% biggest = sqrt(sum(model.^2,2));
% [biggest,idx] = sort(biggest,'descend');
% for i=1:100
%     text(model(idx(i),1),model(idx(i),2),num2str(idx(i)));
% end
% axis image
% line([0 25],[0 25])
% line([0 25],[0 -25])
% line([0 25],[0 0])
% xlim([0 25]);
% ylim([-25 25])
% xlabel('Motor');
% ylabel('Visual');
% set(gcf,'PaperPosition',[0 0 3.35/2 3.35])