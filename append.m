function X = append(X,Y)
    while(X(end)+size(Y,1)>size(X,1)-1)
        X = [X; X];
    end
    
    if(size(Y,1)>0)
        X(X(end)+(1:size(Y,1)),:) = Y;
        X(end) = X(end) + size(Y,1);
    end
end