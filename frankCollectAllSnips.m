dataRoot = 'B:/Data/Frank';

load B:\Data\Frank\frank-early-dates.mat
centerOut = loadCenterOut(dataRoot, dates);
nCells = cellfun(@(x) length(fieldnames(x.spikes)), centerOut);
centerOut = centerOut(nCells>60);
dates = dates(nCells>60);
drawing = loadDrawing(dataRoot, dates);

coutSnips = cell(size(centerOut));
coutRate = cell(size(centerOut));
coutKin = cell(size(centerOut));
drawingSnips = cell(size(centerOut));
drawingRate = cell(size(centerOut));
drawingKin = cell(size(centerOut));
for iid=1:length(centerOut)
    fprintf('.');
    coutSnips{iid} = snipPeak(centerOut{iid});
    coutRate{iid} = snipStabilizedSmoothedRate(coutSnips{iid}, centerOut{iid});
    coutKin{iid} = snipKinematics(coutSnips{iid}, centerOut{iid});
    drawingSnips{iid} = snipDrawingCycles(drawing{iid});
    drawingRate{iid} = snipStabilizedSmoothedRate(drawingSnips{iid}, drawing{iid});
    drawingKin{iid} = snipKinematics(drawingSnips{iid}, drawing{iid});
end
fprintf('\n');
coutRateMean = meanByTarget3D(coutSnips, coutRate);
coutKinMean = meanByTarget3D(coutSnips, coutKin);
drawingRateMean = meanByDrawing(drawingSnips, drawingRate);
drawingKinMean = meanByDrawing(drawingSnips, drawingKin);
coutSnipsMean = meanByTarget3D(coutSnips, coutSnips);
drawingSnipsMean = meanByDrawing(drawingSnips, drawingSnips);

[coutRate, coutRateMean, drawingRate, drawingRateMean] = synchFields(coutRate, coutRateMean, drawingRate, drawingRateMean);

clear drawing centerOut;

load B:/Data/Frank/survival.mat survival