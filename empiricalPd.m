function pd = empiricalPd(rateMean)
pd = cell(size(rateMean));
th = -pi+pi/8:pi/8:pi;
[x,y] = pol2cart(th',1);
for day=1:length(pd)
    pd{day} = struct();
    fields = fieldnames(rateMean{day});
    for iif=1:length(fields)
        firing = mean(rateMean{day}.(fields{iif})(:,6:15),2);
        firing = firing-mean(firing);
        b = regress(firing,[x y]);
        pd{day}.(fields{iif}) = b;
    end
end
        
        
