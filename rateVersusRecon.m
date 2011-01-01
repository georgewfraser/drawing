function [deltaPd, deltaMd, pdSig, mdSig] = rateVersusRecon(coutSnips, coutRate, coutRecon)
deltaPd = [];
deltaMd = [];
pdSig = [];
mdSig = [];

for day=1:length(coutSnips)
    targ = coutSnips{day}.targetPos-coutSnips{day}.startPos;
    out = sum(abs(coutSnips{day}.startPos),2)==0;
    
    cnames = fieldnames(coutRate{day});
    for unit=1:length(cnames)
        [bOut,dev,stats] = glmfit(targ(out,:),mean(coutRate{day}.(cnames{unit})(out,6:15),2));
        bOutDist = mvnrnd(bOut, stats.covb,1000);
        [bRecon,dev,stats] = glmfit(targ(out,:),mean(coutRecon{day}.(cnames{unit})(out,6:15),2));
        bReconDist = mvnrnd(bRecon, stats.covb,1000);
        bOut = bOut(2:end);
        bRecon = bRecon(2:end);
        bOutDist = bOutDist(:,2:end);
        bReconDist = bReconDist(:,2:end);
        
        deltaMd(end+1) = norm(bOut)/(norm(bOut)+norm(bRecon));
        mdOutDist = sqrt(sum(bOutDist.^2,2));
        mdReconDist = sqrt(sum(bReconDist.^2,2));
        deltaMdDist = mdOutDist./(mdOutDist+mdReconDist);
        deltaMdDist = (deltaMdDist-.5)*sign(deltaMd(end)-.5);
        mdSig(end+1) = quantile(deltaMdDist,.025)>0;
        
        pdOut = bOut/norm(bOut);
        pdRecon = bRecon/norm(bRecon);
        deltaPd(end+1) = acos(pdRecon'*pdOut);
        pdOutDist = bsxfun(@rdivide, bOutDist, mdOutDist);
        pdReconDist = bsxfun(@rdivide, bReconDist, mdReconDist);
        direction = pdOut-pdRecon;
        direction = direction/norm(direction);
        directionDist = pdOutDist-pdReconDist;
        directionDist = bsxfun(@rdivide, directionDist, sqrt(sum(directionDist.^2,2)));
        pdSig(end+1) = quantile(directionDist*direction,.025)>0;
        
%         clf, hold on
%         sphere
%         axis image
%         plot3(pdOutDist(:,1),pdOutDist(:,2),pdOutDist(:,3),'r.')
%         plot3(pdReconDist(:,1),pdReconDist(:,2),pdReconDist(:,3),'b.')
        
%         hist(mdOutDist./mdReconDist);
%         keyboard;
        
        
        [bOut,dev,stats] = glmfit(targ(~out,:),mean(coutRate{day}.(cnames{unit})(~out,6:20),2));
        bOutDist = mvnrnd(bOut, stats.covb,1000);
        [bRecon,dev,stats] = glmfit(targ(~out,:),mean(coutRecon{day}.(cnames{unit})(~out,6:20),2));
        bReconDist = mvnrnd(bRecon, stats.covb,1000);
        bOut = bOut(2:end);
        bRecon = bRecon(2:end);
        bOutDist = bOutDist(:,2:end);
        bReconDist = bReconDist(:,2:end);
        
        deltaMd(end+1) = norm(bOut)/(norm(bOut)+norm(bRecon));
        mdOutDist = sqrt(sum(bOutDist.^2,2));
        mdReconDist = sqrt(sum(bReconDist.^2,2));
        deltaMdDist = mdOutDist./(mdOutDist+mdReconDist);
        deltaMdDist = (deltaMdDist-.5)*sign(deltaMd(end)-.5);
        mdSig(end+1) = quantile(deltaMdDist,.025)>0;
        
        pdOut = bOut/norm(bOut);
        pdRecon = bRecon/norm(bRecon);
        deltaPd(end+1) = acos(pdRecon'*pdOut);
        pdOutDist = bsxfun(@rdivide, bOutDist, mdOutDist);
        pdReconDist = bsxfun(@rdivide, bReconDist, mdReconDist);
        direction = pdOut-pdRecon;
        direction = direction/norm(direction);
        directionDist = pdOutDist-pdReconDist;
        directionDist = bsxfun(@rdivide, directionDist, sqrt(sum(directionDist.^2,2)));
        pdSig(end+1) = quantile(directionDist*direction,.025)>0;
    end
end