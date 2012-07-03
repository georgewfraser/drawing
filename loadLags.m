lags = -.75:.05:.75;
lagCoutKin = cell(length(lags),1);
lagDrawingKin = cell(length(lags),1);

fprintf('Computing %d lagged rates\n', length(lags));
for iil=1:length(lags)
    fprintf('.');
    lagCoutKin{iil} = snipKinematics(coutSnips, centerOut, lags(iil));
    lagDrawingKin{iil} = snipKinematics(drawingSnips, drawing, lags(iil));
end
fprintf('\n');