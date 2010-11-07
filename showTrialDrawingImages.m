function showTrialDrawingImages(rate)
fields = fieldnames(rate);
% plotDim = ceil(sqrt(length(fields)));
for iif=1:min(8*15,length(fields))
    subplot(8,15,iif);
    img = rate.(fields{iif});
    [coeff, score] = princomp(img');
    [s,idx] = sort(coeff(:,1));
    img = img(idx,:);
    imagesc(img);
    axis off;
    box off;
    axis image;
end