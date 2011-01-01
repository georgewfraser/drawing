function [illusion, channel] = factor3Tuning(drawingRateMean, canB)
illusion = [];
channel = [];
for day=1:length(drawingRateMean)
    cnames = fieldnames(drawingRateMean{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
    
    B = pinv(canB{day});
    illusion(end+(1:length(cnames))) = B(3,:);%./sqrt(sum(B.^2));
end