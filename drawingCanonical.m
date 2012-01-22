function [canA, canB, canR, canLag, fold] = drawingCanonical(drawingSnips, drawingKin, drawing)
warning('off','stats:canoncorr:NotFullRank');
nTrials = cellfun(@(x) size(x.time,1), drawingSnips);
fold = arrayfun(@fiveFoldCrossValidation, nTrials, 'UniformOutput', false);

basis = drawingBasis(drawingSnips, drawingKin);
canLag = cell(length(basis),5);
canA = cell(length(basis),5);
canB = cell(length(basis),5);
canR = cell(length(basis),5);
lagValues = -.25:.050:.25;

for k=1:5
    drawingRate = snipSmoothedRate(drawingSnips, drawing, .4, 0);
    fprintf('Fold %d\n',k);
    fprintf('Fitting canonical variables')
    for day=1:length(basis)
        fprintf('.');
        [X,Y] = trainingData(drawingSnips, drawingRate, basis, day, fold, k);
        [A,B,r] = canoncorr(X,Y);

        % Flip correlates so they contain generally positive coefficients
        T = diag(sign(var(Y)*B));
        A = A*T;
        B = B*T;
        r = T'*diag(r)*T;

        canA{day,k} = A;
        canB{day,k} = B;
        canR{day,k} = r;
    end
    fprintf('\n');

    % Rearrange the correlates so that they correspond to the same elements
    % each day
    % Even if you don't do this you still get the right result, it just has
    % some inversions in it
    quality = cellfun(@(X) mean(X(:)), canR);
    best = quality==max(quality(:));
    for day=1:length(basis)
        [A,T] = rotatefactors(canA{day,k},'Method','procrustes','Target',canA{best},'Type','orthogonal');
        % We just want to do reordering and changes of sign
        for col=1:size(T,2)
            mask = abs(T(:,col))<max(abs(T(:,col)));
            T(mask,col) = 0;
        end
        T = sign(T);
        canA{day,k} = canA{day,k}*T;
        canB{day,k} = canB{day,k}*T;
        canR{day,k} = T'*canR{day,k}*T;
    end
    
%     fprintf('Testing %d lags',length(lagValues));
%     canLag{day,k} = nan(length(lagValues),5);
%     for lag=1:length(lagValues)
%         fprintf('.');
%         drawingRate = snipSmoothedRate(drawingSnips, drawing, .4, lagValues(lag));
%         for day=1:length(basis)
%             [X,Y] = trainingData(drawingSnips, drawingRate, basis, day, fold, k);
%             [Xtest,Ytest] = testingData(drawingSnips, drawingRate, basis, day, fold, k);
%             A = canA{day,k};
%             U = X*A;
%             
%             
%             [Alittle,B,r] = canoncorr(U(:,1:2),Y);
%             r = abs(corr(Xtest*A(:,1:2)*Alittle(:,1),Ytest*B(:,1)));
%             canLag{day,k}(lag,1) = r;
%             
%             [Alittle,B,r] = canoncorr(U(:,4:5),Y);
%             r = abs(corr(Xtest*A(:,1:2)*Alittle(:,1),Ytest*B(:,1)));
%             canLag{day,k}(lag,2) = r;
% %             
% %             for iiU=1:5
% %                 [Abad,B,r] = canoncorr(U(:,iiU),Y);
% %                 r = abs(corr(Xtest*A(:,iiU),Ytest*B));
% %                 canLag{day,k}(lag,iiU) = r;
% %             end
%         end
%     end
%     fprintf('\n');
end
warning('on','stats:canoncorr:NotFullRank');
end

% Screw you, mathworks, for putting crossvalind in a toolbox
function idx = fiveFoldCrossValidation(n)
    idx = randperm(n)';
    idx = ceil(idx*5/n);
end

function [X,Y] = trainingData(drawingSnips, drawingRate, basis, day, fold, k)
    sel = drawingSnips{day}.is_ellipse | ~drawingSnips{day}.is_illusion;
    sel = sel & fold{day}~=k;
    bday = structfun(@(x) x(sel,:), basis{day}, 'UniformOutput', false);
    dday = structfun(@(x) x(sel,:), drawingRate{day}, 'UniformOutput', false);
    X = unravel(bday);
    Y = unravel(dday);
end

function [X,Y] = testingData(drawingSnips, drawingRate, basis, day, fold, k)
    sel = drawingSnips{day}.is_ellipse | ~drawingSnips{day}.is_illusion;
    sel = sel & fold{day}==k;
    bday = structfun(@(x) x(sel,:), basis{day}, 'UniformOutput', false);
    dday = structfun(@(x) x(sel,:), drawingRate{day}, 'UniformOutput', false);
    X = unravel(bday);
    Y = unravel(dday);
end
