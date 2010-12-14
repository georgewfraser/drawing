function basis = cout2DBasis(snips)
basis = cell(size(snips));
for day=1:length(snips)
    basis{day} = struct();
    dim = size(snips{day}.time);
    targets = unique(snips{day}.targetPos-snips{day}.startPos,'rows');
    [th,r] = cart2pol(targets(:,1),targets(:,2));
    [th,idx] = sort(th);
    targets = targets(idx,:);
    
    % We are going to create some basis functions that will allow us to fit
    % position, velocity, curvature, whatever
    D = atan2(targets(:,2),targets(:,1));
    
    % Directional component.  Rows ~ targets, cols ~ basis functions
    D = [sin(D).^2 sin(D-pi/4).^2 sin(D-pi/2).^2 sin(D-3*pi/4).^2];
    D = [D D];
    mask = zeros(size(D,1),size(D,2)/2);
    for col=1:size(mask,2)
        mask((col-1)*2+(1:size(mask,1)/2),col) = 1;
    end
    mask = [mask circshift(mask,size(mask,1)/2)];
    D = D.*mask;
    directional = D;
    
    % Time component.  Rows ~ time, cols ~ basis functions
    D = (1:dim(2))'*pi/dim(2);
    D = [sin(D).^2 sin(D-pi/4).^2 sin(D-pi/2).^2 sin(D-3*pi/4).^2];
    time = D;
    
%     for tvar=1:size(time,2)
%         for dvar=1:size(directional,2)
%             subplot(size(time,2),size(directional,2),(tvar-1)*size(directional,2)+dvar);
%             imagesc(directional(:,dvar)*time(:,tvar)');
%         end
%     end
%     keyboard;
    
    [tf, ttargets] = ismember(snips{day}.targetPos-snips{day}.startPos,targets,'rows');
    for tvar=1:size(time,2)
        for dvar=1:size(directional,2)
            b = (tvar-1)*size(directional,2)+dvar;
            img = directional(:,dvar)*time(:,tvar)';
            basis{day}.(sprintf('basis%0.2d',b)) = img(ttargets,:);
        end
    end
end
    