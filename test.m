clf
for i=1:20
    subplot(5,5,i); hold on
    [n,x] = hist(coutFactors{1,1}.factor01(:,i),20); 
    plot(x,n/mean(n),'k:');
    targ = coutSnips{1}.targetPos-coutSnips{1}.startPos;
    [tf,loc] = ismember(targ,targ(1,:),'rows');
    [n,x] = hist(coutFactors{1,15}.factor01(tf,i),20);
    plot(x,n/mean(n));
    xlim([-3 3]);
end
