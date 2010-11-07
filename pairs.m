function pairs(fun, X, varargin)
dim = size(X,2);
triangle = triu(true(dim),1);
[rows,cols] = find(triangle);
for i=1:length(rows)
    subplot(dim-1,dim-1,(rows(i)-1)*(dim-1)+(cols(i)-1));
    fun(X(:,cols(i)),X(:,rows(i)),varargin{:});
end