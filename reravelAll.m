function days = reravelAll(X, days)
count = 0;
for iid=1:length(days)
    days{iid} = reravel(X(:,count+(1:length(fieldnames(days{iid})))), days{iid});
    count = count + length(fieldnames(days{iid}));
end