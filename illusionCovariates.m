function [disparity, posErr] = illusionCovariates(drawingSnips, drawingKin, drawingKinMean)
disparity = cell(size(drawingSnips));
posErr = cell(size(drawingSnips));

for day=1:length(drawingSnips)
    disparity{day} = struct('x',nan(size(drawingSnips{day}.time)));
    posErr{day} = struct('x',nan(size(drawingSnips{day}.time)));
    
    illusion = drawingSnips{day}.progress;
    illusion = (illusion-2)/2;
    illusion = max(illusion,0);
    illusion = min(illusion,1);
    illusion(~drawingSnips{day}.is_illusion,:) = 0;
    illusion(~drawingSnips{day}.is_ellipse,:) = 0; % Circle sucks
    disparity{day}.x = illusion.*.8.*drawingKin{day}.posX;
    
    % Convert to visual coordinates
    posX = drawingKin{day}.posX .* (1+illusion.*.8);
    posY = drawingKin{day}.posY;
    
    ellipseX = drawingKinMean{day}.posX(3,:);
    ellipseY = drawingKinMean{day}.posY(3,:);
    ellipseX = resample(ellipseX,10,1);
    ellipseY = resample(ellipseY,10,1);
    ellipseX = ellipseX(210:1200);
    ellipseY = ellipseY(210:1200);
    
    circleX = drawingKinMean{day}.posX(1,:);
    circleY = drawingKinMean{day}.posY(1,:);
    circleX = resample(circleX,10,1);
    circleY = resample(circleY,10,1);
    circleX = circleX(210:1200);
    circleY = circleY(210:1200);
    
    figure = [ellipseX' ellipseY'];
    cursorX = posX(drawingSnips{day}.is_ellipse,:);
    cursorY = posY(drawingSnips{day}.is_ellipse,:);
    cursor = [cursorX(:) cursorY(:)];
    [cp,dist] = kdtree(figure,cursor);
    err = dist.*sign(cursorX(:));
    err = reshape(err,size(cursorX));
    posErr{day}.x(drawingSnips{day}.is_ellipse,:) = err;
    
    figure = [circleX' circleY'];
    cursorX = posX(~drawingSnips{day}.is_ellipse,:);
    cursorY = posY(~drawingSnips{day}.is_ellipse,:);
    cursor = [cursorX(:) cursorY(:)];
    [cp,dist] = kdtree(figure,cursor);
    err = dist.*sign(cursorX(:));
    err = reshape(err,size(cursorX));
    posErr{day}.x(~drawingSnips{day}.is_ellipse,:) = err;
end
        
        
        
