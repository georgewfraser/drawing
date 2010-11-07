clf;
colormap(gray);
[x,y] = meshgrid(-1:.1:1);
z = x;
ax = [1 0 1; 0 1 0];
ax = bsxfun(@rdivide,ax,sqrt(sum(ax.^2,2)));

subplot(1,3,1);
surf(x,y,z);
bumpax = bsxfun(@plus,ax,[0 0 .05]);
arrow([0 0 0],bumpax(1,:),25,'Width',5,'FaceColor',[1 0 0],'EdgeColor',[1 0 0]);
arrow([0 0 0],bumpax(2,:),25,'Width',5,'FaceColor',[0 1 0],'EdgeColor',[0 1 0]);
axis image;
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);

% Transform the data a little to get a slightly different subspace
data = [x(:) y(:) z(:)];

data = data*(eye(3)+randn(3)*.1);
x(:) = data(:,1); 
y(:) = data(:,2); 
z(:) = data(:,3);

% Get some new axes from the new subspace
ax2 = orth(data(ceil(rand(2,1)*size(data,1)),:)')';

subplot(1,3,2);
surf(x,y,z);
bumpax = bsxfun(@plus,ax2,[0 0 .05]);
arrow([0 0 0],bumpax(1,:),25,'Width',5,'FaceColor',[1 0 0],'EdgeColor',[1 0 0]);
arrow([0 0 0],bumpax(2,:),25,'Width',5,'FaceColor',[0 1 0],'EdgeColor',[0 1 0]);
axis image;
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);

subplot(1,3,3);
ax2 = rotatefactors(ax2','Method','procrustes','Target',ax','Type','orthogonal')';
surf(x,y,z);
bumpax = bsxfun(@plus,ax2,[0 0 .05]);
arrow([0 0 0],bumpax(1,:),25,'Width',5,'FaceColor',[1 0 0],'EdgeColor',[1 0 0]);
arrow([0 0 0],bumpax(2,:),25,'Width',5,'FaceColor',[0 1 0],'EdgeColor',[0 1 0]);
axis image;
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
