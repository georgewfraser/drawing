function [recon, R2] = kinematicRecon(kin, rate)
recon = cell(size(rate));
ss = nan(size(rate));
ssr = nan(size(rate));
for day=1:length(rate)
    R = unravel(rate{day});
    K = unravel(kin{day});
    K = [ones(size(K,1),1) K(:,1:9)];
    trial = repmat((1:size(kin{day}.velX,1))',1,size(kin{day}.velX,2));
    trial = trial(:);
    
    R_ = nan(size(R));
    fold = crossvalind('KFold',max(trial),5);
    for k=1:5
        sel = fold(trial)==k;
        model = K(~sel,:)\R(~sel,:);
        R_(sel,:) = K(sel,:)*model;
    end
    
    recon{day} = reravel(R_,rate{day});
    
    R = bsxfun(@minus,R,mean(R));
    R_ = bsxfun(@minus,R_,mean(R_));
    ss(day) = sum(R(:).^2);
    ssr(day) = sum((R(:)-R_(:)).^2);
end
R2 = 1 - ssr./ss;