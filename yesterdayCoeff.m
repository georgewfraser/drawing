function [crossCoeff, survCoeff] = yesterdayCoeff(rate, survival)
names = fieldnames(rate{1});
LONG_NAMES = length(names{1})>8;

crossRate = cell(size(rate));
survRate = cell(size(rate));
for day=2:length(rate)
    % Construct a matrix of yesterday's coefficients using the surviving
    % units
    crossRate{day} = struct();
    survRate{day} = struct();
    [unit1, unit2] = find(survival{day-1});
    for i=1:length(unit1)
        name1 = printName(unit1(i));
        name2 = printName(unit2(i));
        if(isfield(rate{day-1},name1) && isfield(rate{day},name2))
            crossRate{day}.(name2) = rate{day-1}.(name1);
            survRate{day}.(name2) = rate{day}.(name2);
        end
    end
end
for day=1
    % Construct a matrix of tomorrows's coefficients using the surviving
    % units
    crossRate{day} = struct();
    survRate{day} = struct();
    [unit1, unit2] = find(survival{day});
    for i=1:length(unit1)
        name1 = printName(unit1(i));
        name2 = printName(unit2(i));
        if(isfield(rate{day},name1) && isfield(rate{day+1},name2))
            crossRate{day}.(name1) = rate{day+1}.(name2);
            survRate{day}.(name1) = rate{day}.(name1);
        end
    end
end
crossCoeff = dayByDayFactors(crossRate);
survCoeff = dayByDayFactors(survRate);

function name = printName(unit)
if(LONG_NAMES)
    name = sprintf('Unit%0.3d_%d',ceil(unit/4),mod(unit-1,4)+1);
else
    name = sprintf('Unit%0.2d_%d',ceil(unit/4),mod(unit-1,4)+1);
end
end
end