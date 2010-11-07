function varMean = meanByTarget3D(snips, var)
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
utargets = target26(norm(targets(1,:)));
targets = round(targets*1000)/1000;
utargets = round(utargets*1000)/1000;
% for i=1:size(utargets,1),
%     text(utargets(i,1),utargets(i,2),utargets(i,3),sprintf('%d',i));
% end
% line([0 .1],[0 0],[0 0],'Color',[1 0 0]);
% line([0 0],[0 .1],[0 0],'Color',[0 1 0]);
% line([0 0],[0 0],[0 .1],'Color',[0 0 1]);
% axis image;
% xlim([-.1 .1]);
% ylim([-.1 .1]);
% zlim([-.1 .1]);

[tf,loc] = ismember(targets, utargets, 'rows');

Xmean = nan(length(utargets),size(X,2));

for iit=1:26
    Xmean(iit,:) = nanmean(X(iit==loc,:));
end
end