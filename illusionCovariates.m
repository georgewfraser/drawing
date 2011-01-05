function [disparity, correction] = illusionCovariates(drawingSnips, drawingKin, drawingKinMean)
disparity = cell(size(drawingSnips));
correction = cell(size(drawingSnips));

for day=1:length(drawingSnips)
    disparity{day} = struct('x',nan(size(drawingSnips{day}.time)));
    correction{day} = struct('x',nan(size(drawingSnips{day}.time)));
    
    illusion = drawingSnips{day}.progress;
    illusion = (illusion-2)/2;
    illusion = max(illusion,0);
    illusion = min(illusion,1);
    illusion(~drawingSnips{day}.is_illusion,:) = 0;
    illusion(~drawingSnips{day}.is_ellipse,:) = 0; % Circle sucks
    disparity{day}.x = illusion.*.8.*drawingKin{day}.posX;
    
    % Convert to visual coordinates
    cursorPosX = drawingKin{day}.posX .* (1+illusion.*.8);
    cursorPosY = drawingKin{day}.posY;
    cursorVelX = drawingKin{day}.velX;
    cursorVelY = drawingKin{day}.velY;
    
    ellipsePosX = drawingKinMean{day}.posX(3,:);
    ellipsePosY = drawingKinMean{day}.posY(3,:);
    ellipsePosX = resample(ellipsePosX,10,1);
    ellipsePosY = resample(ellipsePosY,10,1);
    ellipsePosX = ellipsePosX(210:1200);
    ellipsePosY = ellipsePosY(210:1200);
    
    ellipseVelX = drawingKinMean{day}.velX(3,:);
    ellipseVelY = drawingKinMean{day}.velY(3,:);
    ellipseVelX = resample(ellipseVelX,10,1);
    ellipseVelY = resample(ellipseVelY,10,1);
    ellipseVelX = ellipseVelX(210:1200);
    ellipseVelY = ellipseVelY(210:1200);
    
    circlePosX = drawingKinMean{day}.posX(1,:);
    circlePosY = drawingKinMean{day}.posY(1,:);
    circlePosX = resample(circlePosX,10,1);
    circlePosY = resample(circlePosY,10,1);
    circlePosX = circlePosX(210:1200);
    circlePosY = circlePosY(210:1200);
    
    circleVelX = drawingKinMean{day}.velX(1,:);
    circleVelY = drawingKinMean{day}.velY(1,:);
    circleVelX = resample(circleVelX,10,1);
    circleVelY = resample(circleVelY,10,1);
    circleVelX = circleVelX(210:1200);
    circleVelY = circleVelY(210:1200);
    
    % Compute the figure and cursor position
    figure = [ellipsePosX' ellipsePosY'];
    cursorX = cursorPosX(drawingSnips{day}.is_ellipse,:);
    cursorY = cursorPosY(drawingSnips{day}.is_ellipse,:);
    cursor = [cursorX(:) cursorY(:)];
    % Identify where we are in the figure
    idx = kdtreeidx(figure,cursor);
    % Identify what the velocity should be
    idealVelX = reshape(ellipseVelX(idx),size(cursorX));
    idealVelY = reshape(ellipseVelY(idx),size(cursorX));
    actualVelX = cursorVelX(drawingSnips{day}.is_ellipse,:);
    actualVelY = cursorVelY(drawingSnips{day}.is_ellipse,:);
    % Compute the angle
    angle = atan2(actualVelY,actualVelX)-atan2(idealVelY,idealVelX);
    angle = wrapToPi(angle);
    correction{day}.x(drawingSnips{day}.is_ellipse,:) = angle;
    
%     idx = find(drawingSnips{day}.is_illusion(drawingSnips{day}.is_ellipse),1);
%     clf, hold on
%     plot(cursorX(idx,:),cursorY(idx,:),':');
%     quiver(cursorX(idx,:),cursorY(idx,:),actualVelX(idx,:),actualVelY(idx,:),'Color',[0 0 1]);
%     quiver(cursorX(idx,:),cursorY(idx,:),idealVelX(idx,:),idealVelY(idx,:),'Color',[1 0 0]);
%     keyboard;
    
    % Compute the figure and cursor position
    figure = [circlePosX' circlePosY'];
    cursorX = cursorPosX(~drawingSnips{day}.is_ellipse,:);
    cursorY = cursorPosY(~drawingSnips{day}.is_ellipse,:);
    cursor = [cursorX(:) cursorY(:)];
    % Identify where we are in the figure
    idx = kdtreeidx(figure,cursor);
    % Identify what the velocity should be
    idealVelX = reshape(circleVelX(idx),size(cursorX));
    idealVelY = reshape(circleVelY(idx),size(cursorX));
    actualVelX = cursorVelX(~drawingSnips{day}.is_ellipse,:);
    actualVelY = cursorVelY(~drawingSnips{day}.is_ellipse,:);
    % Compute the angle
    angle = atan2(actualVelY,actualVelX)-atan2(idealVelY,idealVelX);
    angle = wrapToPi(angle);
    correction{day}.x(~drawingSnips{day}.is_ellipse,:) = angle;
end
        
        
        
