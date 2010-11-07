function showPdConstruction(coeff, controlRateMean, perturbRateMean, controlPd)
delete('PD Construction.ps');
for day=1:length(coeff)
    % Synchronize field name and order
    cFields = fieldnames(controlRateMean{day});
    pFields = fieldnames(perturbRateMean{day});
    commonFields = sort(intersect(fieldnames(coeff{day}),intersect(cFields,pFields)));
    controlRateMean{day} = orderfields(rmfield(controlRateMean{day},setdiff(cFields,commonFields)));
    perturbRateMean{day} = orderfields(rmfield(perturbRateMean{day},setdiff(pFields,commonFields)));
    % Create data matrices
    R_c = unravel(controlRateMean{day}); % control rates
    R_p = unravel(perturbRateMean{day}); % perturb rates
    % Subtract means (but save them)
    meanR_c = mean(R_c);
    meanR_p = mean(R_p);
    R_c = bsxfun(@minus,R_c,meanR_c);
    R_p = bsxfun(@minus,R_p,meanR_p);
    % Create latent variable matrices
    C = unravel(coeff{day}); % coefficients for latent variables
    C = rotatefactors(C','Maxit',1000)';
    L_c = R_c*pinv(C); % latent variables
    L_p = R_p*pinv(C); % latent variables
    
    % For each unit that is used in control, do a bunch of plots
    controlFields = fieldnames(controlPd{day});
%     controlFields = controlFields(1:min(length(controlFields),10));
    plotRow = 0;
    clf;
    for unit=find(ismember(commonFields,controlFields))'
        plotRow = plotRow+1;
        if(plotRow>10)
            figure;
            plotRow = 1;
        end
        
        tuningImage = reshape(R_c(:,unit)+meanR_c(unit),[16 20]);
        r = mean(tuningImage(:,6:15),2);
        th = (-pi+pi/8:pi/8:pi)';
        [x, y] = pol2cart(th,1);
        pd = regress(r,[x y]);
        pd = cart2pol(pd(1),pd(2));
        ymax = max(r);

        subplot(10,4,(plotRow-1)*4+1);
        hold on;
        plotOne(R_c, L_c, C, meanR_c, unit, ymax, pd)
        subplot(10,4,(plotRow-1)*4+2);
        hold on;
        plotGroup(R_c, L_c, C, meanR_p, unit, ymax)
        
        tuningImage = reshape(R_p(:,unit)+meanR_p(unit),[16 20]);
        r = mean(tuningImage(:,6:15),2);
        pd = regress(r,[x y]);
        pd = cart2pol(pd(1),pd(2));
        
        subplot(10,4,(plotRow-1)*4+3);
        hold on;
        plotOne(R_p, L_p, C, meanR_p, unit, ymax, pd)
        subplot(10,4,(plotRow-1)*4+4);
        hold on;
        plotGroup(R_p, L_p, C, meanR_p, unit, ymax)
    end
    set(gcf,'PaperPosition',[0 0 6.9 10/4*6.9/2]);
    print -append -dpsc 'PD Construction.ps'
end
end

function plotOne(R_c, L_c, C, meanR_c, unit, ymax, pd)
tuningImage = reshape(R_c(:,unit)+meanR_c(unit),[16 20]);
plotProfile(tuningImage, ymax, 'Color', [0 0 0], 'LineWidth', 2);
reconstruction = L_c*C(:,unit)+meanR_c(unit);
tuningImage = reshape(reconstruction, [16 20]);
plotProfile(tuningImage, ymax, '.', 'Color', [0 0 0], 'LineWidth', 2);
line([pd pd],[0 ymax]);
end

function plotGroup(R_c, L_c, C, meanR_c, unit, ymax)
colors = jet(size(L_c,2));
for factor=find(abs(C(:,unit))>sum(abs(C(:,unit)))*.1)'
    reconstruction = L_c(:,factor).*C(factor,unit)+meanR_c(unit);
    tuningImage = reshape(reconstruction, [16 20]);
    plotProfile(tuningImage, ymax, 'Color', colors(factor,:), 'LineWidth', 1);
end
end

function plotProfile(tuningImage, ymax, varargin)
% Only works for 16-target 2d
th = (-pi+pi/8:pi/8:pi)';
r = mean(tuningImage(:,6:15),2);
plot(th,r,varargin{:});
xlim([-pi pi]);
ylim([0 ymax*1.1]);
% xlim([-1 1]*ymax*1.1);
% ylim([-1 1]*ymax*1.1);
xlabel('Target Angle');
ylabel('Firing Rate');
% [x,y] = pol2cart(th,r);
% plot(x([1:end 1]), y([1:end 1]), varargin{:});
end
            