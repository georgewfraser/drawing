% lags = whiteLags(drawingSnips(11), drawingKin(11), drawingRate(11));
% lagValues = -.500:.010:.500;
% lags = lags{1};
fields = fieldnames(lags{10});
plotDim = ceil(sqrt(length(fields)));
for unit=1:length(fields)
    subplot(plotDim,plotDim,unit);
    plot(lagValues, lags{10}.(fields{unit}));
end
% lags = whiteLags(drawingSnips, drawingKin, drawingRate);
% L = pullLags(lags);
% hist(lagValues(L(~isnan(L))),lagValues);