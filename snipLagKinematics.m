function kinematics = snipLagKinematics(snips, data)
spline = spmak(0:.2:.5,1);
lagValues = -.5:.2:.5;
spline = fnval(spline,0:(1/60):.5)';
spline = spline ./ sum(spline);

% Extract position data
posTime = data.kinematics.PlexonTime;
if(~isfield(data.kinematics,'CursorPosition'))
    data.kinematics.CursorPosition = data.kinematics.Markers;
end
pos = data.kinematics.CursorPosition;
cursor_transform = data.header.CursorTransform(1:3,:);
cursor_transform(1,:) = cursor_transform(1,:) ./ abs(sum(cursor_transform(1,1:3)));
pos = [pos ones(size(pos,1),1)] * cursor_transform';
outOfView = sqrt(sum(pos.^2,2))>5;
pos(outOfView,:) = 0;
pos = filtfilt(fir1(100,5/30),1,pos);
% Extract velocity then direction
velTime = (posTime(1:end-1)+posTime(2:end)) ./ 2;
vel = bsxfun(@rdivide, diff(pos), diff(posTime));
dir = vel(:,1:2);
dir = bsxfun(@rdivide,dir,sqrt(sum(dir.^2,2)));
% Apply the polynomial filter
dir = filter(spline,1,dir);
time = filter(spline,1,velTime);

kinematics = struct();
for spl=1:length(lagValues)
    kinematics.(sprintf('dirX%d',spl)) = nan(size(snips.time));
    kinematics.(sprintf('dirY%d',spl)) = nan(size(snips.time));
end
for trial=1:size(snips.time,1)
    for spl=1:length(lagValues)
        kinematics.(sprintf('dirX%d',spl))(trial,:) = interpolate(time+lagValues(spl), dir(:,1), snips.time(trial,:));
        kinematics.(sprintf('dirY%d',spl))(trial,:) = interpolate(time+lagValues(spl), dir(:,2), snips.time(trial,:));
    end
end