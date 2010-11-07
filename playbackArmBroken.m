function v = playbackArm(filename, coeff)
fhandle = gcf();
clf;
set(gcf,'Position',[100 100 1024 768]);
set(gca,'Position',[0 0 1 1]);
hold on;
colormap([0 0 .8; .8 .8 .8; 0 .8 0]);
caxis([0 1]);
caxis manual;
lighting phong;
set(gcf,'Renderer','zbuffer')
light('Position',[1 1 1],'Style','infinite');
axis image;
axis off;
box off;
options = {'FaceLighting','phong','FaceColor','interp',...
              'AmbientStrength',0.5,'EdgeColor','none','LineStyle','none'};
boxSize = [.09 .09];
boxCorner = cell(3,1);
for i=1:3
    boxCorner{i} = [.1 .15-i/10]+[.005 .005];
    drawBox(boxCorner{i}, boxSize, i);
end

data = load(filename);

[x,y,z] = sphere();
x = x.*data.header.cout.CursorRadius;
y = y.*data.header.cout.CursorRadius;
z = z.*data.header.cout.CursorRadius;
if(data.header.cout.CursorRadius~=data.header.cout.TargetRadius)
    error('Cursor radius ~= target radius');
end

trial = 0;
holdADone = true;
invisibleDone = true;
holdBDone = true;

successEvents = bsxfun(@plus,data.trials.ComputerTrialTime, [zeros(size(data.trials.ComputerTrialTime)) data.trials.HoldAStart data.trials.HoldAFinish data.trials.HoldBStart data.trials.HoldBFinish data.trials.ComputerFinishTime-data.trials.ComputerTrialTime]);
failureEvents = bsxfun(@plus,data.fail_trials.ComputerTrialTime, [zeros(size(data.fail_trials.ComputerTrialTime)) data.fail_trials.HoldAStart data.fail_trials.HoldAFinish data.fail_trials.HoldBStart data.fail_trials.HoldBFinish data.fail_trials.ComputerFinishTime-data.fail_trials.ComputerTrialTime]);
events = [successEvents; failureEvents];
startPos = [data.trials.StartPos; data.fail_trials.StartPos];
targetPos = [data.trials.TargetPos; data.fail_trials.TargetPos];

[events, idx] = sortrows(events);
startPos = startPos(idx,:);
targetPos = targetPos(idx,:);

emTime = (data.kinematics.PlexonTime-data.header.PlexonOffset)/data.header.PlexonSlew;
emPos = data.kinematics.Markers;
cursor_transform = data.header.CursorTransform(1:3,:);
cursor_transform(1,:) = cursor_transform(1,:) ./ abs(sum(cursor_transform(1,1:3)));
emPos = [emPos ones(size(emPos,1),1)] * cursor_transform';

% Compute low-dimensional factors
nsmooth = 30;
smoother = cos(-pi+pi/nsmooth:2*pi/nsmooth:pi-pi/nsmooth)+1;
smoother = smoother./norm(smoother);
npad = floor(nsmooth/2);
fields = fieldnames(coeff);
centers = emTime';
centers = [centers(1)+diff(centers(1:2))*(-npad:-1) ...
           centers ...
           centers(end)+diff(centers(end-1:end))*(1:npad)]; %#ok<AGROW>
edges = [centers(1) - (centers(2)-centers(1))./2, ...
         centers(1:end-1)+diff(centers)./2, ...
         centers(end) + (centers(end)-centers(end-1))./2];
edges = data.header.PlexonOffset + data.header.PlexonSlew*edges;
edges = edges';
rate = nan(length(emTime),length(fields));
for unit=1:length(fields)
    counts = quickHist(data.spikes.(fields{unit}),edges);
    counts = sqrt(counts) ./ sqrt(diff(edges));
    counts = filter(smoother,1,counts);
    counts = counts(npad*2+1:end);
    rate(:,unit) = counts;
end
coeff = unravel(coeff);
factors = rate*pinv(coeff);
factors = bsxfun(@minus,factors,min(factors));
factors = bsxfun(@rdivide,factors,max(factors));
factors = factors .* boxSize(2);

