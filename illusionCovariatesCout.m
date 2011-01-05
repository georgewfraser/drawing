function pos = illusionCovariatesCout(coutSnips, coutKin)
pos = cell(size(coutSnips));

for day=1:length(coutSnips)
    targets = [coutSnips{day}.startPos coutSnips{day}.startPos];
    utargets = unique(targets,'rows');
    [tf,loc] = ismember(targets,utargets,'rows');
    
    pos{day} = struct('x',nan(size(coutKin{day}.posX)));
    for iit=1:length(loc)
        idealX = mean(coutKin{day}.posX(loc==iit,:));
        idealY = mean(coutKin{day}.posY(loc==iit,:));
        idealZ = mean(coutKin{day}.posZ(loc==iit,:));
        idealX = interpolate(1:20,idealX',1:.1:20);
        idealY = interpolate(1:20,idealY',1:.1:20);
        idealZ = interpolate(1:20,idealZ',1:.1:20);
        
        cursorX = coutKin{day}.posX(loc==iit,:);
        cursorY = coutKin{day}.posY(loc==iit,:);
        cursorZ = coutKin{day}.posZ(loc==iit,:);
        
        idx = kdtreeidx([idealX(:) idealY(:) idealZ(:)],[cursorX(:) cursorY(:) cursorZ(:)]);
        err = nan(size(cursorX));
        err(:) = cursorX(:)-idealX(idx);
        pos{day}.x(loc==iit,:) = err;
    
%         clf
%         for trial=1:min(12,size(err,1))
%         subplot(4,3,trial), hold on
%         plot(1:.1:20,idealX);
%         plot(1:20,cursorX(trial,:),'g');
%         plot(1:20,err(trial,:),'r');
%         end
%         compareX = nan(size(cursorX));
%         compareY = nan(size(cursorX));
%         compareZ = nan(size(cursorX));
%         compareX(:) = idealX(idx);
%         compareY(:) = idealY(idx);
%         compareZ(:) = idealZ(idx);
%         clf, hold on
%         plot3(idealX,idealY,idealZ);
%         plot3(cursorX(1,:),cursorY(1,:),cursorZ(1,:),'g');
%         for t=1:size(cursorX,2)
%             line([cursorX(1,t) compareX(1,t)],[cursorY(1,t) compareY(1,t)],[cursorZ(1,t) compareZ(1,t)]);
%         end
%         axis image
%         keyboard;
    end
end
        
