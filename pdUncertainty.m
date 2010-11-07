function uncertainty = pdUncertainty(coutSnips, coutRate)
uncertainty = cell(size(coutSnips));
for day=1:length(coutSnips)
    uncertainty{day} = struct();
    % Target direction in the center-out task
    T = coutSnips{day}.targetPos-coutSnips{day}.startPos;
    T = bsxfun(@rdivide,T,sqrt(sum(T.^2,2)));
    
    fields = fieldnames(coutRate{day});
    for unit=1:length(fields)
        % Extract per-target firing rates
        R = coutRate{day}.(fields{unit});
        R = mean(R(:,9:12),2);
        % Compute preferred directions
        % T*P = R
        [b,dev,stats] = glmfit(T,R,'normal');
        sample = mvnrnd(b,stats.covb,100);
        
        % Just take the x y z
        sample = sample(:,2:end);
        % Mean of the cloud (column vector)
        meanSample = b(2:end);
        % Normalize length to 1
        sample = bsxfun(@rdivide,sample,sqrt(sum(sample.^2,2)));
        meanSample = meanSample/norm(meanSample);
        % Compute angles between mean and samples
        angles = acos(sample*meanSample);
        
        uncertainty{day}.(fields{unit}) = mean(angles);
    end
end