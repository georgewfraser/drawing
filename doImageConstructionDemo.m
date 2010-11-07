clf; hold on;

% Green sphere at the center
colormap([.8 .8 .8; 0 .8 0]);
[x,y,z] = sphere();
x = x.* .075;
y = y.* .075;
z = z.* .075;
h = surf(x,y,z,ones(size(z)));
set(h,'FaceLighting','phong','FaceColor','interp',...
      'AmbientStrength',0.5)
light('Position',[1 0 0],'Style','infinite');
shading interp;
axis image;
xlim([-1.2 1.2]);
ylim([-1.2 1.2]);
axis off;
box off;

% Firing rate profiles for each target
th = (-pi+pi/8:pi/8:pi)';
[x,y] = pol2cart(th,1);
for i=1:16
    arrow([x(i) y(i)]*.15,[x(i) y(i)]*.85,30,'Width',5);
end

x = x-.15;
y = y-.075;
fields = fieldnames(controlRateMean{20});
img = controlRateMean{20}.(fields{26});
for i=1:16
    plot(x(i)+(1:20)/20*.3,y(i)+img(i,:)/max(img(:))*.15,'LineWidth',2);
    line(x(i)+[0 .4],[y(i) y(i)],'Color',[0 0 0]);
    line([x(i) x(i)],y(i)+[0 .2],'Color',[0 0 0]);
end