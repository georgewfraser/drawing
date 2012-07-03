function day = reravel(X, day)
fields = fieldnames(day);
for iif=1:length(fields)
    day.(fields{iif})(:) = X(:,iif);
end