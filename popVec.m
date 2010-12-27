function [ant, post] = popVec(drawingKinMean, drawingRateMean)
kin = cellfun(@(day) struct('velX', day.velX), drawingKinMean, 'UniformOutput', false);

kin = unravelAll(kin);
kin = mean(kin,2);
rate = unravelAll(drawingRateMean);
rate = bsxfun(@minus, rate, mean(rate));

channel = cellfun(@fieldnames, drawingRateMean, 'UniformOutput', false);
channel = cellfun(@(day) cellfun(@(x) str2double(x(5:7)), day), channel, 'UniformOutput', false);
channel = cell2mat(channel);

% Train with circle, ellipse
antModel = rate([1:4:end 3:4:end],channel<100)\kin([1:4:end 3:4:end]);
postModel = rate([1:4:end 3:4:end],channel>100)\kin([1:4:end 3:4:end]);
% Predict illusion (and others)
ant = rate(:,channel<100)*antModel;
ant = reshape(ant,4,140);
post = rate(:,channel>100)*postModel;
post = reshape(post,4,140);

yrange = [min(min(ant(:)),min(post(:))) max(max(ant(:)),max(post(:)))];

clf
subplot(3,1,1), hold on
plot(ant(1,:));
plot(post(1,:),':');
ylim(yrange);
subplot(3,1,2), hold on
plot(ant(3,:));
plot(post(3,:),':');
ylim(yrange);
subplot(3,1,3), hold on
plot(ant(4,:));
plot(post(4,:),':');
ylim(yrange);

% reconByDay = cell(1,numel(drawingKin));
% for day=1:length(drawingSnips)
%     kin = drawingKin{day}.velX;
%     kin = kin(:);
%     rate = unravel(drawingRate{day});
%     trial = repmat((1:size(drawingKin{day}.velX,1))',1,size(drawingKin{day}.velX,2));
%     trial = trial(:);
%     
%     
%     recon = nan(size(kin));
%     fold = crossvalind('KFold',max(trial),5);
%     for k=1:5
%         sel = fold(trial)==k;
%         model = rate(~sel,:)\kin(~sel);
%         recon(sel) = rate(sel,:)*model;
%     end
%     reconByDay{day} = struct('velX',reshape(recon,size(drawingKin{day}.velX)));
% end
% reconByDay = meanByDrawing(drawingSnips, reconByDay);
% recon = unravelAll(reconByDay);
% recon = mean(recon,2);
% recon = reshape(recon,4,140);
% 
% showAllDrawingPlots(struct('a',recon));
% keyboard;
    
% channel = cellfun(@fieldnames, coutRateMean, 'UniformOutput', false);
% channel = cellfun(@(day) cellfun(@(x) str2double(x(5:7)), day), channel, 'UniformOutput', false);
% channel = cell2mat(channel);
% 
% % rate = cellfun(@(day) structfun(@(x) mean(x,2), day, 'UniformOutput', false), coutRateMean, 'UniformOutput', false);
% % rate = unravelAll(rate);
% % rate = bsxfun(@minus,rate,nanmean(rate));
% % 
% % kin = cellfun(@(day) structfun(@(x) mean(x,2), day, 'UniformOutput', false), coutKinMean, 'UniformOutput', false);
% % kin = cellfun(@unravel, kin, 'UniformOutput', false);
% % kin = reshape(kin,[1 1 numel(kin)]);
% % kin = nanmean(cell2mat(kin),3);
% % kin = kin(:,4:6); % velocity
% % kin = bsxfun(@minus,kin,nanmean(kin));
% % 
% % % Substitute missing data
% % for col=find(sum(isnan(rate))>0)
% %     bad = isnan(rate(:,col));
% %     model = kin(~bad,:)\rate(~bad,col);
% %     rate(bad,col) = kin(bad,:)*model;
% % end
% % 
% % antModel = rate(:,channel<100)\kin;    
% % postModel = rate(:,channel>100)\kin;              
% 
% rate = unravelAll(drawingRateMean);
% kin = cellfun(@unravel, drawingKinMean, 'UniformOutput', false);
% kin = reshape(kin,[1 1 numel(kin)]);
% kin = nanmean(cell2mat(kin),3);
% kin = kin(:,4:6);
% antModel = rate(:,channel<100)\kin;
% postModel = rate(:,channel>100)\kin;
% 
% % pred = rate(:,channel<100)*antModel;
% % plot(pred);
% % 
% % keyboard;
% 
% % rate = unravelAll(drawingRateMean);
% % rate = detrend(rate);
% ant = rate(:,channel<100)*antModel;
% ant = reshape(ant(:,1),4,140);
% post = rate(:,channel>100)*postModel;
% post = reshape(post(:,1),4,140);
% yrange = [min(min(ant(:)),min(post(:))) max(max(ant(:)),max(post(:)))];
% 
% clf
% subplot(3,1,1), hold on
% plot(ant(1,:));
% plot(post(1,:),':');
% ylim(yrange);
% subplot(3,1,2), hold on
% plot(ant(3,:));
% plot(post(3,:),':');
% ylim(yrange);
% subplot(3,1,3), hold on
% plot(ant(4,:));
% plot(post(4,:),':');
% ylim(yrange);
% 
% keyboard;
% end
% 
% function rate = detrend(rate)
% rate = bsxfun(@minus,rate,mean(rate));
% trend = repmat(1:140,4,1);
% trend = trend(:);
% trend = trend-mean(trend);
% rate = rate-trend*(trend\rate);
% end