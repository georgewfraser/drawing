function [channel, slope, modulation] = illusionResponse(drawingSnips, drawingRate)
slope = [];
channel = [];
modulation = [];
for day=1:length(drawingRate)
    
    cnames = fieldnames(drawingRate{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
    for unit=1:length(cnames)
        circle = drawingRate{day}.(cnames{unit})(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        ellipse = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
        illusion = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
        
        circle = mean(circle);
        ellipse = mean(ellipse);
        illusion = mean(illusion);
        
        circle = detrend(circle);
        ellipse = detrend(ellipse);
        illusion = detrend(illusion);
        
        modulation(end+1) = sum(abs(circle));
        
        circle = cycleStats(circle);
        ellipse = cycleStats(ellipse);
        illusion = cycleStats(illusion);
        
        illusion = illusion ./ ellipse;
        slope(end+1) = mean(illusion(4:5))/mean(illusion(1:2));
        
%         if(modulation(end)>2.6 && (slope(end) < .5 || slope(end) > 1.5))
%             circle = drawingRate{day}.(cnames{unit})(~drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
%             ellipse = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&~drawingSnips{day}.is_illusion,:);
%             illusion = drawingRate{day}.(cnames{unit})(drawingSnips{day}.is_ellipse&drawingSnips{day}.is_illusion,:);
% 
%             circle = mean(circle);
%             ellipse = mean(ellipse);
%             illusion = mean(illusion);
% 
%             clf
%             showAllDrawingPlots(struct('a',[circle; circle; ellipse; illusion]));
%             keyboard
%         end
    end
end
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
    cycleRange(i) = sum(abs(circle(cycleStart(i):cycleEnd(i))));
end

% clf, hold on
% plot(circle);
% stem(cycleStart,repmat(max(circle(:)),size(cycleStart)));
% line([1 140],[0 0]);
% keyboard;
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