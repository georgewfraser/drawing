function varMean = meanByDrawing(snips, var)
% NO BIDIRECTIONAL
varMean = cell(size(var));
for day=1:length(snips)
    varMean{day} = struct();
    fields = fieldnames(var{day});
    for f=1:length(fields)
        X = var{day}.(fields{f});
        
        Xmean = nan(4,size(X,2));
        Xmean(1,:) = nanmean(X(~snips{day}.is_ellipse & ~snips{day}.is_illusion,:));
        Xmean(2,:) = nanmean(X(~snips{day}.is_ellipse & snips{day}.is_illusion,:));
        Xmean(3,:) = nanmean(X(snips{day}.is_ellipse & ~snips{day}.is_illusion,:));
        Xmean(4,:) = nanmean(X(snips{day}.is_ellipse & snips{day}.is_illusion,:));
        varMean{day}.(fields{f}) = Xmean;
    end
end