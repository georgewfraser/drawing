dataRoot = 'E:/Grad/Data/Frank';

load frank-early-dates.mat
centerOut = loadCenterOut(dataRoot, dates);
nCells = cellfun(@(x) length(fieldnames(x.spikes)), centerOut);
centerOut = centerOut(nCells>60);
dates = dates(nCells>60);
drawing = loadDrawing(dataRoot, dates);

coutSnips = snipPeak(centerOut);
coutRate = snipSmoothedRate(coutSnips, centerOut, .4, 0);
coutKin = snipKinematics(coutSnips, centerOut);
drawingSnips = snipDrawingCycles(drawing);
drawingRate = snipSmoothedRate(drawingSnips, drawing, .4, 0);
drawingKin = snipKinematics(drawingSnips, drawing);

drawing = prune(drawing, drawingSnips, .75);
centerOut = prune(centerOut, coutSnips, .75);

coutRateMean = meanByTarget3D(coutSnips, coutRate);
coutKinMean = meanByTarget3D(coutSnips, coutKin);
drawingRateMean = meanByDrawing(drawingSnips, drawingRate);
drawingKinMean = meanByDrawing(drawingSnips, drawingKin);
coutSnipsMean = meanByTarget3D(coutSnips, coutSnips);
drawingSnipsMean = meanByDrawing(drawingSnips, drawingSnips);

[coutRate, coutRateMean, drawingRate, drawingRateMean] = synchFields(coutRate, coutRateMean, drawingRate, drawingRateMean);

loadLags;