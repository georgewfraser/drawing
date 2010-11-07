function varMean = meanByTarget3DXY(snips, var)
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
        Xmean = [meanSub(X(outward,:),targets(outward,:)); meanSub(X(inward,:),targets(inward,:))];
        varMean{day}.(fields{f}) = Xmean;
    end
end
end
function Xmean = meanSub(X,targets)
th = (-pi+pi/4:pi/4:pi)';
[x,y] = pol2cart(th, norm(targets(1,:)));
utargets = [x y zeros(size(x))];
utargets = bsxfun(@rdivide,utargets,sqrt(sum(utargets.^2,2)));
utargets = bsxfun(@times,utargets,norm(targets(1,:)));
targets = round(targets*1000)/1000;
utargets = round(utargets*1000)/1000;

[tf,loc] = ismember(targets, utargets, 'rows');

Xmean = nan(length(utargets),size(X,2));

for iit=1:size(Xmean,1)
    Xmean(iit,:) = nanmean(X(iit==loc,:));
end
end