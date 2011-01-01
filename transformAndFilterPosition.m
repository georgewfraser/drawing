function [posTime, pos] = transformAndFilterPosition(data) 
posTime = data.kinematics.PlexonTime;
if(~isfield(data.kinematics,'CursorPosition'))
    data.kinematics.CursorPosition = data.kinematics.Markers;
end
pos = data.kinematics.CursorPosition;
cursor_transform = data.header.CursorTransform(1:3,:);
cursor_transform(1,:) = cursor_transform(1,:) ./ abs(sum(cursor_transform(1,1:3)));
pos = [pos ones(size(pos,1),1)] * cursor_transform';
% Guess values for out of view
outOfView = sqrt(sum(pos.^2,2))>5;
outStart = find(diff(outOfView)==1);
outEnd = find(diff(outOfView)==-1);
if(outOfView(1))
    outEnd = outEnd(2:end);
end
if(outOfView(end))
    outStart = outStart(1:end-1);
end
for outSeg=1:length(outStart)
    n = outEnd(outSeg)-outStart(outSeg)+1;
    pos(outStart(outSeg):outEnd(outSeg),:) = repmat(pos(outStart(outSeg),:),n,1);
end
% Filter to 5 Hz because we are going the resolution of the snips is as low
% as 10 Hz
if(median(diff(posTime))<1/50) % hand control only
    pos = filtfilt(fir1(100,5/30),1,pos);
end