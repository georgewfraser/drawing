function [snr, correct] = extractDailyIsolation(dates)
snr = cell(size(dates));
correct = cell(size(dates));
for iid=1:length(dates)
    subdir = datestr(dates(iid),'mm-dd-yy');
    fprintf([subdir '/waves.mat\n']);
    load([subdir '/waves.mat']);
    [snr{iid},correct{iid}] = isolation(waves);
end