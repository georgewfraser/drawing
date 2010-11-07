function group = myCluster(X)
% Tries to peel off one or a few clusters which are compact and far from
% zero

% Do standard hierarchical clustering
Y = pdist(X);
Z = linkage(Y,'ward');
group = cluster(Z,'MaxClust',2:size(X,1));
% Rate the clusters
for n=1:size(group,2)
    dist(n) = min(rateDistanceFromZero(X,group(:,n)));
end
plot(dist);
keyboard;

end

function dist = rateDistanceFromZero(X,group)
dist = nan(1,max(group));
% Compute the distance from zero naively
for i=1:max(group)
    dist(i) = norm(mean(X(group==i,:)));
end
% Identify the null group
null = find(dist==min(dist));
% Now, compute the separation between each cluster and the null cluster
for i=find(1:max(group)~=null)
    % Compute the vector between group means
    proj = mean(X(group==i,:))-mean(X(group==null,:));
    proj = proj' ./ norm(proj);
    % Project the current group and the null group onto that axis
    groupDist = X(group==i,:)*proj;
    nullDist = X(group==null,:)*proj;
    pairWise = bsxfun(@minus,groupDist,nullDist');
    pairWise = pairWise(:).*sign(mean(pairWise(:)));
    dist(i) = mean(pairWise)/std(pairWise);
%     edges = [min(min(nullDist),min(groupDist)) max(max(nullDist),max(groupDist))];
%     edges = edges(1):diff(edges)/100:edges(2);
%     subplot(3,1,1);
%     hist(nullDist, edges);
%     subplot(3,1,2);
%     hist(groupDist, edges);
%     subplot(3,1,3);
%     hist(pairWise(:), edges);
%     keyboard;
end
dist(null) = nan;
end