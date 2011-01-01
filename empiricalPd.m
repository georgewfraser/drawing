function pd = empiricalPd(snips, rate)
pd = cell(size(rate));
for day=1:length(pd)
    pd{day} = struct();
    V = snips{day}.targetPos-snips{day}.startPos;
    dmask = sum(abs(V))>0;
    V = V(:,dmask);
    fields = fieldnames(rate{day});
    for unit=1:length(fields)
        firing = mean(rate{day}.(fields{unit})(:,6:15),2);
        firing = firing-mean(firing);
        pd{day}.(fields{unit}) = regress(firing,V)';
%         [b,dev,stats] = glmfit(V,firing,'normal','constant','off');
%         bdist = mvnrnd(stats.beta,stats.covb,1000);
%         th = cart2pol(bdist(:,1),bdist(:,2));
%         pd{day}.(fields{unit}) = stats.beta';
    end
end
        
        