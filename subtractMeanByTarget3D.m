function varMean = subtractMeanByTarget3D(snips, var)
varMean = cell(size(var));
for day=1:length(snips)
    varMean{day} = struct();
    fields = fieldnames(var{day});
    for f=1:length(fields)
        X = var{day}.(fields{f});
        outward = sum(abs(snips{day}.startPos),2)==0;
        inward = ~outward;
        targets = snips{day}.targetPos-snips{day}.startPos;
        % We are going to construct a mean such that each outward movement is
        % matched up with an inward movement
        X(outward,:) = meanSub(X(outward,:),targets(outward,:));
        X(inward,:) = meanSub(X(inward,:),targets(inward,:));
        varMean{day}.(fields{f}) = X;
    end
end
end
function X = meanSub(X,targets)
utargets = target26(norm(targets(1,:)));
targets = round(targets*1000)/1000;
utargets = round(utargets*1000)/1000;

[tf,loc] = ismember(targets, utargets, 'rows');

Xsub = nan(size(X));
for row=1:size(X,1)
    Xsub(row,:) = X(row,:)-nanmean(X(loc'==loc(row) & (1:size(X,1))~=row,:));
end
X = Xsub;

end