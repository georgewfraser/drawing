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
% coutSnips = cell(size(centerOut));
% coutRate = cell(size(centerOut));
% coutKin = cell(size(centerOut));
% drawingSnips = cell(size(centerOut));
% drawingRate = cell(size(centerOut));
drawingLagRate = cell(size(centerOut));
% drawingKin = cell(size(centerOut));
for iid=1:length(centerOut)
    fprintf('.');
%     coutSnips{iid} = snipPeak(centerOut{iid});
%     coutRate{iid} = snipSmoothedRate(coutSnips{iid}, centerOut{iid});
%     coutKin{iid} = snipKinematics(coutSnips{iid}, centerOut{iid});
%     drawingSnips{iid} = snipDrawingCycles(drawing{iid});
%     drawingRate{iid} = snipSmoothedRate(drawingSnips{iid}, drawing{iid});
    drawingLagRate{iid} = snipSmoothedRate(drawingSnips{iid}, drawing{iid}, -.1);
%     drawingKin{iid} = snipKinematics(drawingSnips{iid}, drawing{iid});
end
% fprintf('\n');
% coutRateMean = meanByTarget3D(coutSnips, coutRate);
% coutKinMean = meanByTarget3D(coutSnips, coutKin);
% drawingRateMean = meanByDrawing(drawingSnips, drawingRate);
% drawingKinMean = meanByDrawing(drawingSnips, drawingKin);
% coutSnipsMean = meanByTarget3D(coutSnips, coutSnips);
% drawingSnipsMean = meanByDrawing(drawingSnips, drawingSnips);

[coutRate, coutRateMean, drawingRate, drawingLagRate, drawingRateMean] = synchFields(coutRate, coutRateMean, drawingRate, drawingLagRate, drawingRateMean);
