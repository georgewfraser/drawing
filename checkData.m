function checkData(controlData, perturbData, control, perturb, dates, monkey)
for day=1:length(dates)
    fprintf('%s \n',datestr(dates(day)));
    
    filenum = control(day,1)+floor(rand(1)*diff(control(day,:)));
    filename = sprintf('B:/Data/%s/%s/%s.BC.%0.5d.CenterOut.mat',monkey,datestr(dates(day),'mm-dd-yy'), monkey, filenum);
    fprintf('%s \n', filename);
    
    testData = load(filename);
    
    cnames = fieldnames(testData.spikes);
    for unit=1:length(cnames)
        fromFile = testData.spikes.(cnames{unit});
        fromMerged = controlData{day}.spikes.(cnames{unit});
        first = find(fromMerged==fromFile(1));
        fromMerged = fromMerged(first+(1:length(fromFile))-1);
        if(any(fromFile~=fromMerged))
            keyboard;
        end
    end
    
    fromFile = testData.trials.PlexonTrialTime;
    fromMerged = controlData{day}.trials.PlexonTrialTime;
    first = find(fromMerged==fromFile(1));
    fromMerged = fromMerged(first+(1:length(fromFile))-1);
    if(any(fromFile~=fromMerged))
        keyboard;
    end
    
    filenum = perturb(day,1)+5+floor(rand(1)*(diff(perturb(day,:))-5));
    filename = sprintf('B:/Data/%s/%s/%s.BC.%0.5d.CenterOut.mat',monkey,datestr(dates(day),'mm-dd-yy'), monkey, filenum);
    fprintf('%s \n', filename);
    
    testData = load(filename);
    
    cnames = fieldnames(testData.spikes);
    for unit=1:length(cnames)
        fromFile = testData.spikes.(cnames{unit});
        fromMerged = perturbData{day}.spikes.(cnames{unit});
        first = find(fromMerged==fromFile(1));
        fromMerged = fromMerged(first+(1:length(fromFile))-1);
        if(any(fromFile~=fromMerged))
            keyboard;
        end
    end
    
    fromFile = testData.trials.PlexonTrialTime;
    fromMerged = perturbData{day}.trials.PlexonTrialTime;
    first = find(fromMerged==fromFile(1));
    fromMerged = fromMerged(first+(1:length(fromFile))-1);
    if(any(fromFile~=fromMerged))
        keyboard;
    end
end