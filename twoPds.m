function [deltaPd, deltaMd, pdSig, mdSig] = twoPds(coutSnips, coutRate)
deltaPd = [];
deltaMd = [];
pdSig = [];
mdSig = [];

for day=1:length(coutSnips)
    targ = coutSnips{day}.targetPos-coutSnips{day}.startPos;
    out = sum(abs(coutSnips{day}.startPos),2)==0;
    
    cnames = fieldnames(coutRate{day});
    for unit=1:length(cnames)
        [bOut,dev,stats] = glmfit(targ(out,:),mean(coutRate{day}.(cnames{unit})(out,6:20),2));
        bOutDist = mvnrnd(bOut, stats.covb,1000);
        [bIn,dev,stats] = glmfit(targ(~out,:),mean(coutRate{day}.(cnames{unit})(~out,6:20),2));
        bInDist = mvnrnd(bIn, stats.covb,1000);
        bOut = bOut(2:end);
        bIn = bIn(2:end);
        bOutDist = bOutDist(:,2:end);
        bInDist = bInDist(:,2:end);
        
        deltaMd(end+1) = norm(bOut)/(norm(bOut)+norm(bIn));
        mdOutDist = sqrt(sum(bOutDist.^2,2));
        mdInDist = sqrt(sum(bInDist.^2,2));
        deltaMdDist = mdOutDist./(mdOutDist+mdInDist);
        deltaMdDist = (deltaMdDist-.5)*sign(deltaMd(end)-.5);
        mdSig(end+1) = quantile(deltaMdDist,.025)>0;
        
        pdOut = bOut/norm(bOut);
        pdIn = bIn/norm(bIn);
        deltaPd(end+1) = acos(pdIn'*pdOut);
        pdOutDist = bsxfun(@rdivide, bOutDist, mdOutDist);
        pdInDist = bsxfun(@rdivide, bInDist, mdInDist);
        direction = pdOut-pdIn;
        direction = direction/norm(direction);
        directionDist = pdOutDist-pdInDist;
        directionDist = bsxfun(@rdivide, directionDist, sqrt(sum(directionDist.^2,2)));
        pdSig(end+1) = quantile(directionDist*direction,.025)>0;
        
%         clf, hold on
%         sphere
%         axis image
%         plot3(pdOutDist(:,1),pdOutDist(:,2),pdOutDist(:,3),'r.')
%         plot3(pdInDist(:,1),pdInDist(:,2),pdInDist(:,3),'b.')
%         
%         hist(mdOutDist./mdInDist);
%         keyboard;
    end
end