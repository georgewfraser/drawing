function h = entropy(x)
u = unique(x,'rows');
h = 0;
for iiu=1:size(u,1)
    pu = bsxfun(@eq,x,u(iiu,:));
    pu = sum(pu,2)==size(x,2);
    pu = mean(pu);
    h = h - pu*log2(pu);
end
    