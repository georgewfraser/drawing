controlCoeff = dayByDayFactors(controlRate);
[pos, vel, acc, hld, hldA, hldB] = covariateRepresentation(controlCoeff, controlRateMean, controlKinMean);

figure(1); clf;
plot([mean(pos); mean(vel); mean(acc); mean(hld)]','LineWidth',2);
legend('Position', 'Velocity', 'Acceleration', 'Hold');
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('Covariate R^2')
ylim([0 1]);
box off;

% rot = covariateRotation(controlCoeff{15}, controlRateMean, controlKinMean);
% factors = projectDown({rot},controlRateMean);

factors = projectDown(controlCoeff(10),controlRateMean);

IS_3D = sum(abs(controlSnips{1}.targetPos(:,3)))>0;

utargets = target26(1);
figure(2); clf;
if(IS_3D)
    for day=1:10
        for f=1:length(fieldnames(factors{1}{day}))
            name = sprintf('factor%0.2d',f);
            subplot(10,10,(day-1)*10+f);
            img = factors{1}{day}.(name);
            profile = mean(img(:,1:20),2);
            profile = profile-mean(profile);
            prefdir = regress(profile,utargets);
            close = utargets*prefdir;
            [s, idx] = sort(close,'descend');
            imgnan = nan(size(img,1),size(img,2)+1);
            imgnan(:,[1:20 22:end]) = img(idx,:);
            imagesc(imgnan);
            box off;
            axis off;
            axis image;
        end
    end
else
    for day=1:10
        for f=1:length(fieldnames(factors{1}{day}))
            name = sprintf('factor%0.2d',f);
            img = factors{1}{day}.(name);
            subplot(10,10,(day-1)*10+f);

            imagesc(img);
            box off;
            axis off;
            axis image;
        end
    end
end