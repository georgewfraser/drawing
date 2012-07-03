function coutSum = coutSummary(coutSnips, lagCoutKin, coutRate) 
% coutSum = coutSummary(coutSnips, coutRate)
%
% Where day is an integer, name is the name of a cell:
% coutSum{day}.name.lag ~ time offset (s) that produces best model
% coutSum{day}.name.positional ~ relative strength of position versus
%   velocity in model (0 to 1)
% coutSum{day}.name.pd ~ [x y z] preferred direction of cell
% coutSum{day}.name.pdAngle ~ angle of PD in the x-y plane
% coutSum{day}.name.pp ~ [x y z] preferred position direction of cell
coutSum = cell(length(coutSnips));
for iiday=1:length(coutSnips)
    fprintf('Day %d',iiday);
    
    coutSum{iiday} = struct();
    
    for iilag=1:length(lags)
    
        posX = lagCoutKin{iilag}{iiday}.posX;
        posY = lagCoutKin{iilag}{iiday}.posY;
        posZ = lagCoutKin{iilag}{iiday}.posZ;
        velX = lagCoutKin{iilag}{iiday}.velX;
        velY = lagCoutKin{iilag}{iiday}.velY;
        velZ = lagCoutKin{iilag}{iiday}.velZ;
        speed = lagCoutKin{iilag}{iiday}.speed;

        X = [posX(:) posY(:) posZ(:) velX(:) velY(:) velZ(:) speed(:)];

        cnames = fieldnames(coutRate{iiday});
    for iicell=1:length(cnames)
        
        coutSum{iiday}.(cnames{iicell}) = cell(length(lagCoutRate));
            fprintf('.');
            
            rate = lagCoutRate{iilag}{iiday}.(cnames{iicell});
            y = sqrt(rate(:)); % sqrt stabilizes poisson variance
            modelP = glmfit(X(:,1:3),y);
            modelV = glmfit(X(:,4:6),y);
            modelS = glmfit(X(:,7),y);
            modelA = glmfit(X,y);
            
            yP = X(:,1:3)*modelP(2:end) + modelP(1);
            yV = X(:,4:6)*modelV(2:end) + modelV(1);
            yS = X(:,7)*modelS(2:end) + modelS(1);
            yA = X*modelA(2:end) + modelA(1);
            
            coutSum{iiday}.(cnames{iicell})
            r2position(iilag) = 1 - sum((y-yP).^2) / sum((y-mean(y)).^2);
            r2velocity(iilag) = 1 - sum((y-yV).^2) / sum((y-mean(y)).^2);
            r2speed(iilag) = 1 - sum((y-yS).^2) / sum((y-mean(y)).^2);
            r2all(iilag) = 1 - sum((y-yA).^2) / sum((y-mean(y)).^2);
        end
        %coutSum{iiday}.(cnames{iicell}) = [ r2position r2velocity r2speed r2all ];
    end
    fprintf('\n');
end