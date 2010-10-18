function showAllDatesAllTargetImages(rateMean)
n = sum(cellfun(@(x) numel(fieldnames(x)), rateMean));
plotDim = ceil(sqrt(n));

caret = 0;
for day=1:length(rateMean)
    fields = fieldnames(rateMean{day});
    for i=1:length(fields)
        caret = caret+1;
        
        subplot(plotDim,plotDim,caret);
        imagesc(rateMean{day}.(fields{i}));
    end
end
        