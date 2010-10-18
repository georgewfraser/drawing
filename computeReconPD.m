function pd = computeReconPD(snips, rate)
pd = cell(size(snips));
for day=1:length(pd)
    pd{day} = struct();
    fields = fieldnames(rate{day});
    X = repmat(snips{day}.targetPos(:,1:2),10,1);
    for iif=1:length(fields)
        % Just look at the first half of the movement
        y = rate{day}.(fields{iif})(:,6:15);
        y = bsxfun(@times,y,snips{day}.time(:,2)-snips{day}.time(:,1));
        y = y(:)*10;
        b = regress(y,[ones(size(X,1),1) X]);
        pd{day}.(fields{iif}) = b;
    end
end
        
        
