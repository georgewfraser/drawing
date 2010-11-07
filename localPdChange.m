function deltaTh = localPdChange(pd1, pd2)
deltaTh = cell(size(pd));
for day=1:length(pd)
    th1 = structfun(@(x) cart2pol(x(1),x(2)),pd1{day});
    th2 = structfun(@(x) cart2pol(x(1),x(2)),pd2{day});
    thD = wrapToPi(th2-th1);
    
    meanFilter = ~eye(size(thD,1));
    meanFilter = bsxfun(@rdivide, meanFilter, sqrt(sum(meanFilter.^2)));
    keyboard;
    thDMean = meanFilter*thD;
    deltaTh{day} = wrapToPi(thD-thDMean);
end