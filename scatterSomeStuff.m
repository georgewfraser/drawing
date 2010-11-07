colors = jet(26);
targ = coutSnips{10}.targetPos-coutSnips{10}.startPos;
targ = bsxfun(@rdivide,targ,sqrt(sum(targ.^2,2)));
pos = [coutKin{10}.posX(:,13), coutKin{10}.posY(:,13), coutKin{10}.posZ(:,13)]-coutSnips{10}.startPos;
pos = bsxfun(@rdivide,pos,sqrt(sum(pos.^2,2)));

utargets = target26(1);
targ = round(targ*1000)/1000;
utargets = round(utargets*1000)/1000;
[tf,idx] = ismember(targ,utargets,'rows');
if(sum(~tf)>0)
    keyboard;
end

for iit=1:26
    x = pos(idx==iit,1);
    y = pos(idx==iit,2);
    z = pos(idx==iit,3);
    line([zeros(size(x)), x]',[zeros(size(x)), y]',[zeros(size(x)), z]','Color',colors(iit,:));
end
axis image;

angles = acos(sum(pos.*targ,2));