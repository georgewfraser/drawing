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
        
        subplot(2,1,1);
        plot([circle; ellipse; illusion]');
        [cycleRange, magnitude, phase] = cycleStats(circle);
        edges = phase/2/pi*20+(20:20:120);
        line([edges; edges]',[0 max(circle)]);
        
        subplot(2,1,2);
        plot([cycleStats(circle); cycleStats(ellipse); cycleStats(illusion)]');
        keyboard;
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

set(gcf,'PaperPosition',[0 0 3.35 3.35]/2);

end

function [cycleRange, magnitude, phase] = cycleStats(circle)
b = sin((21:120)*2*pi/20)*circle(21:120)';
a = cos((21:120)*2*pi/20)*circle(21:120)';
magnitude = sqrt(a^2+b^2);
phase = -atan2(a,b);

cycleStart = floor(phase/2/pi*20+(20:20:100));
cycleEnd = ceil(phase/2/pi*20+(40:20:120));
cycleRange = nan(1,5);
for i=1:5
    cycleRange(i) = range(circle(cycleStart(i):cycleEnd(i)));
end
end