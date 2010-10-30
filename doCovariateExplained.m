controlCoeff = dayByDayFactors(controlRate);
[pos, vel, acc, hld, hldA, hldB] = covariateRepresentation(controlCoeff, controlRateMean, controlKinMean);
factors = projectDown(controlCoeff, controlRateMean);

figure(1); clf;
plot([mean(pos); mean(vel); mean(acc); mean(hld)]','LineWidth',2);
legend('Position', 'Velocity', 'Acceleration', 'Hold');
set(gcf,'PaperPosition',[0 0 3.35 2])
xlabel('# Factors');
ylabel('Covariate R^2')
ylim([0 1]);
box off;



% Use mean PCA to synchronize all the daily factor analyses
controlCoeff = controlCoeff(10);
% X = unravelAll(controlRateMean);
% Cg = princomp(X);
% clear X;
% Cg = Cg(:,1:10);
% Cg = rotateFactors(Cg);
% count = 0;
% for day=1:length(controlCoeff{1})
%     Ct = unravel(controlCoeff{1}{day})';
%     Ct = rotatefactors(Ct,'Method','procrustes','Target',Cg(count+(1:size(Ct,1)),:),'Type','orthogonal');
%     controlCoeff{1}{day} = reravel(Ct',controlCoeff{1}{day});
%     count = count+size(Ct,1);
% end
% factors = projectDown(controlCoeff, controlRateMean);
% 
% IS_3D = sum(abs(controlSnips{1}.targetPos(:,3)))>0;

figure(2); clf;
if(IS_3D)
    for day=1:5
        for f=1:10
            name = sprintf('factor%0.2d',f);
            subplot(5,10,(day-1)*10+f);
            img = nan(35,41);
            img([1:8 10:17 19:26 28:35],[1:20 22:end]) = factors{1}{day+length(controlRate)-5}.(name);
            subplot(5,10,(day-1)*10+f);
            imagesc(img);
            box off;
            axis off;
            axis image;
        end
    end
else
    for day=1:10
        for f=1:10
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