factorHandle = cell(3,1);
hT = nan;
v = struct();
for frame=2:2:min(60*60,numel(emTime))

    ptime = emTime(frame);

    % Send the cursor position
    pos = emPos(frame,:);
    if(~isnan(pos(1)))
        c = ones(size(z));
        hC = surf(x+pos(1),y+pos(2),z+pos(3),c,options{:});
    end

    % Test if we have entered a new trial
    if(trial<size(events,1) && ptime>events(trial+1,1))
        trial = trial+1;
        holdADone = false;
        invisibleDone = false;
        holdBDone = false;
        c = zeros(size(z));
        if(~isnan(hT))
            delete(hT);
            hT = nan;
        end
        hT = surf(x+startPos(trial,1),y+startPos(trial,2),z+startPos(trial,3),c,options{:});
        posT = startPos(trial,:);
    end
    % Test if we have finished hold a
    if(~holdADone && ptime>events(trial,3))
        holdADone = true;
        c = zeros(size(z));
        if(~isnan(hT))
            delete(hT);
            hT = nan;
        end
        hT = surf(x+targetPos(trial,1),y+targetPos(trial,2),z+targetPos(trial,3),c,options{:});
        posT = targetPos(trial,:);
%         if(data.header.cout.cursorInvisibleZone>0)
%             set(hC,'FaceAlpha',.25);
%         end
    end
    if(holdADone && ~invisibleDone && norm(pos)>data.header.cout.cursorInvisibleZone)
        invisibleDone = true;
%         set(hC,'FaceAlpha',1);
    end
    % Test if we have finished hold b
    if(~holdBDone && ptime>events(trial,5))
        holdBDone = true;
        if(~isnan(hT))
            delete(hT);
            hT = nan;
        end
    end
    % Test if have failed the trial
    if(trial ~= 0 && frame<length(emTime) && emTime(frame+1)>events(trial,end))
        if(~isnan(hT))
            delete(hT);
            hT = nan;
        end
    end
    
    if(~isnan(hT) && norm(pos-posT)<data.header.cout.CursorRadius+data.header.cout.TargetRadius)
        c = ones(size(z))*.5;
        set(hT,'CData',c);
    end
    
    if(frame>120)
        for f=1:3
            factorHandle{f} = plotFactor(f);
        end
    end
        
    
    xlim([-.1 .2]);
    ylim([-.15 .15]);
    zlim([-.1 .1]);
    
    
    v.frames(frame/2) = getframe(fhandle);
    v.times(frame/2) = frame/60;
    
    if(~isnan(pos(1)))
        delete(hC);
    end
    
    if(frame>120)
        for f=1:3
            for sub=1:length(factorHandle{f});
                delete(factorHandle{f}{sub});
            end
        end
    end
end   
v.width=size(v.frames(1).cdata,2);
v.height=size(v.frames(1).cdata,1);
% movie(F,1,30);

function h = plotFactor(f)
timeWindow = frame-120:frame;
timeWindow(timeWindow<1) = 1;
factorY = factors(timeWindow,f)+boxCorner{f}(2);
factorX = (1:length(factorY))/length(factorY)*boxSize(1)+boxCorner{f}(1);
h = cell(5,1);
h{1} = plot(factorX,factorY, 'LineWidth', 2);

for e=2:5
    evt = events(trial,e);
    evtX = interp1(emTime(timeWindow),factorX,evt);
    evtY = interp1(emTime(timeWindow),factorY,evt);
    if(e>3)
        col = [1 0 0];
    else
        col = [0 1 0];
    end
    h{e} = line([evtX evtX],[evtY-.01 evtY+.01],'Color',col);
end
end

end

function drawBox(boxCorner, boxSize, f)
line(boxCorner(1)+[0 boxSize(1)],boxCorner(2)+[boxSize(2) boxSize(2)],'Color',[0 0 0]);
line(boxCorner(1)+[0 boxSize(1)],boxCorner(2)+[0 0],'Color',[0 0 0]);
line(boxCorner(1)+[boxSize(1) boxSize(1)],boxCorner(2)+[0 boxSize(2)],'Color',[0 0 0]);
line(boxCorner(1)+[0 0],boxCorner(2)+[0 boxSize(2)],'Color',[0 0 0]);
text(boxCorner(1),boxCorner(2),sprintf('Factor %d',f),'VerticalAlignment','bottom','FontSize',20);
end