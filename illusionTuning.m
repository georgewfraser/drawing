function model = illusionTuning(drawingRateMean, drawingSnipsMean, drawingKinMean)
model = zeros(0,2);
for day=1:length(drawingRateMean)
    vx = drawingKinMean{day}.velX([1 3 4],:);
    vy = drawingKinMean{day}.velY([1 3 4],:);
    motor = [vx(:) vy(:)];
    motor = bsxfun(@rdivide,motor,sqrt(sum(motor.^2,2)));
    
    illusion = drawingSnipsMean{day}.progress(4,:);
    illusion = (illusion-4)./2;
    illusion = max(illusion,0);
    illusion = min(illusion,1);
    illusion = [repmat(zeros(size(illusion)),2,1); illusion];
    illusion = illusion.*.8;
    illusion = illusion(:);
    
    independent = [ones(size(motor,1),1) motor bsxfun(@times,motor,illusion)];
    
    cnames = fieldnames(drawingRateMean{day});
    for unit=1:length(cnames)
        rate = drawingRateMean{day}.(cnames{unit})([1 3 4],:);
        b = regress(rate(:),independent);
        bnorm = b(2:3)/norm(b(2:3));
        
        model(end+1,1:2) = [norm(b(2:3)) b(4:5)'*bnorm];
    end
end