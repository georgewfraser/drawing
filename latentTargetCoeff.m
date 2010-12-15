function rateMean = latentTargetCoeff(rateMean)
for day=1:length(rateMean)
rateMean{day} = structfun(@(X) mean(X,2)', rateMean{day}, 'UniformOutput', false);
end
rateMean = {rateMean};