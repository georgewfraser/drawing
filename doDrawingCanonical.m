basis = drawingBasis(drawingSnips, drawingKin);
basisMean = meanByDrawing(drawingSnips, basis);

canBasis = cell(size(basisMean));
canRate = cell(size(basisMean));
canA = cell(size(basisMean));
canB = cell(size(basisMean));
canR = cell(size(basisMean));
for day=1:length(basis)
    sel = drawingSnips{day}.is_ellipse | ~drawingSnips{day}.is_illusion;
    bday = structfun(@(x) x(sel,:), basis{day}, 'UniformOutput', false);
    dday = structfun(@(x) x(sel,:), drawingRate{day}, 'UniformOutput', false);
    X = unravel(bday);
    Y = unravel(dday);
    mask = sum(isnan(X),2)+sum(isnan(Y),2)==0;
    [A,B,r] = canoncorr(X(mask,:),Y(mask,:));
    
%     % Do a varimax rotation
%     [A,T] = rotatefactors(A);
%     B = B*T;
%     r = T'*diag(r)*T;
    
%     % Rearrange in descending order of corr
%     [r_,idx] = sort(diag(r),'descend');
%     idx = sub2ind(size(r),(1:length(r))',idx);
%     T = zeros(size(r));
%     T(idx) = 1;
%     A = A*T;
%     B = B*T;
%     r = T'*r*T;
    
    canA{day} = A;
    canB{day} = B;
    canR{day} = diag(r);
end

% Flip correlates so they contain generally positive coefficients
for day=1:length(basis)
    T = diag(sign(mean(canB{day})));
    canA{day} = canA{day}*T;
    canB{day} = canB{day}*T;
    canR{day} = T'*canR{day}*T;
end

% Rearrange the correlates so that they correspond to the same elements
% each day
quality = cellfun(@(X) mean(X(:)), canR);
best = quality==max(quality);
for day=1:length(basis)
    [A,T] = rotatefactors(canA{day},'Method','procrustes','Target',canA{best},'Type','orthogonal');
    % We just want to do reordering and changes of sign
    for col=1:size(T,2)
        mask = abs(T(:,col))<max(abs(T(:,col)));
        T(mask,col) = 0;
    end
    T = sign(T);
    canA{day} = canA{day}*T;
    canB{day} = canB{day}*T;
    canR{day} = T'*canR{day}*T;
end

% Rotate the latent variables to match the mean
meanCanA = mean(cell2mat(shiftdim(canA,-2)),3);
for day=1:length(basis)
    [A,T] = rotatefactors(canA{day},'Method','procrustes','Target',meanCanA,'Type','orthogonal');
    canA{day} = canA{day}*T;
    canB{day} = canB{day}*T;
    canR{day} = T'*canR{day}*T;
end

% Recompute latent variables with new coefficients
canCoeff = cell(size(canB));
for day=1:length(basis)
    X = unravel(basisMean{day});
    Y = unravel(drawingRateMean{day});
    U = bsxfun(@minus,X,mean(X))*canA{day};
    V = bsxfun(@minus,Y,mean(Y))*canB{day};
    canBasis{day} = struct();
    canRate{day} = struct();
    for c=1:size(U,2)
        name = sprintf('canonical%0.2d',c);
        canBasis{day}.(name) = reshape(U(:,c),4,140);
        canRate{day}.(name) = reshape(V(:,c),4,140);
    end
    B = pinv(canB{day});
    canCoeff{day} = struct();
    fields = fieldnames(drawingRate{day});
    for unit=1:size(B,2)
        canCoeff{day}.(fields{unit}) = B(:,unit)';
    end
end
        