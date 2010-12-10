function kinematicsByDate = snipKinematics(snipsByDate, dataByDate)
kinematicsByDate = cell(size(snipsByDate));
for day=1:length(snipsByDate)
    data = dataByDate{day};
    snips = snipsByDate{day};
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

    [posTime, pos] = transformAndFilterPosition(data);

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
    kinematicsByDate{day} = kinematics;
end
end