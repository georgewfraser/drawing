function [infoEnd, infoDir, coinfo] = directionalInfo(snips, factors)
infoEnd = nan(20,size(factors,2));
infoDir = nan(20,size(factors,2));
coinfo = nan(20,size(factors,2));

for nFactors=1:size(factors,2)
    [direction, endpoint, both] = subtractMeanByTarget3D(snips, factors(:,nFactors));
    
    for t=1:20
        HA = sum(cellfun(@(x) dayEntropy(x,t), factors(:,nFactors)));
        HA_D = sum(cellfun(@(x) dayEntropy(x,t), direction));
        HA_E = sum(cellfun(@(x) dayEntropy(x,t), endpoint));
        HA_DE = sum(cellfun(@(x) dayEntropy(x,t), both));
        
        % I(A;E|D)
        infoEnd(t,nFactors) = HA_D-HA_DE;
        % I(A;D|E)
        infoDir(t,nFactors) = HA_E-HA_DE;
        % I(A;E;D) = I(A;E|D)-I(A;E)
        coinfo(t,nFactors) = infoEnd(t,nFactors)-(HA-HA_E);%HA+HA_both-HA_targ-HA_start;
    end
end
end

function entropy = dayEntropy(day,t)
day = struct2cell(structfun(@(X) X(:,t), day, 'UniformOutput', false));
day = cell2mat(reshape(day,1,numel(day)));
day = day(sum(isnan(day),2)==0,:);
entropy = 0.5*log2((2*pi*exp(1))^size(day,2)*det(cov(day)));
end