nPoints = size(drawingSnips{1}.time,2);
perCycle = nPoints/7;

canCout = projectDown(canCoeff,coutRate);
canDrawing = projectDown(canCoeff,drawingRate);
canCoutMean = meanByTarget3D(coutSnips, canCout);
canDrawingMean = meanByDrawing(drawingSnips, canDrawing);
covariates = drawingCovariates(drawingKin, drawingSnips);
covariatesMean = meanByDrawing(drawingSnips, covariates);

% lagValues = -.750:.010:.750;
nCanonical = 7;
% [direction, illusion] = computeAllLags(coutSnipsMean, coutKinMean, canCoutMean, drawingSnipsMean, drawingKinMean, canDrawingMean, nCanonical, false);

clf;
for c=1:nCanonical
    subplot(6,nCanonical,c);
    hold on;
    name = sprintf('canonical%0.2d',c);
    img = cellfun(@(x) x.(name), canRate, 'UniformOutput', false);
    img = cell2mat(shiftdim(img,-2));
    img = img([1 3 4],:,:);
    
    img(1,:,:) = img(1,:,:)-max(max(img(1,:,:)));
    for i=2:3
        img(i,:,:) = img(i,:,:)-max(max(img(i,:,:)))+min(min(img(i-1,:,:)));
    end
    for day=1:size(img,3)
        plot(img(:,:,day)');
    end
    set(gca,'XTick',perCycle:perCycle:nPoints-perCycle);
    set(gca,'XTickLabel',1:5);%{'Cycle 1','Cycle 2','Cycle 3','Cycle 4','Cycle 5'});
    ylim([-11 0]);
    xlim([0 nPoints])
    
    name = sprintf('factor%0.2d',c);
    for day=1:length(canCoutMean)
        % Extract the center-out / out-center profile
        profile = canCoutMean{day}.(name);
%         profile = mean(profile(:,6:15),2);
        profile = mean(profile(:,10:13),2);
        targets = coutSnipsMean{day}.targetPos-coutSnipsMean{day}.startPos;
        z0 = targets(:,3)==0;
        outC = sum(abs(coutSnipsMean{day}.targetPos),2)==0;
        th = cart2pol(targets(:,1),targets(:,2));
        if(sum(z0)~=16 || mean(outC) ~= .5)
            error('The targets look wrong');
        end
        % Take only targets in the x-y plane
        outC = outC(z0);
        th = th(z0);
        profile = profile(z0);
        % Sort by direction
        [th,idx] = sort(th);
        outC = outC(idx);
        profile = profile(idx);
        % Stack up c-out / out-c
        th = [th(~outC) th(outC)];
        profile = [profile(~outC) profile(outC)];
        
        subplot(6,nCanonical,nCanonical+c);
        hold on;
        plot(-pi:pi/4:pi,profile([end 1:end],:));
        set(gca,'XTick',[-pi 0 pi]);
        set(gca,'XTickLabel',{'-pi','0','pi'});
        xlim([-pi pi]);
        ylim([-2 2]);

        profile = canCoutMean{day}.(name);
        subplot(6,nCanonical,nCanonical*2+c);
        hold on;
        outC = sum(abs(coutSnipsMean{day}.targetPos),2)==0;
        timeProfile = [mean(profile(~outC,:)); mean(profile(outC,:))]';
        plot(timeProfile);
        xlim([0 length(timeProfile)]);
        ylim([-2 2]);
        set(gca,'XTick',[5.5 15.5]);
        set(gca,'XTickLabel',{'Hold A', 'Hold B'});
        
%         subplot(6,nCanonical,nCanonical*3+c);
%         hold on;
%         plot(lagValues, direction{day}.(name));
% %         best = find(direction{day}.(name)==max(direction{day}.(name)));
% %         line(lagValues([best best]),[0 direction{day}.(name)(best)]);
%         xlabel('Lag');
%         ylabel('Correlation');
%         xlim([min(lagValues) max(lagValues)]);
%         ylim([-1 1]);
%         title('Direction');
%         
%         subplot(6,nCanonical,nCanonical*4+c);
%         hold on;
%         plot(lagValues, illusion{day}.(name));
% %         best = find(illusion{day}.(name)==max(illusion{day}.(name)));
% %         line(lagValues([best best]),[0 illusion{day}.(name)(best)]);
%         xlabel('Lag');
%         ylabel('Correlation');
%         xlim([min(lagValues) max(lagValues)]);
%         ylim([-1 1]);
%         title('Illusion');
    end
    
    
end