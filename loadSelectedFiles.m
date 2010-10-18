function merged = loadSelectedFiles(fileFormat, dateFormat, dates, range)
merged = cell(length(dates),1);
for iid=1:length(dates)
    numbers = range(iid,1):range(iid,2);
    filenames = cell(length(numbers),1);
    for iif=1:length(numbers)
        filenames{iif} = sprintf(fileFormat, datestr(dates(iid),dateFormat), numbers(iif));
    end
    merged{iid} = mergeFiles(filenames);
end