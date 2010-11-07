function showDrawingWaterfall3D(R)
[coeff, score] = princomp(R');
[s,idx] = sort(coeff(:,1));
R = R(idx,:);
waterfall(R);
view(-5,85);
% 
% slices = target26SliceIndex();
% img = nan(8*4+3,41);
% for iis=1:length(slices)
%     % Center-out
%     img((iis-1)*9+(1:8),1:20) = R(slices{iis},:);
%     % Out-center
%     img((iis-1)*9+(1:8),22:end) = R(26+slices{iis},:);
% end
% waterfall([img(:,1:20); img(:,22:end)]);