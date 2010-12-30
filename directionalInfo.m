function [info, esep, etog] = directionalInfo(snips, factors)
info = nan(20,size(factors,2));

for nFactors=1:size(factors,2)
    factorSub = subtractMeanByTarget3D(snips, factors(:,nFactors));
    
    for day=1:size(factors,1)
        outward = sum(abs(snips{day}.startPos),2)==0;
        factorSub{day} = structfun(@(X) X(outward,:), factorSub{day}, 'UniformOutput', false);
        factors{day,nFactors} = structfun(@(X) X(outward,:), factors{day,nFactors}, 'UniformOutput', false);
    end
    
    for t=1:20
        entropySeparate = sum(cellfun(@(x) dayEntropy(x,t), factorSub));
        entropyTogether = sum(cellfun(@(x) dayEntropy(x,t), factors(:,nFactors)));
        
        info(t,nFactors) = entropyTogether-entropySeparate;
        esep(t,nFactors) = entropySeparate;
        etog(t,nFactors) = entropyTogether;
    end
end
end

function entropy = dayEntropy(day,t)
day = struct2cell(structfun(@(X) X(:,t), day, 'UniformOutput', false));
day = cell2mat(reshape(day,1,numel(day)));
day = day(sum(isnan(day),2)==0,:);
entropy = 0.5*log((2*pi*exp(1))^size(day,2)*det(cov(day)));
end