function kinematics = snipKinematics(snips, data)
kinematics = struct();
kinematics.posX = nan(size(snips.time));
kinematics.posY = nan(size(snips.time));
kinematics.posZ = nan(size(snips.time));
kinematics.velX = nan(size(snips.time));
kinematics.velY = nan(size(snips.time));
kinematics.velZ = nan(size(snips.time));
    
kpostime = data.kinematics.PlexonTime;
kpos = data.kinematics.CursorPosition;
cursor_transform = data.header.CursorTransform(1:3,:);
cursor_transform(1,:) = cursor_transform(1,:) ./ abs(sum(cursor_transform(1,1:3)));
kpos = [kpos ones(size(kpos,1),1)] * cursor_transform';
kpos(sqrt(sum(kpos.^2,2))>5,:) = nan;

kveltime = (kpostime(1:end-1)+kpostime(2:end)) ./ 2;
kvel = bsxfun(@rdivide, diff(kpos), diff(kpostime));

for iis=1:size(snips.time,1)
    kinematics.posX(iis,:) = interpolate(kpostime, kpos(:,1), snips.time(iis,:));
    kinematics.posY(iis,:) = interpolate(kpostime, kpos(:,2), snips.time(iis,:));
    kinematics.posZ(iis,:) = interpolate(kpostime, kpos(:,3), snips.time(iis,:));

    kinematics.velX(iis,:) = interpolate(kveltime, kvel(:,1), snips.time(iis,:));
    kinematics.velY(iis,:) = interpolate(kveltime, kvel(:,2), snips.time(iis,:));
    kinematics.velZ(iis,:) = interpolate(kveltime, kvel(:,3), snips.time(iis,:));
end
end