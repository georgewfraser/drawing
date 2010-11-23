function kinematics = snipLagKinematics(snipsByDate, dataByDate)
% lagValues = -.5:.2:.5;
% spline = spmak(0:.2:.5,1);
% spline = fnval(spline,0:(1/60):.5)';
% spline = spline ./ sum(spline);
lagValues = -.5:.050:.5;
kinematics = cell(length(snipsByDate),length(lagValues));
for day=1:length(snipsByDate)
    fprintf('.');
    % Extract position dataByDate{day}
    posTime = dataByDate{day}.kinematics.PlexonTime;
    if(~isfield(dataByDate{day}.kinematics,'CursorPosition'))
        dataByDate{day}.kinematics.CursorPosition = dataByDate{day}.kinematics.Markers;
    end
    pos = dataByDate{day}.kinematics.CursorPosition;
    cursor_transform = dataByDate{day}.header.CursorTransform(1:3,:);
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
    % dir = filter(spline,1,dir);
    % time = filter(spline,1,velTime);
    time = velTime;

    for lag=1:length(lagValues)
        kinematics{day,lag} = struct();
        kinematics{day,lag}.dirX = nan(size(snipsByDate{day}.time));
        kinematics{day,lag}.dirY = nan(size(snipsByDate{day}.time));
        for trial=1:size(snipsByDate{day}.time,1)
            kinematics{day,lag}.dirX(trial,:) = interpolate(time+lagValues(lag), dir(:,1), snipsByDate{day}.time(trial,:));
            kinematics{day,lag}.dirY(trial,:) = interpolate(time+lagValues(lag), dir(:,2), snipsByDate{day}.time(trial,:));
        end
    end
end
fprintf('\n');