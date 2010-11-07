function covariates = drawingCovariates(kin, snips)
covariates = cell(size(kin));

for day=1:length(kin)
    covariates{day} = struct();
    
    illusion = snips{day}.progress;
    illusion = illusion-2;
    illusion = illusion/2;
    illusion(illusion<0) = 0;
    illusion(illusion>1) = 1;
    illusion(~snips{day}.is_illusion,:) = 0;
    % Map [0,1] to [0,1.8]
    illusion = 1+illusion*.8;
    illusion(~snips{day}.is_ellipse,:) = 1./illusion(~snips{day}.is_ellipse,:);
    illusion = illusion-1;
    
    phase = cart2pol(kin{day}.posX, kin{day}.posY);
    
    dirX = kin{day}.velX;
    dirY = kin{day}.velY;
    dirZ = kin{day}.velZ;
    dirNorm = sqrt(dirX.^2+dirY.^2+dirZ.^2);
    dirX = dirX./dirNorm;
    dirY = dirY./dirNorm;
    dirZ = dirZ./dirNorm;
    
    covariates{day}.illusion = illusion;
    covariates{day}.phase = phase;
    covariates{day}.dirX = dirX;
    covariates{day}.dirY = dirY;
    covariates{day}.dirZ = dirZ;
    covariates{day}.velocityDisparity = illusion.*dirX;
    covariates{day}.positionDisparity = illusion.*kin{day}.posX;
end