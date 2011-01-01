function [S, T, B] = directionalInfo(snips, factors)
S = nan(20,size(factors,2));
T = nan(20,size(factors,2));
B = nan(20,size(factors,2));

for nFactors=1:size(factors,2)
    [start, targ, both] = subtractMeanByTarget3D(snips, factors(:,nFactors));
    
    for t=1:20
        HA = sum(cellfun(@(x) dayEntropy(x,t), factors(:,nFactors)));
        HA_start = sum(cellfun(@(x) dayEntropy(x,t), start));
        HA_targ = sum(cellfun(@(x) dayEntropy(x,t), targ));
        HA_both = sum(cellfun(@(x) dayEntropy(x,t), both));
        
        % I(A;S|T)
        S(t,nFactors) = HA_targ-HA_both;
        % I(A;T|S)
        T(t,nFactors) = HA_start-HA_both;
        % I(A;S;T) = I(A;S|T)-I(A;S)
        B(t,nFactors) = S(t,nFactors)-(HA-HA_start);%HA+HA_both-HA_targ-HA_start;
    end
end
end

function entropy = dayEntropy(day,t)
fnames = fieldnames(day);
day = day.(fnames{end})(:,t);
% day = struct2cell(structfun(@(X) X(:,t), day, 'UniformOutput', false));
% day = cell2mat(reshape(day,1,numel(day)));
day = day(sum(isnan(day),2)==0,:);
entropy = 0.5*log((2*pi*exp(1))^size(day,2)*det(cov(day)));
end