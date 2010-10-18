dataRoot = 'B:/Data/Willy';
addpath B:\git\my-analysis\unitid
addpath B:\git\my-analysis\unitid\common

dates = ls(dataRoot);
dates = dates(:,1:8);
dates = dates(dates(:,3)=='-' & dates(:,6)=='-',:);
dates = datenum(dates,'mm-dd-yy');
dates = sort(dates);

metadata = extractMetadata([dataRoot '/metadata.txt']);

[tf,loc] = ismember(dates, metadata.Date);
control = metadata.Control(loc,:);
perturb = metadata.Perturb(loc,:);
washout = metadata.Washout(loc,:);

merged = loadMergedFiles([dataRoot '/%s/*.BC.*.mat'], 'mm-dd-yy', dates);
merged = merged(dates);
spiketimes = data2Cells(merged);
clear merged;
wmean = dailyWaveMeans(dataRoot, dates);

for day=1:length(wmean)
    mask = cellfun(@isempty, wmean{day});
    spiketimes{day}(mask) = cell(1,sum(mask));
end

correlations = computeDailyCorrelations(spiketimes);
auto = computeDailyAutocorrelations(spiketimes);
wmean = dailyWaveMeans(dataRoot, dates);

% Arthur has a few units with no waveforms recorded.  We need to wipe them
% out from the score matrices

autoscore = computeAutoScore(auto);
wavescore = computeWaveScore(wmean);
[survival, score] = iterateSurvival(spiketimes, correlations, wavescore, autoscore);
corrscore = computeCorrScore(correlations,survival);


autoscorem = cell2mat(autoscore);
wavescorem = cell2mat(wavescore);
corrscorem = cell2mat(corrscore);
survivalm = cell2mat(survival);

[cp, byvar, sensitivityTable, specificityTable, correct] = gaussianMix(corrscorem, wavescorem, autoscorem);

save([dataRoot '/survival.mat'], 'survival', 'correlations', 'autoscore', 'wavescore');