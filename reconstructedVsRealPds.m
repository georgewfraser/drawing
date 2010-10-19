% controlEmpiricalPd = confidentPd(controlSnips, controlRate);
% perturbEmpiricalPd = confidentPd(perturbSnips, perturbRate);
% 
% % Strip out units that aren't in both the control population and the
% % reconstruction population
% for day=1:length(controlEmpiricalPd)
%     commonFields = intersect(fieldnames(controlPd{day}),fieldnames(coeff{1}{day}));
%     controlEmpiricalPd{day} = rmfield(controlEmpiricalPd{day},setdiff(fieldnames(controlEmpiricalPd{day}),commonFields));
%     perturbEmpiricalPd{day} = rmfield(perturbEmpiricalPd{day},setdiff(fieldnames(perturbEmpiricalPd{day}),commonFields));
% end
% 
% [controlTh, perturbTh, decoderChange, globalChange, meanChange] = pdChange(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd);
% decoderChangeMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), decoderChange, 'UniformOutput', false));
% globalChangeMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), globalChange, 'UniformOutput', false));
% controlThMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), controlTh, 'UniformOutput', false));
% perturbThMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), perturbTh, 'UniformOutput', false));
% empiricalChangeMat = wrapToPi(perturbThMat-controlThMat);
% meanChangeMat = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), meanChange, 'UniformOutput', false));
%     
% reconControlThMat = cell(10,1);
% reconPerturbThMat = cell(10,1);
% reconEmpiricalChangeMat = cell(10,1);
% reconMeanChangeMat = cell(10,1);
% for nFactors=1:10
%     fprintf('Factor %d\n',nFactors);
%     controlRateRecon = reconstructFromLatent(controlRate,coeff{nFactors});
%     perturbRateRecon = reconstructFromLatent(perturbRate,coeff{nFactors});
%     controlRateReconPd = confidentPd(controlSnips, controlRateRecon);
%     perturbRateReconPd = confidentPd(perturbSnips, perturbRateRecon);
%     [controlTh, perturbTh, decoderChange, globalChange, meanChange] = pdChange(controlPd, perturbPd, controlRateReconPd, perturbRateReconPd);
%     reconControlThMat{nFactors} = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), controlTh, 'UniformOutput', false));
%     reconPerturbThMat{nFactors} = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), perturbTh, 'UniformOutput', false));
%     reconEmpiricalChangeMat{nFactors} = wrapToPi(reconPerturbThMat{nFactors}-reconControlThMat{nFactors});
%     reconMeanChangeMat{nFactors} = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), meanChange, 'UniformOutput', false));
% end
% 
% clear controlRateMeanRecon perturbRateMeanRecon;
% clear controlTh perturbTh decoderChange globalChange meanChange;

delete('PD Plots.ps');
for nFactors=1:10
    figure(nFactors);
    
    subplot(1,3,1);
    x = reconControlThMat{nFactors};
    y = controlThMat;
    mask = ~isnan(x)&~isnan(y);
    x = x(mask);
    y = y(mask);
    y = x+(wrapToPi(y-x));
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*1.1);
    ylim([-pi pi]*1.1);
    xlabel('R. PD');
    ylabel('PD');
    title(corr(x,y));
    
    subplot(1,3,2);
    x = reconPerturbThMat{nFactors};
    y = perturbThMat;
    mask = ~isnan(x)&~isnan(y);
    x = x(mask);
    y = y(mask);
    y = x+(wrapToPi(y-x));
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*1.1);
    ylim([-pi pi]*1.1);
    xlabel('R. PD');
    ylabel('PD');
    title(corr(x,y));
    
    subplot(1,3,3);
    x = wrapToPi(reconEmpiricalChangeMat{nFactors}-reconMeanChangeMat{nFactors}).*sign(globalChangeMat);
    y = wrapToPi(empiricalChangeMat-meanChangeMat).*sign(globalChangeMat);
    mask = ~isnan(x)&~isnan(y);
    x = x(mask);
    y = y(mask);
%     x = wrapToPi(reconEmpiricalChangeMat{nFactors});
%     y = wrapToPi(empiricalChangeMat);
    y = x+(wrapToPi(y-x));
    plot(x, y,'.');
    line([-pi pi],[-pi pi]);
    axis image;
    xlim([-pi pi]*1.1);
    ylim([-pi pi]*1.1);
    xlabel('R. \Delta PD');
    ylabel('\Delta PD');
    title(corr(x,y));
    
    print -dpsc -append 'PD Plots.ps';
end