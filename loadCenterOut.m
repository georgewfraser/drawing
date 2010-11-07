function merged = loadCenterOut(dataRoot, dates)
merged = cell(length(dates),1);
for iid=1:length(dates)
    filenames = cellstr(ls(sprintf('%s/%s/*.CenterOut.mat',dataRoot,datestr(dates(iid),'mmddyy'))));
    filenames = cellfun(@(x) [dataRoot '/' datestr(dates(iid),'mmddyy') '/' x], filenames, 'UniformOutput', false);
    merged{iid} = mergeFiles(filenames);
end