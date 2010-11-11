nPoints = size(drawingSnips{1}.time,2);
lagValues = -.5:.050:.5;


canBasis = cell(length(drawingSnips),length(lagValues));
canRate = cell(length(drawingSnips),length(lagValues));
canA = cell(length(drawingSnips),length(lagValues));
canB = cell(length(drawingSnips),length(lagValues));
canR = cell(length(drawingSnips),length(lagValues));

for lag=1:length(lagValues)
    basis = drawingBasis(drawingSnips, drawingLag(:,lag));
    basisMean = meanByDrawing(drawingSnips, basis);
    for day=1:length(drawingSnips)
        fprintf('.');
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

        % Flip correlates so they contain generally positive coefficients
        % Throw away all but top 15 canonical correlates
        T = diag(sign(var(Y)*B));
        T = T(:,1:15);
        A = A*T;
        B = B*T;
        r = T'*diag(r)*T;

        canA{day,lag} = A;
        canB{day,lag} = B;
        canR{day,lag} = r;
    end
    fprintf('\n');

    % Rearrange the correlates so that they correspond to the same elements
    % each day
    quality = cellfun(@(X) mean(X(:)), canR(:,lag));
    best = quality==max(quality);
    for day=1:length(basis)
        [A,T] = rotatefactors(canA{day,lag},'Method','procrustes','Target',canA{best,lag},'Type','orthogonal');
        % We just want to do reordering and changes of sign
        for col=1:size(T,2)
            mask = abs(T(:,col))<max(abs(T(:,col)));
            T(mask,col) = 0;
        end
        T = sign(T);
        canA{day,lag} = canA{day,lag}*T;
        canB{day,lag} = canB{day,lag}*T;
        canR{day,lag} = T'*canR{day,lag}*T;
    end

    % Rotate the latent variables to match the mean
    meanCanA = mean(cell2mat(shiftdim(canA(:,lag),-2)),3);
    for day=1:length(basis)
        [A,T] = rotatefactors(canA{day,lag},'Method','procrustes','Target',meanCanA,'Type','orthogonal');
        canA{day,lag} = canA{day,lag}*T;
        canB{day,lag} = canB{day,lag}*T;
        canR{day,lag} = T'*canR{day,lag}*T;
    end

    % Recompute latent variables with new coefficients
    canCoeff = cell(size(canB));
    for day=1:length(basis)
        X = unravel(basisMean{day});
        Y = unravel(drawingRateMean{day});
        U = bsxfun(@minus,X,mean(X))*canA{day,lag};
        V = bsxfun(@minus,Y,mean(Y))*canB{day,lag};
        canBasis{day,lag} = struct();
        canRate{day,lag} = struct();
        for c=1:size(U,2)
            name = sprintf('canonical%0.2d',c);
            canBasis{day,lag}.(name) = reshape(U(:,c),4,nPoints);
            canRate{day,lag}.(name) = reshape(V(:,c),4,nPoints);
        end
        B = pinv(canB{day,lag});
        canCoeff{day,lag} = struct();
        fields = fieldnames(drawingRate{day});
        for unit=1:size(B,2)
            canCoeff{day,lag}.(fields{unit}) = B(:,unit)';
        end
    end
end
        