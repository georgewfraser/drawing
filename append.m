function X = append(X,Y)
% Efficiently build an array incrementally
%
% X_ = append(X,Y)
%   X ~ an array of dimension m X n with
%     X(end) indicates the number of rows with data
%     X(end) < m
%   Y ~ an array of new data (p X n) to add into the unfilled part of X
%
% If X(end)+p >= m, we double the capacity of the array before adding Y
%
% see also: append_trim
    while(X(end)+size(Y,1)>size(X,1)-1)
        X = [X; X];
    end
    
    if(size(Y,1)>0)
        X(X(end)+(1:size(Y,1)),:) = Y;
        X(end) = X(end) + size(Y,1);
    end
end