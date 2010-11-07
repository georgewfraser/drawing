clf; hold on;
colormap([.8 .8 .8; 0 .8 0]);

th = (-pi+pi/8:pi/8:pi)';
[x,y] = pol2cart(th,1);
targets = [x y];

[x,y,z] = sphere();
x = x.* .075;
y = y.* .075;
z = z.* .075;

for i=1:16
    if(i==10)
        c = ones(size(z));
    else
        c = zeros(size(z));
    end
    h = surf(x+targets(i,1),y+targets(i,2),z+0,c);
    set(h,'FaceLighting','phong','FaceColor','interp',...
          'AmbientStrength',0.5)
end
h = surf(x,y,z,ones(size(z)));
set(h,'FaceLighting','phong','FaceColor','interp',...
      'AmbientStrength',0.5)
light('Position',[1 0 0],'Style','infinite');
shading interp
axis image;
axis off;
box off;
% annotation('arrow',targets(10,1)*[.2 .8],targets(10,2)*[.2 .8]);
arrow(targets(10,:)*.15,targets(10,:)*.85,60,'Width',10);

[x,y] = pol2cart(0:pi/100:2*pi,.5);
plot(x,y,'k--','LineWidth',5);
h = text(0, .6,'Invisible Zone','FontSize',24,'HorizontalAlignment','center');