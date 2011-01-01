function [start, targ, both] = subtractMeanByTarget3D(snips, var)
start = cell(size(var));
targ = cell(size(var));
both = cell(size(var));
for day=1:length(snips)
    start{day} = struct();
    targ{day} = struct();
    both{day} = struct();
    fields = fieldnames(var{day});
    for f=1:length(fields)
        X = var{day}.(fields{f});
        % We are going to construct a mean such that each outward movement is
        % matched up with an inward movement
        start{day}.(fields{f}) = meanSub(X, snips{day}.startPos);
        targ{day}.(fields{f}) = meanSub(X, snips{day}.targetPos);
        both{day}.(fields{f}) = meanSub(X, [snips{day}.startPos snips{day}.targetPos]);
    end
end
end
function X = meanSub(X,targets)
utargets = unique(targets,'rows');

[tf,loc] = ismember(targets, utargets, 'rows');

Xsub = nan(size(X));
for row=1:size(X,1)
    Xsub(row,:) = X(row,:)-nanmean(X(loc'==loc(row) & (1:size(X,1))~=row,:));
end
X = Xsub;

end