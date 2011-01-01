function [model, uncertainty, channel] = illusionTuning(drawingSnips, drawingKin, drawingRate)
model = [];
uncertainty = [];
channel = [];
for day=1:length(drawingRate)
    progress = drawingSnips{day}.progress(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
    progress = (progress-2)/2;
    progress = max(progress,0);
    progress = min(progress,1);
    
    Vx = cellfun(@(day) day.velX, drawingKin, 'UniformOutput', false);
    Vy = cellfun(@(day) day.velY, drawingKin, 'UniformOutput', false);
    
    
    cnames = fieldnames(drawingRate{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
    for unit=1:length(cnames)
        circleX = drawingKin{day}.velX(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        circleY = drawingKin{day}.velY(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        circleSpeed = sqrt(circleX.^2+circleY.^2);
        circleDX = circleX./circleSpeed;
        circleDY = circleY./circleSpeed;
        ellipseX = drawingKin{day}.velX(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        ellipseY = drawingKin{day}.velY(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        ellipseSpeed = sqrt(ellipseX.^2+ellipseY.^2);
        ellipseDX = ellipseX./ellipseSpeed;
        ellipseDY = ellipseY./ellipseSpeed;
        illusionX = drawingKin{day}.velX(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
        illusionY = drawingKin{day}.velY(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
        illusionSpeed = sqrt(illusionX.^2+illusionY.^2);
        illusionDX = illusionX./illusionSpeed;
        illusionDY = illusionY./illusionSpeed;
        
        circle = drawingRate{day}.(cnames{unit})(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        ellipse = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        illusion = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
        
        circle = detrend(circle);
        ellipse = detrend(ellipse);
        illusion = detrend(illusion);
        
        kinModel = [circleX(:) circleY(:) circleDX(:) circleDY(:); ellipseX(:) ellipseY(:) ellipseDX(:) ellipseDY(:)]\[circle(:); ellipse(:)];
        
        motor = [illusionX(:) illusionY(:) illusionDX(:) illusionDY(:)]*kinModel;
        apparentX = illusionX.*(1+progress*.8);
        apparentDX = apparentX ./ sqrt(apparentX.^2+illusionY.^2);
        apparentDY = illusionY ./ sqrt(apparentX.^2+illusionY.^2);
        visual = [apparentX(:) illusionY(:) apparentDX(:) apparentDY(:)]*kinModel;
        
%         circle = reshape(circle,size(illusion));
%         ellipse = reshape(ellipse,size(illusion));
        
        y = illusion(:)-visual;
        x = (motor-visual);
        x = reshape(x,numel(x)/140,140);
        y = reshape(y,numel(y)/140,140);
        visual = reshape(visual,numel(visual)/140,140);
        motor = reshape(motor,numel(motor)/140,140);
        [b,bint] = regress(y(:),x(:));
        prediction = mean(visual)+b*mean(x);
        uncertainty(end+1) = diff(bint);
        model(end+1) = b;
        
%         if(range(mean(circle))>10)
%             clf
%             subplot(2,1,1);
%             plot([mean(circle); mean(ellipse); mean(illusion)]');
%             subplot(2,1,2);
%             plot([mean(motor); mean(visual); prediction]');
% %             showAllDrawingPlots(struct('a',[mean(circle); zeros(1,size(circle,2)); mean(ellipse); mean(illusion)]));
%             keyboard;
%         end
    end
end
 
edges = -1:.10:2;
edgeCenters = (edges(1:end-1)+edges(2:end))/2;
ant = histc(model(uncertainty < quantile(uncertainty, .25) & channel<100),edges);
post = histc(model(uncertainty < quantile(uncertainty, .25) & channel>100),edges);
subplot(2,1,1);
bar(edgeCenters,ant(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',[0 1]);
set(gca,'XTickLabel',{'Visual', 'Motor'});
ylabel('# Cells');
title('Anterior array');
axis tight
box off
subplot(2,1,2);
bar(edgeCenters,post(1:end-1),'FaceColor',[0 0 0]);
set(gca,'XTick',[0 1]);
set(gca,'XTickLabel',{'Visual', 'Motor'});
ylabel('# Cells');
title('Posterior array');
axis tight
box off

set(gcf,'PaperPosition',[0 0 3.35 3.35]/2)
end

function circle = detrend(circle)
% Remove mean
circle = circle-mean(circle(:));
% Remove linear trend
trend = repmat(1:140,size(circle,1),1);
trend = trend-mean(trend(:));
trend = regress(circle(:),trend(:))*trend;
circle = circle - trend;
end
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