function [canA, canB, canR, canCoeff] = drawingCanonicalCorrelogram(drawingSnips, drawingRate, drawing)
lagValues = -.25:.010:.25;

canA = cell(length(drawing),length(lagValues));
canB = cell(length(drawing),length(lagValues));
canR = cell(length(drawing),length(lagValues));
canCoeff = cell(length(drawing),length(lagValues));

for lag=1:length(lagValues)
    basis = drawingBasisLag(drawingSnips, drawing, lagValues(lag));
    for day=1:length(drawingSnips)
        fprintf('.');
        mask = true(size(drawingSnips{day}.time));
        mask(~drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion,:) = false;
        
        bday = structfun(@(x) x(mask), basis{day}, 'UniformOutput', false);
        dday = structfun(@(x) x(mask), drawingRate{day}, 'UniformOutput', false);
        X = cell2mat(struct2cell(bday)');
        Y = cell2mat(struct2cell(dday)');
        [A,B,r] = canoncorr(X,Y);

        % Flip correlates so they contain generally positive coefficients
        T = diag(sign(var(Y)*B));
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
    quality = cellfun(@(X) mean(X(:)), canR);
    best = quality==max(quality(:));
    for day=1:length(basis)
        [A,T] = rotatefactors(canA{day,lag},'Method','procrustes','Target',canA{best},'Type','orthogonal');
        % We just want to do reordering and changes of sign
        for col=1:size(T,2)
            mask = abs(T(:,col))<max(abs(T(:,col)));
            T(mask,col) = 0;
            T(~mask,(col+1):end) = 0;
        end
        T = sign(T);
        canA{day,lag} = canA{day,lag}*T;
        canB{day,lag} = canB{day,lag}*T;
        canR{day,lag} = T'*canR{day,lag}*T;
    end

%     % Rotate the latent variables to match the mean
%     meanCanA = canA{best};%mean(cell2mat(shiftdim(canA,-2)),3);
%     for day=1:length(basis)
%         [A,T] = rotatefactors(canA{day,lag},'Method','procrustes','Target',meanCanA,'Type','orthogonal');
%         canA{day,lag} = canA{day,lag}*T;
%         canB{day,lag} = canB{day,lag}*T;
%         canR{day,lag} = T'*canR{day,lag}*T;
%     end
    
    % Recompute latent variables with new coefficients
    for day=1:length(basis)
        B = pinv(canB{day,lag});
        canCoeff{day,lag} = struct();
        fields = fieldnames(drawingRate{day});
        for unit=1:size(B,2)
            canCoeff{day,lag}.(fields{unit}) = B(:,unit)';
        end
    end
end

