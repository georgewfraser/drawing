function showGrangerCausality(varargin)
X = cell(1,length(varargin));
for i=1:length(varargin)
    X{i} = unravelRates(varargin{i});
end
X = cell2mat(X)';

[bic,aic] = cca_find_model_order(X,2,10);
ret = cca_granger_regress(X,aic,1);
[PR,q] = cca_findsignificance(ret,.01,1);
GC = ret.gc;
GC2 = GC.*PR;
causd = cca_causaldensity(GC,PR);
causf = cca_causalflow(GC,PR);
figure(1);
imagesc(GC2);
axis image;
set(gca,'Box','off');
title(['Granger causality, p<',num2str(.01)]);
xlabel('from');
ylabel('to');
figure(2);
nodenames = mat2cell(1:size(X,1));
nodenames{1} = 'x';
nodenames{2} = 'y';
cca_plotcausality(GC2,nodenames,1);
figure(3);
imagesc(GC);
axis image;
set(gca,'Box','off');
title('Granger causality, all');
xlabel('from');
ylabel('to');
figure(4);
cca_plotcausality(GC,nodenames,1);