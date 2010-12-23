function [model, channel] = illusionTuning(drawingRateMean, drawingSnipsMean, drawingKinMean)
model = zeros(0,2);
channel = [];
for day=1:length(drawingRateMean)
    motor = drawingKinMean{day}.velX([1 3 4],:);
    motor = motor(:);
    
    illusion = drawingSnipsMean{day}.progress(4,:);
    illusion = (illusion-4)./2;
    illusion = max(illusion,0);
    illusion = min(illusion,1);
    illusion = [repmat(zeros(size(illusion)),2,1); illusion];
    illusion = illusion.*.8;
    illusion = illusion(:);
    
    independent = [ones(size(motor,1),1) motor motor.*illusion];
    
    cnames = fieldnames(drawingRateMean{day});
    channel(end+(1:length(cnames))) = cellfun(@(x) str2double(x(5:7)), cnames);
    for unit=1:length(cnames)
        rate = drawingRateMean{day}.(cnames{unit})([1 3 4],:);
        b = regress(rate(:),independent);
        
        model(end+1,1:2) = b(2:3)*sign(b(2));
    end
end
gscatter(model(:,1),model(:,2),channel>100,'br','.x',4)
biggest = sqrt(sum(model.^2,2));
[biggest,idx] = sort(biggest,'descend');
for i=1:100
    text(model(idx(i),1),model(idx(i),2),num2str(idx(i)));
end
axis image
line([0 25],[0 25])
line([0 25],[0 -25])
line([0 25],[0 0])
xlim([0 25]);
ylim([-25 25])
xlabel('Motor');
ylabel('Visual');
set(gcf,'PaperPosition',[0 0 3.35/2 3.35])