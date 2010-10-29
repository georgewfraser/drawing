function Xmean = meanByTarget3D(snips, X)
outward = sum(abs(snips.startPos),2)==0;
inward = ~outward;
targets = snips.targetPos-snips.startPos;
% We are going to construct a mean such that each outward movement is
% matched up with an inward movement
Xmean = [meanSub(X(outward,:),targets(outward,:)) meanSub(X(inward,:),-targets(inward,:))];
end
function Xmean = meanSub(X,targets)
utargets = generateTargets(norm(targets(1,:)));
targets = round(targets*1000)/1000;
utargets = round(utargets*1000)/1000;
% for i=1:size(utargets,1),
%     text(utargets(i,1),utargets(i,2),utargets(i,3),sprintf('%d',i));
% end
% line([0 .1],[0 0],[0 0],'Color',[1 0 0]);
% line([0 0],[0 .1],[0 0],'Color',[0 1 0]);
% line([0 0],[0 0],[0 .1],'Color',[0 0 1]);
% axis image;
% xlim([-.1 .1]);
% ylim([-.1 .1]);
% zlim([-.1 .1]);

[tf,set1] = ismember(targets, utargets(1:8,:), 'rows');
[tf,set2] = ismember(targets, utargets(9:16,:), 'rows');
[tf,set3] = ismember(targets, utargets(17:24,:), 'rows');
[tf,set4] = ismember(targets, utargets(25:32,:), 'rows');

Xmean = nan(length(utargets),size(X,2));

for iit=1:8
    Xmean(iit,:) = nanmean(X(iit==set1,:));
    Xmean(8+iit,:) = nanmean(X(iit==set2,:));
    Xmean(16+iit,:) = nanmean(X(iit==set3,:));
    Xmean(24+iit,:) = nanmean(X(iit==set4,:));
end
end

function targets = generateTargets(r)
targets = nan(32,3);
for az=[0 2]
    [x,y,z] = sph2cart(az*pi/4,(0:7)'*pi/4,r);
    targets(az*8+(1:8),:) = [x y z];
end
for az=[1 3]
    adjust = [0 -0.2163 0 0.2163 0 -0.2163 0 0.2163];
    [x,y,z] = sph2cart(az*pi/4,((0:7)+adjust)'*pi/4,r);
    targets(az*8+(1:8),:) = [x y z];
end
end