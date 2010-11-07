function scatterCoeff(canCoeff, lags)
X = cell(length(canCoeff),8);
for day=1:length(canCoeff)
    for f=1:8
        X{day,f} = structfun(@(x) x(f), canCoeff{day});
    end
end
X = cell2mat(X);

L = cell(length(canCoeff),1);
for day=1:length(canCoeff)
    L{day} = structfun(@bestLag, lags{day});
end
L = cell2mat(L);

pairs(@plot,[X(:,[1 6]) L],'.','MarkerSize',1);
end

function b = bestLag(x)
b = find(x==max(x));
if(length(b)~=1)
    b = nan;
end
end