% combinedRate = cell(size(controlRate));
% for day=1:length(combinedRate)
%     fields = fieldnames(controlRate{day});
%     for unit=1:length(fields)
%         combinedRate{day}.(fields{unit}) = [controlRate{day}.(fields{unit}); perturbRate{day}.(fields{unit})];
%     end
% end
% 
% combinedCoeff = dayByDayFactors(combinedRate);
% combinedExplained = varianceExplainedCrossValidated(combinedRate);
% controlEmpiricalPd = empiricalPd(controlSnips, controlRate);
% nFactors = 9;
% nDays = length(combinedCoeff{nFactors});
% 
% 

parsimony = nan(nDays,nFactors);
units = cell(size(parsimony));
prefdir = cell(size(parsimony));
prefdirStd = nan(size(parsimony));
for day=1:nDays
    rateVariance = var(unravel(combinedRate{day}));
    th = structfun(@(x) cart2pol(x(1), x(2)), controlEmpiricalPd{day});
    C = unravel(combinedCoeff{nFactors}{day})';
    Cv = rotatefactors(C,'Maxit',10000);
    varimax{day} = reravel(Cv',combinedCoeff{nFactors}{day});
    % Multiply coefficients by variances of corresponding elements
    Cv = bsxfun(@times,rateVariance',Cv);
    % Negate columns of Cv that have more negative weight
    Cv = bsxfun(@times,Cv,sign(sum(Cv)));
    % Identify the positive weights that contribute the most to Cv
    sortCv = sort(Cv,'descend');
    % Convert to cumulative portion of Cv
    sortCv = cumsum(abs(sortCv));
    sortCv = bsxfun(@rdivide,sortCv,sortCv(end,:));
%     waterfall(sortCv');
%     pause(.5);
    for col=1:nFactors
        parsimony(day,col) = find(sortCv(:,col)>.7,1);
        [sortCol, idx] = sort(Cv(:,col),'descend');
        units{day,col} = idx(1:parsimony(day,col));
        prefdir{day,col} = th(idx(1:parsimony(day,col)));
        [x,y] = pol2cart(prefdir{day,col},1);
        thMean = cart2pol(mean(x),mean(y));
        prefdirStd(day,col) = sqrt(mean(wrapToPi(prefdir{day,col}-thMean).^2));
    end
end

% best = parsimony<quantile(parsimony(:),.1);
best = parsimony<30 & prefdirStd<1;
[day,factor] = find(best);
for i=1:length(day)
    figure(i);
    img = unravel(controlRateMean{day(i)});
    img = img(:,units{day(i),factor(i)});
    for unit=1:size(img,2)
        subplot(2,size(img,2),unit);
        imagesc(reshape(img(:,unit),16,20));
    end
    img = unravel(perturbRateMean{day(i)});
    img = img(:,units{day(i),factor(i)});
    for unit=1:size(img,2)
        subplot(2,size(img,2),size(img,2)+unit);
        imagesc(reshape(img(:,unit),16,20));
    end
end
        