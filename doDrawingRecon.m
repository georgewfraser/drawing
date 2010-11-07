drawingNoIllusion = cell(size(drawingRate));
for day=1:length(drawingNoIllusion)
    drawingNoIllusion{day} = struct();
    fields = fieldnames(drawingRate{day});
    for unit=1:length(fields)
        drawingNoIllusion{day}.(fields{unit}) = drawingRate{day}.(fields{unit})(~drawingSnips{day}.is_illusion,:);
    end
end
noIllusionCoeff = dayByDayFactors(drawingNoIllusion);
[explained, drawingRecon] = varianceExplainedLeaveOneOut(drawingRateMean, noIllusionCoeff);
drawingReconMean = cell(size(drawingRecon));
for day=1:length(drawingRecon)
    drawingReconMean{day} = meanByDrawing(drawingSnips{day}, drawingRecon{10}{day});
end
