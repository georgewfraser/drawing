function showAllTargetImages3D(rateMean)
slices = target26SliceIndex();
fields = fieldnames(rateMean);
for iif=1:min(length(fields),100)
    subplot(10,10,iif);
    R = rateMean.(fields{iif});
    img = nan(8*4+3,41);
    for iis=1:length(slices)
        % Center-out
        img((iis-1)*9+(1:8),1:20) = R(slices{iis},:);
        % Out-center
        img((iis-1)*9+(1:8),22:end) = R(26+slices{iis},:);
    end
    imagesc(img);
    axis off;
    box off;
    axis image;
end