function width = waveWidth(fileFormat, dateFormat, dates)
width = cell(size(dates));
for i=1:length(dates)
    width{i} = struct();
    waves = load(sprintf(fileFormat,datestr(dates(i),dateFormat)));
    waves = waves.waves(:,2:5);

    for chan=1:size(waves,1)
        for unit=find(~cellfun(@isempty,waves(chan,:)))
            if(size(waves,1)>100)
                name = sprintf('Unit%0.3d_%d',chan,unit);
            else
                name = sprintf('Unit%0.2d_%d',chan,unit);
            end
                
            w = mean(waves{chan,unit},2);
            w = interp(w,10);
            delta = gradient(w);
            bottom = find(w==min(w),1);
            bottom = abs((1:length(w))'-bottom) < 10;
            bottom = interp1(delta(bottom),find(bottom),0);
            top = find(w==max(w),1);
            top = abs((1:length(w))'-top) < 10;
            top = interp1(delta(top),find(top),0);
            
            peakToPeak = (top-bottom)/400000;
            
            half = w-min(w)/2;
            halfPoints = find(diff(sign(half))~=0);
            half1 = abs((1:length(w))-halfPoints(1))'<10;
            half1 = interp1(half(half1),find(half1),0);
            half2 = abs((1:length(w))-halfPoints(2))'<10;
            half2 = interp1(half(half2),find(half2),0);
            halfWidth = (half2-half1)/400000;
            if(length(halfWidth)~=1)
                keyboard;
            end
            width{i}.(name) = [peakToPeak halfWidth max(w)-min(w)];
        end
    end
end