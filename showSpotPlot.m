function [minRate, maxRate] = showSpotPlot(rateStruct)
addpath kdtree

colormap([jet; 1 1 1]);
cnames = fieldnames(rateStruct);
nCells = min(75,length(cnames));
minRate = nan(nCells,1);
maxRate = nan(nCells,1);
% for fig=1:ceil(length(cnames)/75)
%     figure(fig);
%     for iic=1:min(75,length(cnames)-(fig-1)*75)
    fig = 1;
    for iic=1:nCells
        rate = rateStruct.(cnames{(fig-1)*75+iic});
        minRate(iic) = min(rate(:));
        maxRate(iic) = max(rate(:));
        rate = rate - min(rate(:));
        rate = rate./max(rate(:));
        rate = rate.*(length(colormap)-1);
        targets = target26(1);
        profile = var(rate,0,2);
    %     profile = mean(rate,2);
        pd = regress(profile,[targets; targets])';

        [az,el] = cart2sph(targets(:,1),targets(:,2),targets(:,3));
        [az0,el0] = cart2sph(pd(1), pd(2), pd(3));
        [el,az] = rotatem(el,az,[el0 az0],'forward','radians');

        sliceLoc = 1:size(rate,2);%[5 10 15 18];
        outward = cell(length(sliceLoc)*2,1);
        inward = cell(size(outward));
        xrange = -pi:pi/25:pi;
        yrange = -pi/2:pi/25:pi/2;
        [xi, yi] = meshgrid(xrange,yrange);
        spacer = length(colormap)*ones(ceil(length(yrange)/10),length(xrange));
    %     spacer = nan(ceil(length(yrange)/10),length(xrange));
        for iis=1:length(sliceLoc)
            slice = sliceLoc(iis);

            outward{iis*2-1} = nearest(az,el,rate(1:26,slice),xi,yi);
            outward{iis*2} = spacer;
    %         subplot(length(sliceLoc),2*nCells,(iis-1)*2*nCells+2*iic-1);
    %         image(xrange,yrange,zi);
    %         axis image, box off, axis off

            inward{iis*2-1} = nearest(az,el,rate(27:end,slice),xi,yi);
            inward{iis*2} = spacer;
    %         subplot(length(sliceLoc),2*nCells,(iis-1)*2*nCells+2*iic);
    %         image(xrange,yrange,zi);
    %         axis image, box off, axis off
        end
        outward = cell2mat(outward(1:end-1));
        inward = cell2mat(inward(1:end-1));
        img = [outward length(colormap)*ones(size(outward,1), size(spacer,1)) inward];
        subplot(3,ceil(nCells/3),iic);
        image(img);
        axis image, box off, axis off
    end
% end
end
    

function a = angle(x,y)
thX = cart2pol(x(:,1),x(:,2));
thY = cart2pol(y(:,1),y(:,2));

a = wrapToPi(thY-thX);
end

function zi = nearest(x,y,z,xi,yi)
reference = [reshape(x,numel(x),1) reshape(y,numel(y),1)];
model = [reshape(xi,numel(xi),1) reshape(yi,numel(yi),1)];
idx = kdtreeidx(reference,model);
zi = reshape(z(idx),size(xi));
% zi = nan(size(xi));
% 
% x = reshape(x,numel(x),1);
% y = reshape(y,numel(y),1);
% z = reshape(z,numel(z),1);
% xi = reshape(xi,numel(xi),1);
% yi = reshape(yi,numel(yi),1);
% 
% dists = sqrt(bsxfun(@minus,x,xi').^2+bsxfun(@minus,y,yi').^2);
% dists = bsxfun(@eq,dists,min(dists));
% 
% [row,col] = find(dists);
% zi(col) = z(row);
end