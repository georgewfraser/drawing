function L = topContributors(canB, lags, var)
B = cell2mat(cellfun(@(X) X(:,var),canB,'UniformOutput', false));
B = mean(B,2);
B = sort(abs(B),'descend');
threshold = B(25);
L = nan(size(B));
for day=1:length(canB)
    Bday = cell2mat(cellfun(@(X) X(:,var),canB(day,:),'UniformOutput', false));
    Bday = mean(Bday,2);
    cnames = fieldnames(lags{day});
    for unit=1:length(Bday)
        Lday = cell2mat(cellfun(@(x) x.(cnames{unit})', lags(day,:),'UniformOutput',false));
        Lday = mean(Lday,2);
        Lday = find(Lday==max(Lday));
        if(isempty(Lday))
            Lday = nan;
        end
        L(find(Bday(unit)==B)) = Lday;
    end
end
end
        
%     for unit=find(abs(B)>threshold)
%         Lday = cell2mat(cellfun(@(x) x.(cnames{unit})', lags{day},'UniformOutput',false));
%         Lday = mean(Lday,2);
%         keyboard; % should be a single lag vector
%         Lday = find(Lday==max(Lday));
%         if(isempty(Lday))
%             Lday = nan;
%         end
%         L(find(
%         L(end+1) = Lday;
%     end
% end
% end
%     
