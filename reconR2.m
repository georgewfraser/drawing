function R2 = reconR2(rate, recon)
ss = nan(size(rate));
ssr = nan(size(rate));
for day=1:length(rate)
    R = unravel(rate{day});
    R_ = unravel(recon{day});
    
    R = bsxfun(@minus,R,mean(R));
    R_ = bsxfun(@minus,R_,mean(R_));
    
    ss(day) = sum(R(:).^2);
    ssr(day) = sum((R(:)-R_(:)).^2);
end
R2 = 1 - ssr./ss;