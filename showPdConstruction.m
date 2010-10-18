function showPdConstruction(coeff, controlRateMean, perturbRateMean, controlPd)
delete('PD Construction.ps');
for day=1:length(coeff)
    % Synchronize field name and order
    cFields = fieldnames(controlRateMean{day});
    pFields = fieldnames(perturbRateMean{day});
    commonFields = sort(intersect(cFields,pFields));
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
    L_c = R_c*pinv(C); % latent variables
    L_p = R_p*pinv(C); % latent variables
    
    % For each unit that is used in control, do a bunch of plots
    controlFields = fieldnames(controlPd{day});
    controlFields = controlFields(1:5);
    nPlots = sum(ismember(commonFields,controlFields));
    plotRow = 0;
    clf;
    for unit=find(ismember(commonFields,controlFields))'
        plotRow = plotRow+1;
        tuningImage = reshape(R_c(:,unit)+meanR_c(unit),[16 20]);
        r = mean(tuningImage(:,6:15),2);
        ymax = max(r);
        shift = find(r==max(r));
        shift = mod((shift-8:shift+8)-1,16)+1;

        subplot(nPlots,2,(plotRow-1)*2+1);
        plotGroup(R_c, L_c, C, meanR_c, unit, shift, ymax)
        subplot(nPlots,2,(plotRow-1)*2+2);
        plotGroup(R_p, L_p, C, meanR_p, unit, shift, ymax)
    end
    set(gcf,'PaperPosition',[0 0 6.9 nPlots*6.9/4]);
    print -append -dpsc 'PD Construction.ps'
end
end

function plotGroup(R_c, L_c, C, meanR_c, unit, shift, ymax)
hold on;
tuningImage = reshape(R_c(:,unit)+meanR_c(unit),[16 20]);
plotProfile(tuningImage(shift,:), ymax, 'Color', [0 0 0], 'LineWidth', 2);
reconstruction = L_c*C(:,unit)+meanR_c(unit);
tuningImage = reshape(reconstruction, [16 20]);
plotProfile(tuningImage(shift,:), ymax, ':', 'Color', [0 0 0], 'LineWidth', 2);

colors = jet(size(L_c,2));
for factor=1:size(L_c,2)
    reconstruction = L_c(:,factor).*C(factor,unit)+meanR_c(unit);
    tuningImage = reshape(reconstruction, [16 20]);
    plotProfile(tuningImage(shift,:), ymax, 'Color', colors(factor,:), 'LineWidth', 1);
end
end

function plotProfile(tuningImage, ymax, varargin)
% Only works for 16-target 2d
th = (-pi+( (0:16)*2*pi/16))';
r = mean(tuningImage(:,6:15),2);
plot(th,r,varargin{:});
line(th([9 9]),[0 max(r)]);
xlim([-pi pi]);
ylim([0 ymax*1.1]);
xlabel('Target Angle');
ylabel('Firing Rate');
% [x,y] = pol2cart(th,r);
% plot(x([1:end 1]), y([1:end 1]), varargin{:});
end
            