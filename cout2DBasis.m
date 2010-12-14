function basis = cout2DBasis(snips, kin)
basis = cell(size(snips));
for day=1:length(snips)
    targets = snips{day}.targetPos-snips{day}.startPos;
    basis{day} = struct();
    nTimes = size(snips{day}.time,2);
    
    % Time component.  Rows ~ time, cols ~ basis functions
    D = (1:nTimes)'*pi/nTimes;
    D = [sin(D).^2 sin(D-pi/4).^2 sin(D-pi/2).^2 sin(D-3*pi/4).^2];
    time = D;
    
    % Directional component
    D = atan2(targets(:,2),targets(:,1));
%     D = atan2(kin{day}.velY, kin{day}.velX);
    
    for tvar=1:size(time,2)
        basis{day}.(sprintf('sin1_%d',tvar)) = bsxfun(@times,time(:,tvar)',(sin(D)+1)/2);
        basis{day}.(sprintf('cos1_%d',tvar)) = bsxfun(@times,time(:,tvar)',(cos(D)+1)/2);
        basis{day}.(sprintf('sin2_%d',tvar)) = bsxfun(@times,time(:,tvar)',(sin(2*D)+1)/2);
        basis{day}.(sprintf('cos2_%d',tvar)) = bsxfun(@times,time(:,tvar)',(cos(2*D)+1)/2);
        basis{day}.(sprintf('sin3_%d',tvar)) = bsxfun(@times,time(:,tvar)',(sin(3*D)+1)/2);
        basis{day}.(sprintf('cos3_%d',tvar)) = bsxfun(@times,time(:,tvar)',(cos(3*D)+1)/2);
    end
end