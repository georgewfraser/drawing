function plotCoutSum(lags, coutSum) 
  for iiday=1:length(coutSum)
    cnames = fieldnames(coutSum{iiday});
    plotdim = ceil(sqrt(length(cnames)));
    for iicell=1:length(cnames)
        subplot(plotdim,plotdim,iicell);
        plot(lags, coutSum{iiday}.(cnames{iicell})(:,1:end-1));
        ylim([0 .5]);
        xlim([min(lags) max(lags)]);
    end
  end
end