function [ant, post] = popVec(coutKinMean, coutRateMean, drawingKinMean, drawingRateMean)
md = moddepth(drawingRateMean);

kinX = cellfun(@(day) struct('velX', day.velX(:,14)), coutKinMean, 'UniformOutput', false);
kinX = unravelAll(kinX);
kinX = mean(kinX,2);
kinY = cellfun(@(day) struct('velY', day.velY(:,14)), coutKinMean, 'UniformOutput', false);
kinY = unravelAll(kinY);
kinY = mean(kinY,2);
kin = [kinX kinY];
kin = bsxfun(@rdivide, kin, sqrt(sum(kin.^2,2)));
rate = cellfun(@(day) structfun(@(X) X(:,14), day, 'UniformOutput', false), coutRateMean, 'UniformOutput', false);
rate = unravelAll(rate);
rate = bsxfun(@minus, rate, mean(rate));

channel = cellfun(@fieldnames, drawingRateMean, 'UniformOutput', false);
channel = cellfun(@(day) cellfun(@(x) str2double(x(5:7)), day), channel, 'UniformOutput', false);
channel = cell2mat(channel);

antModel = rate(:,channel<100&md>quantile(md,.5))\kin;
postModel = rate(:,channel>100&md>quantile(md,.5))\kin;

rate = unravelAll(drawingRateMean);
rate = bsxfun(@minus, rate, mean(rate));

% Predict illusion (and others)
ant = rate(:,channel<100&md>quantile(md,.5))*antModel;
post = rate(:,channel>100&md>quantile(md,.5))*postModel;

% speed = cellfun(@(day) repmat(day.speed(:,21:40),1,7), drawingKinMean, 'UniformOutput', false);
speed = cellfun(@(day) day.speed, drawingKinMean, 'UniformOutput', false);
speed = reshape(speed,[1 1 numel(speed)]);
speed = mean(cell2mat(speed),3);
speed = speed(:);

ant = bsxfun(@rdivide,ant,sqrt(sum(ant.^2,2)));
post = bsxfun(@rdivide,post,sqrt(sum(post.^2,2)));
ant = cart2pol(ant(:,1),ant(:,2));
post = cart2pol(post(:,1),post(:,2));

ant = reshape(ant,4,140);
post = reshape(post,4,140);

% yrange = [min(min(ant(:)),min(post(:))) max(max(ant(:)),max(post(:)))];
yrange = [-pi pi];

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