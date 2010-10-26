[x,z] = meshgrid(0:.05:1,0:.05:1);
y = x;

clf;
hold on;
lighting phong
set(gcf,'Renderer','zbuffer')
axis image;
xlim([-0.1 1.1]);
ylim([-0.1 1.1]);
zlim([-0.1 1.1]);
set(gca,'XTick',[0 1]);
set(gca,'YTick',[0 1]);
set(gca,'ZTick',[0 1]);
set(gca,'FontSize',48);
xlabel('Neuron 1');
ylabel('Neuron 2');
zlabel('Neuron 3');
set(gca,'nextplot','replacechildren');
F = getframe;

NFRAMES1 = 30;
for i=1:NFRAMES1
    plot([0 1]*i/NFRAMES1, [0 1]*i/NFRAMES1,'LineWidth',10);
    F(i) = getframe;
end

NFRAMES2 = 30;
for i=1:NFRAMES2
    F(NFRAMES1+i) = getframe;
end

NFRAMES3 = 30;

view([0 90]);
for i=1:NFRAMES3
    view([0 90-(i-1)/NFRAMES3*45]);
    F(NFRAMES1+NFRAMES2+i) = getframe;
end

NFRAMES4 = 30;
for i=1:NFRAMES4
    idx = max(2,ceil(i/NFRAMES4*size(x,1)));
    surf(x(1:idx,:),y(1:idx,:),z(1:idx,:));
    F(NFRAMES1+NFRAMES2+i) = getframe;
end
    

movie(F,1,30);