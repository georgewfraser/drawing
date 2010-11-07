function basis = drawingBasis(snips, kin)
basis = cell(size(kin));
for day=1:length(kin)
    basis{day} = struct();
    dim = size(kin{day}.velX);
    
    % These are the nonlinear variables we will use to construct a linear basis
    % set
%     illusion = calculateIllusion(snips{day});
%     illusion = illusion(:);
    illusion = repmat(snips{day}.is_illusion,1,140);
    illusion = illusion(:);
    phase = cart2pol(kin{day}.velX, kin{day}.velY);
    phase = phase(:);
    ramp = repmat((0:139)/139,dim(1),1);
    ramp = ramp(:);
    cycle = repmat([nan 1:5 nan],20,1);
    cycle = repmat(cycle(:)',dim(1),1);
    cycle = cycle(:);
    
    % We are going to create some basis functions that will allow us to fit
    % position, velocity, curvature, whatever
    D = [sin(phase) cos(phase)];% sin(phase*2) cos(phase*2)];
    data = [...%bsxfun(@times,D,illusion),...
            bsxfun(@times,D,cycle==1),...
            bsxfun(@times,D,cycle==2),...
            bsxfun(@times,D,cycle==3),...
            bsxfun(@times,D,cycle==4),...
            bsxfun(@times,D,cycle==5),...
            ramp];
    data = [data bsxfun(@times,data,illusion)];
%     data = [data bsxfun(@times,illusion,data) ramp];% bsxfun(@times,abs(illusion),data)]; %#ok<AGROW>
    
    for b=1:size(data,2)
        basis{day}.(sprintf('basis%0.2d',b)) = reshape(data(:,b),dim);
    end
end
    