function slices = target26SliceIndex()
% First, we are going to generate an idealized set of slices that is close
% to the 26-target task

% az represents angle in the x-z plane
% el represents elevation
% matlab's cart2sph reverses y and z compared with this convention

slices=cell(4,1);
for az=0:3%0:pi/4:0.75*pi
    slices{az+1} = nan(8,3);
    for el=2:9%pi/2+(0:pi/4:2*pi)
        [x,z,y] = sph2cart(az*pi/4,el*pi/4,1);
        slices{az+1}(el-1,:) = [x y z];
    end
end

% Replace each idealized target with the real target closest to it
targets = target26(1);
for s=1:4
    closeness = targets*slices{s}';
    closeness = bsxfun(@eq,closeness,max(closeness));
    [row,col] = find(closeness);
    slices{s} = row;
end