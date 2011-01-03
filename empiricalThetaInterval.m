function pd = empiricalThetaInterval(snips, rate, varargin)
if(isempty(varargin))
    time = 6:15;
else
    time = varargin{1};
end
pd = cell(size(rate));
for day=1:length(pd)
    pd{day} = struct();
    V = snips{day}.targetPos-snips{day}.startPos;
    dmask = sum(abs(V))>0;
    V = V(:,dmask);
    fields = fieldnames(rate{day});
    for unit=1:length(fields)
        firing = mean(rate{day}.(fields{unit})(:,time),2);
%         firing = firing-mean(firing);
%         pd{day}.(fields{unit}) = regress(firing,V)';
%         b = regress(firing,[ones(size(V,1),1) V]);
        [b,dev,stats] = glmfit(V,firing);
        bdist = mvnrnd(b,stats.covb,1000);
        th = cart2pol(bdist(:,2),bdist(:,3));
        pd{day}.(fields{unit}) = reshape(th,1,numel(th));%quantile(th,[.025 .975]);
    end
end
        
        