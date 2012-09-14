function pos = illusionCovariates(drawingSnips, drawingKin)
pos = cell(size(drawingSnips));

for day=1:length(drawingSnips)
    pos{day} = struct('x',nan(size(drawingKin{day}.posX)));
    
    % Ellipse
    sel = drawingSnips{day}.is_ellipse;
    idealX = mean(drawingKin{day}.posX(sel&~drawingSnips{day}.is_illusion,:));
    idealY = mean(drawingKin{day}.posY(sel&~drawingSnips{day}.is_illusion,:));
    idealZ = mean(drawingKin{day}.posZ(sel&~drawingSnips{day}.is_illusion,:));
    idealX = interpolate(1:length(idealX),idealX',1:.1:length(idealX));
    idealY = interpolate(1:length(idealY),idealY',1:.1:length(idealY));
    idealZ = interpolate(1:length(idealZ),idealZ',1:.1:length(idealZ));
    
    progress = drawingSnips{day}.progress(sel,:);
    progress = (progress-2)/2;
    progress = max(progress,0);
    progress = min(progress,1);
    progress(~drawingSnips{day}.is_illusion(sel),:) = 0;
    
    cursorX = drawingKin{day}.posX(sel,:);
    visualX = cursorX.*(1+.8*progress);
    cursorY = drawingKin{day}.posY(sel,:);
    cursorZ = drawingKin{day}.posZ(sel,:);
    
    idx = kdtreeidx([idealX(:) idealY(:) idealZ(:)],[visualX(:) cursorY(:) cursorZ(:)]);
    err = nan(size(cursorX));
    err(:) = cursorX(:)-idealX(idx);
    pos{day}.x(sel,:) = err;
    
    % Circle
    sel = ~drawingSnips{day}.is_ellipse;
    idealX = mean(drawingKin{day}.posX(sel&~drawingSnips{day}.is_illusion,:));
    idealY = mean(drawingKin{day}.posY(sel&~drawingSnips{day}.is_illusion,:));
    idealZ = mean(drawingKin{day}.posZ(sel&~drawingSnips{day}.is_illusion,:));
    idealX = interpolate(1:length(idealX),idealX',1:.1:length(idealX));
    idealY = interpolate(1:length(idealY),idealY',1:.1:length(idealY));
    idealZ = interpolate(1:length(idealZ),idealZ',1:.1:length(idealZ));
    
    cursorX = drawingKin{day}.posX(sel,:);
    cursorY = drawingKin{day}.posY(sel,:);
    cursorZ = drawingKin{day}.posZ(sel,:);
    
    idx = kdtreeidx([idealX(:) idealY(:) idealZ(:)],[cursorX(:) cursorY(:) cursorZ(:)]);
    err = nan(size(cursorX));
    err(:) = cursorX(:)-idealX(idx);
    pos{day}.x(sel,:) = err;
    
%     compareX = nan(size(cursorX));
%     compareY = nan(size(cursorX));
%     compareZ = nan(size(cursorX));
%     compareX(:) = idealX(idx);
%     compareY(:) = idealY(idx);
%     compareZ(:) = idealZ(idx);
%     clf, hold on
%     plot3(idealX,idealY,idealZ);
%     plot3(cursorX(1,:),cursorY(1,:),cursorZ(1,:),'g');
%     for t=1:size(cursorX,2)
%         line([cursorX(1,t) compareX(1,t)],[cursorY(1,t) compareY(1,t)],[cursorZ(1,t) compareZ(1,t)]);
%     end
%     axis image
% 
%     keyboard;
end
        
