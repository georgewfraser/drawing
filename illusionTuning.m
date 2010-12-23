function [model, modulation, channel] = illusionTuning(drawingRateMean)
model = [];
modulation = [];
channel = [];
for day=1:length(drawingRateMean)
    cnames = fieldnames(drawingRateMean{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
    for unit=1:length(cnames)
        circle = drawingRateMean{day}.(cnames{unit})(1,80:120);
        ellipse = drawingRateMean{day}.(cnames{unit})(3,80:120);
        illusion = drawingRateMean{day}.(cnames{unit})(4,80:120);
        
        ellipse = ellipse-circle;
        illusion = illusion-circle;
        
        modulation(end+1) = norm(ellipse);
        model(end+1) = illusion*ellipse'/norm(ellipse)^2;
        
        if(modulation(end)>4)
            keyboard;
        end
    end
end

edges = -1:.10:2;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
ant = histc(model(modulation>quantile(modulation,.5) & channel<100),edges);
post = histc(model(modulation>quantile(modulation,.5) & channel>100),edges);
subplot(2,1,1);
bar(edgeCenters,ant(1:end-1));
subplot(2,1,2);
bar(edgeCenters,post(1:end-1));
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