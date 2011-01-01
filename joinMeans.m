function combined = joinMeans(rate, survival)
combined = struct();

% Population on day 0
ids = zeros(1,800);
maxId = 0;

for day=1:length(rate)
    % Move around ids according to survival
    if(day>1)
        ids = ids*survival{day-1};
    end
    
    % Identify new cells
    newIds = sum(survival{day},2)'>0 & ids==0;
    ids(newIds) = maxId + (1:sum(newIds));
    maxId = maxId + sum(newIds);
    
    for unit=find(newIds)
        name = sprintf('C%d_N%d',ceil(unit/4),ids(unit));
        combined.(name) = cell(length(survival),1);
    end
        
    
    for unit=find(ids~=0)
        name = sprintf('C%d_N%d',ceil(unit/4),ids(unit));
        rname = sprintf('Unit%0.3d_%d',ceil(unit/4),mod(unit-1,4)+1);
        if(~isfield(rate{day},rname))
            warning('Nonsensical unit %s on day %d',rname,day); %#ok<WNTAG>
        else
            combined.(name){day} = rate{day}.(rname);
        end
    end
end

lifespan = structfun(@(x) sum(~cellfun(@isempty,x)), combined);
threshold = sort(lifespan,'descend');
threshold = threshold(75);
fields = fieldnames(combined);
combined = rmfield(combined, fields(lifespan<threshold));
combined = structfun(@cellmean, combined, 'UniformOutput', false);
end

function xmean = cellmean(x)
x = x(~cellfun(@isempty,x));
xmean = x{1};
for i=2:length(x)
    xmean = xmean + x{i};
end
xmean = xmean ./ length(x);
end