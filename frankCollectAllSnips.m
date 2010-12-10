% dataRoot = 'B:/Data/Frank';
% 
% load B:\Data\Frank\frank-early-dates.mat
% centerOut = loadCenterOut(dataRoot, dates);
% nCells = cellfun(@(x) length(fieldnames(x.spikes)), centerOut);
% centerOut = centerOut(nCells>60);
% dates = dates(nCells>60);
% drawing = loadDrawing(dataRoot, dates);
% load B:/Data/Frank/survival.mat survival
% survival = survival(nCells>60);
% 
% coutSnips = snipPeak(centerOut);
% coutRate = snipSmoothedRate(coutSnips, centerOut);
% coutKin = snipKinematics(coutSnips, centerOut);
% drawingSnips = snipDrawingCycles(drawing);
% drawingRate = snipSmoothedRate(drawingSnips, drawing);
% drawingKin = snipKinematics(drawingSnips, drawing);
% 
% drawing = prune(drawing, drawingSnips, .5);
% centerOut = prune(centerOut, coutSnips, .5);

coutRateMean = meanByTarget3D(coutSnips, coutRate);
coutKinMean = meanByTarget3D(coutSnips, coutKin);
drawingRateMean = meanByDrawing(drawingSnips, drawingRate);
drawingKinMean = meanByDrawing(drawingSnips, drawingKin);
coutSnipsMean = meanByTarget3D(coutSnips, coutSnips);
drawingSnipsMean = meanByDrawing(drawingSnips, drawingSnips);

[coutRate, coutRateMean, drawingRate, drawingRateMean] = synchFields(coutRate, coutRateMean, drawingRate, drawingRateMean);
