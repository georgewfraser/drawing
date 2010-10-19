function pd = confidentPd(snips, rate)
pd = cell(size(rate));
for day=1:length(pd)
    pd{day} = struct();
    V = snips{day}.targetPos-snips{day}.startPos;
    V = V(:,1:2);
    fields = fieldnames(rate{day});
    for unit=1:length(fields)
        firing = mean(rate{day}.(fields{unit})(:,6:15),2);
        firing = firing-mean(firing);
        [b,dev,stats] = glmfit(V,firing,'normal','constant','off');
        bdist = mvnrnd(stats.beta,stats.covb,1000);
        th = cart2pol(bdist(:,1),bdist(:,2));
        if(std(th)<5*pi/180)
            pd{day}.(fields{unit}) = stats.beta';
        else
            pd{day}.(fields{unit}) = nan(size(stats.beta'));
        end
    end
end
        
        