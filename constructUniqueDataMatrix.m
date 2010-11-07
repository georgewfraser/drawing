function [Y, alive, nBinsPerDay, colNames] = constructUniqueDataMatrix(rate, survival)
for day=1:length(rate)-1
    for unit=find(sum(survival{day},2)>0)'
        name = sprintf('Unit%0.2d_%d',ceil(unit/4),mod(unit-1,4)+1);
        if(~isfield(rate{day},name))
            survival{day}(unit,:) = 0;
        end
    end
    for unit=find(sum(survival{day},1)>0)
        name = sprintf('Unit%0.2d_%d',ceil(unit/4),mod(unit-1,4)+1);
        if(~isfield(rate{day+1},name))
            survival{day}(:,unit) = 0;
        end
    end
end
        
% Units that are alive today
current = zeros(1,800);
current(sum(survival{1},2)>0) = 1:sum(sum(survival{1},2)>0);
% Number of units we have encountered so far
unitCount = sum(current>0);
% Number of bins we have encountered so far
binCount = 0;
for day=1:length(rate)
    % For each unit that is active today
    names = fieldnames(rate{day});
    binCount = binCount+numel(rate{day}.(names{1}));
    
    if(day<length(rate))
        current = current*survival{day};
        % Units that are new tomorrow
        newUnits = sum(survival{day})>0 & current==0;
        % Give the new units labels in the current vector
        current(newUnits) = unitCount + (1:sum(newUnits));
        unitCount = unitCount + sum(newUnits);
    end
end

Y = nan(binCount,unitCount);
nBinsPerDay = nan(size(rate));
alive = false(numel(rate),unitCount);
colNames = cell(numel(rate),unitCount);

% Units that are alive today
current = zeros(1,800);
current(sum(survival{1},2)>0) = 1:sum(sum(survival{1},2)>0);
% Number of units we have encountered so far
unitCount = sum(current>0);
% Number of bins we have encountered so far
binCount = 0;
for day=1:length(rate)
    % For each unit that is active today
    alive(day,current(current>0)) = true;
    for unit=find(current>0)
        % Put the data in the appropriate location in Y
        name = sprintf('Unit%0.2d_%d',ceil(unit/4),mod(unit-1,4)+1);
        oneUnit = rate{day}.(name)(:);
        Y(binCount+(1:length(oneUnit)),current(unit)) = oneUnit;
        colNames{day,current(unit)} = name;
    end
    binCount = binCount+length(oneUnit);
    nBinsPerDay(day) = length(oneUnit);
    
    if(day<length(rate))
        current = current*survival{day};
        % Units that are new tomorrow
        newUnits = sum(survival{day})>0 & current==0;
        % Give the new units labels in the current vector
        current(newUnits) = unitCount + (1:sum(newUnits));
        unitCount = unitCount + sum(newUnits);
    end
end
        