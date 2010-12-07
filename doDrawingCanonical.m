lagValues = -.050:.010:.050;
% lagValues = [0 -.010];

r = cell(size(lagValues));
day=1;
for lag=1:length(lagValues)
[basis, mask] = drawingBasisLag(drawingSnips(1), drawing(1), lagValues(lag));
mask{day}(~drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion,:) = false;
% subplot(4,4,lag);
% imagesc(mask{1});


% bday = structfun(@(x) x(mask{day}), basis{day}, 'UniformOutput', false);
% dday = structfun(@(x) x(mask{day}), drawingRate{day}, 'UniformOutput', false);
bday = structfun(@(x) x(:), basis{day}, 'UniformOutput', false);
dday = structfun(@(x) x(:), drawingRate{day}, 'UniformOutput', false);
X = cell2mat(struct2cell(bday)');
Y = cell2mat(struct2cell(dday)');
[A,B,r{lag}] = canoncorr(X,Y);
end

plot(lagValues,cellfun(@(X) X(1,1), r));