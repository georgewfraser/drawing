function showIllusionCovariateQuality(drawingSnips, disparity, canRate, coutSnips, coutDisp, canCout)


%%%%%%%%%%%%%%%%%
% Illusion trials
%%%%%%%%%%%%%%%%%
quality = cell(numel(canRate),1);
for day=1:length(canRate)
    xc = 0;
    sel = drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion;
    for trial=find(sel)'
        left = disparity{day}.x(trial,:);
        right = canRate{day}.canonical03(trial,:);
        left(1:20) = 0;
        left(end-19:end) = 0;
        xc = xc + xcov(left, right, 20, 'coef');
    end
    xc = xc / sum(sel);
    quality{day} = xc;
end
quality = cell2mat(quality);

subplot(3,1,1);
plot(-20:20,quality','k');
set(gca,'XTick',[-20 0 20]);
set(gca,'XTickLabel',[-1 0 1]);
ylabel('Cross-correlation');
title('Illusion');

%%%%%%%%%%%%%%%%%
% Non-illusion trials
%%%%%%%%%%%%%%%%%
quality = cell(numel(canRate),1);
time = cell(size(quality));
for day=1:length(canRate)
    xc = 0;
    sel = ~drawingSnips{day}.is_illusion;
%     trialErr = max(abs(disparity{day}.x),[],2);
%     sel = sel & trialErr>quantile(trialErr,.5);
    for trial=find(sel)'
        left = disparity{day}.x(trial,:);
        right = canRate{day}.canonical03(trial,:);
        left(1:20) = 0;
        left(end-19:end) = 0;
        xc = xc + xcov(left, right, 20, 'coef');
    end
    xc = xc / sum(sel);
    time{day} = mean(drawingSnips{day}.time(sel,:));
    quality{day} = xc;
end
quality = cell2mat(quality);

subplot(3,1,2);
plot(-20:20,quality','k');
set(gca,'XTick',[-20 0 20]);
set(gca,'XTickLabel',[-1 0 1]);
xlabel('Time (cycles)');
ylabel('Cross-correlation');
title('Non-illusion');

%%%%%%%%%%%%%%%%%
% Cout trials
%%%%%%%%%%%%%%%%%
quality = cell(numel(canRate),1);
time = cell(size(quality));
for day=1:length(canRate)
    xc = 0;
    for trial=1:size(coutSnips{day}.time,1)
        left = coutDisp{day}.x(trial,:);
        right = canCout{day}.canonical03(trial,:);
        xc = xc + xcov(left, right, 10, 'coef');
    end
    xc = xc / sum(sel);
    time{day} = mean(coutSnips{day}.time(sel,:));
    quality{day} = xc;
end
quality = cell2mat(quality);

subplot(3,1,3);
plot(-10:10,quality','k');
set(gca,'XTick',[-10 0 10]);
set(gca,'XTickLabel',[-1 0 1]);
xlabel('Time (reach)');
ylabel('Cross-correlation');
title('C.-out / out-c.');

set(gcf,'PaperPosition',[1 1 3.35 3.35*1.5]);