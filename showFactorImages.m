function showFactorImages(factors, nFactors)
% fullscreen = get(0,'ScreenSize');
nDays = length(factors{1});
for day=1:nDays
    % 10 days per plot
    figure(ceil(day/10));
%     set(gcf,'Position',[0 -50 fullscreen(3) fullscreen(4)]);
    for f=1:nFactors
        subplot(10,10,mod(day-1,10)*10+f);
        imagesc(factors{nFactors}{day}.(sprintf('factor%0.2d',f)));
        box off; axis off;
    end
end