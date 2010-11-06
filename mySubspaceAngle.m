function angles = mySubspaceAngle(space1, space2)
space2 = rotatefactors(space2,'Method','procrustes','Target',space1,'Type','orthogonal');
angles = nan(1,size(space1,2));
for f=1:size(space1,2)
    angles(f) = cos(subspace(space1(:,1:f),space2(:,1:f)));
%     angles(f) = (space1(:,f)./norm(space1(:,f)))'*(space2(:,f)./norm(space2(:,f)));
end
end
