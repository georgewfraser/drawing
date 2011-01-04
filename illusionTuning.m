function [model, separation, channel] = illusionTuning(drawingSnips, drawingKin, drawingRate)
model = [];
separation = [];
channel = [];
for day=1:length(drawingRate)
    progress = drawingSnips{day}.progress(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
    progress = (progress-2)/2;
    progress = max(progress,0);
    progress = min(progress,1);
    
    cnames = fieldnames(drawingRate{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
    for unit=1:length(cnames)
%         circleX = drawingKin{day}.velX(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
%         circleY = drawingKin{day}.velY(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
%         circleSpeed = sqrt(circleX.^2+circleY.^2);
%         circleX = circleX./circleSpeed;
%         circleY = circleY./circleSpeed;
%         ellipseX = drawingKin{day}.velX(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
%         ellipseY = drawingKin{day}.velY(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
%         ellipseSpeed = sqrt(ellipseX.^2+ellipseY.^2);
%         ellipseX = ellipseX./ellipseSpeed;
%         ellipseY = ellipseY./ellipseSpeed;
%         illusionX = drawingKin{day}.velX(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
%         illusionY = drawingKin{day}.velY(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
%         illusionSpeed = sqrt(illusionX.^2+illusionY.^2);
%         illusionX = illusionX./illusionSpeed;
%         illusionY = illusionY./illusionSpeed;
        
        circle = drawingRate{day}.(cnames{unit})(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        ellipse = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        illusion = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
        
        circle = detrend(circle);
        ellipse = detrend(ellipse);
        illusion = detrend(illusion);
        
%         circleModel = [circleX(:) circleY(:)]\circle(:);
%         ellipseModel = [ellipseX(:) ellipseY(:)]\ellipse(:);
%         
%         motor = [illusionX(:) illusionY(:)]*circleModel;
%         apparentX = illusionX.*1.8;
%         apparentY = illusionY;
%         apparentSpeed = sqrt(apparentX.^2+apparentY.^2);
%         apparentX = apparentX ./ apparentSpeed;
%         apparentY = apparentY ./ apparentSpeed;
%         visual = [apparentX(:) apparentY(:)]*ellipseModel;
%         motor = reshape(motor,numel(motor)/140,140);
%         visual = reshape(visual,numel(visual)/140,140);
        
        visual = repmat(mean(ellipse),size(illusion,1),1);
        motor = repmat(mean(circle),size(illusion,1),1);
        disparity = (motor-visual).*progress;
        
        X = [ones(numel(illusion),1) visual(:) disparity(:)];
        y = illusion(:);
        [b,bint] = regress(y,X);
        bint = bint(3,:)./bint(2,:);
        separation(end+1) = sum(abs(mean(ellipse)-mean(circle)));
%         uncertainty(end+1) = diff(bint);
        model(end+1) = b(3)/b(2);
        
        if(separation(end)>68.3)
            prediction = X*b;
            prediction = reshape(prediction,numel(prediction)/140,140);
%             circle_ = [circleX(:) circleY(:)]*circleModel;
%             circle_ = reshape(circle_,size(circle));
%             ellipse_ = [ellipseX(:) ellipseY(:)]*ellipseModel;
%             ellipse_ = reshape(ellipse_,size(ellipse));
%             clf
%             subplot(3,1,1)
%             plot([mean(circle); mean(circle_)]');
%             subplot(3,1,2)
%             plot([mean(ellipse); mean(ellipse_)]');
%             subplot(3,1,3)
%             plot([mean(illusion); mean(motor)*b(2); mean(visual)*b(2)]');
% %             showAllDrawingPlots(struct('a',[mean(circle); zeros(1,size(circle,2)); mean(ellipse); mean(illusion)]));
            clf, hold on
            plot([mean(circle); mean(ellipse); mean(illusion)]','LineWidth',2);
            plot(mean(prediction),'r:','LineWidth',2);
            title(separation(end));
            keyboard;
        end
    end
end
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