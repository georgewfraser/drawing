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
% varimax = cell(nDays,1);
% parsimony = nan(nDays,nFactors);
% prefdir = cell(size(parsimony));
% prefdirStd = nan(size(parsimony));
% for day=1:nDays
%     rateVariance = var(unravel(combinedRate{day}));
%     th = structfun(@(x) cart2pol(x(1), x(2)), controlEmpiricalPd{day});
%     C = unravel(combinedCoeff{nFactors}{day})';
%     Cv = rotatefactors(C,'Maxit',10000);
%     varimax{day} = reravel(Cv',combinedCoeff{nFactors}{day});
%     % Multiply coefficients by variances of corresponding elements
%     Cv = bsxfun(@times,rateVariance',Cv);
%     % Negate columns of Cv that have more negative weight
%     Cv = bsxfun(@times,Cv,sign(sum(Cv)));
%     % Identify the positive weights that contribute the most to Cv
%     sortCv = sort(Cv,'descend');
%     % Convert to cumulative portion of Cv
%     sortCv = cumsum(abs(sortCv));
%     sortCv = bsxfun(@rdivide,sortCv,sortCv(end,:));
% %     waterfall(sortCv');
% %     pause(.5);
%     for col=1:nFactors
%         parsimony(day,col) = find(sortCv(:,col)>.7,1);
%         [sortCol, idx] = sort(Cv(:,col),'descend');
%         prefdir{day,col} = th(idx(1:parsimony(day,col)));
%         [x,y] = pol2cart(prefdir{day,col},1);
%         thMean = cart2pol(mean(x),mean(y));
%         prefdirStd(day,col) = sqrt(mean(wrapToPi(prefdir{day,col}-thMean).^2));
%     end
% end

best = parsimony<10 & prefdirStd<1;

idx = find(best);
plotDim = ceil(sqrt(length(idx)));
for i=1:length(idx)
    subplot(plotDim,plotDim,i);
    [x, y] = pol2cart(prefdir{idx(i)}',1);
    xlim([-1 1]);
    ylim([-1 1]);
    line([zeros(size(x)); x],[zeros(size(y)); y]);
end
        