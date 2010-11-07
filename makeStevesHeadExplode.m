% Make some targets
th = (-pi+pi/8:pi/8:pi)';
[x, y] = pol2cart(th,1);

% Make some re-aimed targets
rx = x + randn(size(x))*mean(abs(x))/10;
ry = y + randn(size(y))*mean(abs(y))/10;
rth = cart2pol(rx,ry);

clf; hold on;
plot(0,0,'k+');
plot(x,y,'go');
plot(rx,ry,'kx');
axis image;

% Generate some preferred directions and firing rates
V_true = [rx ry];
P_true = randn(2,100);
R = V_true*P_true;
R = R + randn(size(R))*mean(abs(R(:)))/10;

% Estimate preferred directions using the re-aiming algorithm
V = [x y];
oldSSE = nan;
newSSE = nan;
iterations = 0;
while(iterations<100 && (~isfinite(newSSE/oldSSE) || newSSE/oldSSE<.9999))
    % Estimate the preferred directions
    P = V \ R;
    % Estimate the target directions
    V = R / P;
    % Constrain V to unit vectors
    V = bsxfun(@rdivide,V,sqrt(sum(V.^2,2)));

    residuals = R - V*P;
    oldSSE = newSSE;
    newSSE = sum(residuals(:).^2);
    iterations = iterations+1;
    fprintf('SSE = %f\n',newSSE);
end
fprintf('Converged in %d iterations\n',iterations);

% Compare to first two dimensions of PCA
pca = princomp(R);
pca = pca(:,1:2)';

fprintf('************ Subspace angle for re-aiming: \t');
disp(subspace(pca',P'));
fprintf('\n');
plot(V(:,1),V(:,2),'ks');

% Estimate preferred directions using the re-aiming algorithm with moddepth
V = [x y];
oldSSE = nan;
newSSE = nan;
iterations = 0;
while(iterations<100 && (~isfinite(newSSE/oldSSE) || newSSE/oldSSE<.9999))
    % Estimate the preferred directions
    P = V \ R;
    % Estimate the target directions
    V = R / P;

    residuals = R - V*P;
    oldSSE = newSSE;
    newSSE = sum(residuals(:).^2);
    iterations = iterations+1;
    fprintf('SSE = %f\n',newSSE);
end
fprintf('Converged in %d iterations\n',iterations);

fprintf('************ Subspace angle for re-aiming with moddepth: \t');
disp(subspace(pca',P'));
fprintf('\n');

% Now, let's see what happens if we add a covariate with a consistent
% relationship to target but no tuning
even = (mod(1:16,2)==0)';
R = bsxfun(@plus,R,even);

% Estimate preferred directions using the re-aiming algorithm
V = [x y];
oldSSE = nan;
newSSE = nan;
iterations = 0;
while(iterations<100 && (~isfinite(newSSE/oldSSE) || newSSE/oldSSE<.9999))
    % Estimate the preferred directions
    P = V \ R;
    % Estimate the target directions
    V = R / P;
    % Constrain V to unit vectors
    V = bsxfun(@rdivide,V,sqrt(sum(V.^2,2)));

    residuals = R - V*P;
    oldSSE = newSSE;
    newSSE = sum(residuals(:).^2);
    iterations = iterations+1;
    fprintf('SSE = %f\n',newSSE);
end
fprintf('Converged in %d iterations\n',iterations);

% Compare to first two dimensions of PCA
pca = princomp(R);
pca = pca(:,1:2)';

fprintf('************ Subspace angle for evil re-aiming: \t');
disp(subspace(pca',P'));
fprintf('\n');
plot(V(:,1),V(:,2),'rs');

% Now, let's apply the reaiming algorithm to some silly examples
% We're going to define some firing rates that have absolutely nothing to
% do with velocity coding (but apparently are directionally modulated)
rx = randn(size(x));
ry = randn(size(y));

% Generate some preferred directions and firing rates
V_true = [rx ry];
P_true = randn(2,100);
R = V_true*P_true;
R = R + randn(size(R))*mean(abs(R(:)))/10;

% Estimate preferred directions using the re-aiming algorithm
V = [x y];
oldSSE = nan;
newSSE = nan;
iterations = 0;
while(iterations<100 && (~isfinite(newSSE/oldSSE) || newSSE/oldSSE<.9999))
    % Estimate the preferred directions
    P = V \ R;
    % Estimate the target directions
    V = R / P;
    % Constrain V to unit vectors
    V = bsxfun(@rdivide,V,sqrt(sum(V.^2,2)));

    residuals = R - V*P;
    oldSSE = newSSE;
    newSSE = sum(residuals(:).^2);
    iterations = iterations+1;
    fprintf('SSE = %f\n',newSSE);
end
fprintf('Converged in %d iterations\n',iterations);

% Compare to first two dimensions of PCA
pca = princomp(R);
pca = pca(:,1:2)';

fprintf('************ Subspace angle for silly re-aiming: \t');
disp(subspace(pca',P'));
fprintf('\n');