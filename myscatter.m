function myscatter(x,y,groups,varargin)
hold on;
ugroups = unique(groups);
colors = jet(numel(ugroups));
for i=1:length(ugroups)
    sel = groups==ugroups(i);
    plot(x(sel),y(sel),'.','Color',colors(i,:),varargin{:});
end
    