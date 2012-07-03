function varargout = synchFields(varargin)
varargout = cell(size(varargin));
for i=1:length(varargin)
    varargout{i} = cell(size(varargin{i}));
end

for day=1:length(varargin{1})
    % Determine the common fields
    fields = fieldnames(varargin{1}{day});
    for i=2:length(varargin)
        fields = intersect(fields,fieldnames(varargin{i}{day}));
    end
    
    % Remove extraneous fields and order
    for i=1:length(varargin)
        varargout{i}{day} = orderfields(rmfield(varargin{i}{day},setdiff(fieldnames(varargin{i}{day}),fields)));
    end
end