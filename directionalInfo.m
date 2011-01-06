function [infoEnd, infoDir, coinfo] = directionalInfo(snips, factors)
infoEnd = nan(20,1);
infoDir = nan(20,1);
coinfo = nan(20,1);

for t=1:20
    HA = 0;
    HA_D = 0;
    HA_E = 0;
    HA_DE = 0;
    for day=1:length(factors)
        fnames = fieldnames(factors{day});
        A = nan(size(factors{day}.(fnames{1}),1),length(fnames));
        for unit=1:length(fnames)
            A(:,unit) = factors{day}.(fnames{unit})(:,t);
        end
        HA = HA + entropy(A,ones(size(A,1),1));
        HA_D = HA_D + entropy(A,snips{day}.targetPos-snips{day}.startPos);
        HA_E = HA_E + entropy(A,snips{day}.targetPos);
        HA_DE = HA_DE + entropy(A,[snips{day}.startPos snips{day}.targetPos]);
    end
    HA = HA/length(factors);
    HA_D = HA_D/length(factors);
    HA_E = HA_E/length(factors);
    HA_DE = HA_DE/length(factors);
    
    % I(A;E|D)
    infoEnd(t) = HA_D-HA_DE;
    % I(A;D|E)
    infoDir(t) = HA_E-HA_DE;
    % I(A;E;D) = I(A;E|D)-I(A;E)
    coinfo(t) = infoEnd(t)-(HA-HA_E);%HA+HA_both-HA_targ-HA_start;
end
end

function H = entropy(A,X)
uniqueX = unique(X,'rows');
[tf, loc] = ismember(X,uniqueX,'rows');
H = 0;
for i=1:size(uniqueX,1)
    H = H + 0.5*log2((2*pi*exp(1))^size(A,2)*prod(var(A(i==loc,:))))*mean(i==loc);
    if(~isreal(H))
        keyboard;
    end
end
H = H / size(A,1);
end