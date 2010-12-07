function [canA, canB, canR, canCoeff] = drawingTemporalCanonical(drawingSnips, drawingRate, drawing)
lagValues = -.25:.010:.25;

canA = cell(size(drawing));
canB = cell(size(drawing));
canR = cell(size(drawing));
canCoeff = cell(size(drawing));

for day=1:length(drawingSnips)
    nTrials = size(drawingSnips{day}.time,1);
    mask = [false(nTrials,20) true(nTrials,20*5) false(nTrials,20)];
    mask(~drawingSnips{day}.is_ellipse & drawingSnips{day}.is_illusion,:) = false;
    nTimes = sum(mask(:));
    nBasis = 21;
    
    dday = structfun(@(x) x(mask), drawingRate{day}, 'UniformOutput', false);
    Y = cell2mat(struct2cell(dday)');
    
    X = nan(nTimes,nBasis*length(lagValues));
    for lag=1:length(lagValues)
        basis = drawingBasisLag(drawingSnips(day), drawing(day), lagValues(lag));
        basis = basis{1};
        bday = structfun(@(x) x(mask), basis, 'UniformOutput', false);
        Xpart = cell2mat(struct2cell(bday)');
        X(:,(lag-1)*nBasis + (1:nBasis)) = Xpart;
    end
    
    nanmask = sum(isnan(X),2)+sum(isnan(Y),2)==0;
    X = X(nanmask,:);
    Y = Y(nanmask,:);
    [A,B,r] = canoncorr(X,Y);
    
    A = A(:,1:15);
    B = B(:,1:15);
    r = r(1:15);
        
    % Flip correlates so they contain generally positive coefficients
    T = diag(sign(var(Y)*B));
    A = A*T;
    B = B*T;
    r = T'*diag(r)*T;

    canA{day} = A;
    canB{day} = B;
    canR{day} = r;
end


% Rearrange the correlates so that they correspond to the same elements
% each day
quality = cellfun(@(X) mean(X(:)), canR);
best = quality==max(quality(:));
for day=1:length(drawingSnips)
    [A,T] = rotatefactors(canA{day},'Method','procrustes','Target',canA{best},'Type','orthogonal');
    % We just want to do reordering and changes of sign
    for col=1:size(T,2)
        mask = abs(T(:,col))<max(abs(T(:,col)));
        T(mask,col) = 0;
        T(~mask,(col+1):end) = 0;
    end
    T = sign(T);
    canA{day} = canA{day}*T;
    canB{day} = canB{day}*T;
    canR{day} = T'*canR{day}*T;
end


% Recompute latent variables with new coefficients
for day=1:length(drawingSnips)
    B = pinv(canB{day});
    canCoeff{day} = struct();
    fields = fieldnames(drawingRate{day});
    for unit=1:size(B,2)
        canCoeff{day}.(fields{unit}) = B(:,unit)';
    end
end