function [ant, post] = highFiringRateCells(coutRateMean)

caret = 0;
meanRate = cell2mat(cellfun(@(day) structfun(@(X) mean(X(:)), day), coutRateMean, 'UniformOutput', false));
ant = struct();
post = struct();

for day=1:length(coutRateMean)
    cnames = fieldnames(coutRateMean{day});
    for unit=1:length(cnames)
%         if(mean(coutRateMean{day}.(cnames{unit})(:))>quantile(meanRate,.75))
            caret = caret+1;
            channel = str2num(cnames{unit}(5:7));
            if(channel<100)
                ant.(sprintf('Unit%d',caret)) = coutRateMean{day}.(cnames{unit});
            else
                post.(sprintf('Unit%d',caret)) = coutRateMean{day}.(cnames{unit});
            end
%         end
    end
end