clf; hold on;
targets = target26(1);
[x,y,z] = sphere();
x = x.* .05;
y = y.* .05;
z = z.* .05;
plot3(targets([1:4 1],1),targets([1:4 1],2),targets([1:4 1],3),'k');
plot3(targets([5:8 5],1),targets([5:8 5],2),targets([5:8 5],3),'k');
plot3(targets([1 5],1),targets([1 5],2),targets([1 5],3),'k');
plot3(targets([2 6],1),targets([2 6],2),targets([2 6],3),'k');
plot3(targets([3 7],1),targets([3 7],2),targets([3 7],3),'k');
plot3(targets([4 8],1),targets([4 8],2),targets([4 8],3),'k');

plot3([0 0],[0 0],[1/sqrt(3) 1],'k');
plot3([0 0],[0 0],-[1/sqrt(3) 1],'k');
plot3([0 0],[1/sqrt(3) 1],[0 0],'k');
plot3([0 0],-[1/sqrt(3) 1],[0 0],'k');
plot3([1/sqrt(3) 1],[0 0],[0 0],'k');
plot3(-[1/sqrt(3) 1],[0 0],[0 0],'k');

% sel = (1:size(targets,1))'>8 & targets(:,3)==0;
% circle = targets(sel,:);
% th = cart2pol(circle(:,1),circle(:,2));
% [s,idx] = sort(th);
% idx = idx([1:end 1]);
% plot3(circle(idx,1),circle(idx,2),circle(idx,3),'k');
% 
% sel = (1:size(targets,1))'>8 & targets(:,2)==0;
% circle = targets(sel,:);
% th = cart2pol(circle(:,1),circle(:,3));
% [s,idx] = sort(th);
% idx = idx([1:end 1]);
% plot3(circle(idx,1),circle(idx,2),circle(idx,3),'k');
% 
% sel = (1:size(targets,1))'>8 & targets(:,1)==0;
% circle = targets(sel,:);
% th = cart2pol(circle(:,2),circle(:,3));
% [s,idx] = sort(th);
% idx = idx([1:end 1]);
% plot3(circle(idx,1),circle(idx,2),circle(idx,3),'k');

for i=1:26
    surfl(x+targets(i,1),y+targets(i,2),z+targets(i,3));
end
shading interp
colormap(gray);
axis image;