dataRoot = 'B:/Data/Arthur';
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
all = double([control perturb washout]');
all(all==0) = nan;
all = [min(all); max(all)]';
