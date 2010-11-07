function kinematics = snipKinematics(snips, data)
kinematics = struct();
kinematics.posX = nan(size(snips.time));
kinematics.posY = nan(size(snips.time));
kinematics.posZ = nan(size(snips.time));
kinematics.velX = nan(size(snips.time));
kinematics.velY = nan(size(snips.time));
kinematics.velZ = nan(size(snips.time));
kinematics.accX = nan(size(snips.time));
kinematics.accY = nan(size(snips.time));
kinematics.accZ = nan(size(snips.time));
kinematics.speed = nan(size(snips.time));
kinematics.curvature = nan(size(snips.time));
    
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
% Filter to 5 Hz because we are going the resolution of the snips is as low
% as 10 Hz
pos = filtfilt(fir1(100,5/30),1,pos);
pos(outOfView,:) = nan;

velTime = (posTime(1:end-1)+posTime(2:end)) ./ 2;
vel = bsxfun(@rdivide, diff(pos), diff(posTime));

accTime = (velTime(1:end-1)+velTime(2:end)) ./ 2;
acc = bsxfun(@rdivide, diff(vel), diff(velTime));

curvTime = velTime;
velForCurv = interpolateColumnwise(repmat(velTime,1,3),vel,repmat(curvTime,1,3));
accForCurv = interpolateColumnwise(repmat(accTime,1,3),acc,repmat(curvTime,1,3));
speedForCurv = sqrt(sum(vel.^2,2));
curv = sqrt(sum(cross(velForCurv,accForCurv,2).^2,2))./speedForCurv;

for iis=1:size(snips.time,1)
    kinematics.posX(iis,:) = interpolate(posTime, pos(:,1), snips.time(iis,:));
    kinematics.posY(iis,:) = interpolate(posTime, pos(:,2), snips.time(iis,:));
    kinematics.posZ(iis,:) = interpolate(posTime, pos(:,3), snips.time(iis,:));

    kinematics.velX(iis,:) = interpolate(velTime, vel(:,1), snips.time(iis,:));
    kinematics.velY(iis,:) = interpolate(velTime, vel(:,2), snips.time(iis,:));
    kinematics.velZ(iis,:) = interpolate(velTime, vel(:,3), snips.time(iis,:));

    kinematics.accX(iis,:) = interpolate(accTime, acc(:,1), snips.time(iis,:));
    kinematics.accY(iis,:) = interpolate(accTime, acc(:,2), snips.time(iis,:));
    kinematics.accZ(iis,:) = interpolate(accTime, acc(:,3), snips.time(iis,:));
    
    kinematics.speed(iis,:) = interpolate(curvTime, speedForCurv, snips.time(iis,:));
    kinematics.curvature(iis,:) = interpolate(curvTime, curv, snips.time(iis,:));
end
end