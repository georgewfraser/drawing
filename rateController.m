function controller = rateController(controlPd, rate, kin)
controller = cell(size(rate));
for day=1:length(rate)
    controller{day} = struct();
    fields = fieldnames(controlPd{day});
    X = kin{day}.velX(:,6:15);
    Y = kin{day}.velY(:,6:15);
    for iif=1:length(fields)
        F = rate{day}.(fields{iif})(:,6:15);
        pdVel = [X(:) Y(:)]*controlPd{day}.(fields{iif})(1:2)';
%         ret = cca_granger_regress([F(:) pdVel]',1,1);
%         controller{day}.(fields{iif}) = ret.prb(2,1);
%         controller{day}.(fields{iif}) = ret.gc(2,1);
        controller{day}.(fields{iif}) = corr(F(:),pdVel);%abs(corr(X(:),F(:)))+abs(corr(Y(:),F(:)));
    end
end
