% controlEmpiricalPd = computeReconPD(controlSnips, controlRate);
% perturbEmpiricalPd = computeReconPD(perturbSnips, perturbRate);
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
%     controlRateRecon = reconstructFromLatent(controlRate,controlRateMean,nFactors);
%     perturbRateRecon = reconstructFromLatent(perturbRate,perturbRateMean,nFactors);
%     controlRateReconPd = computeReconPd(controlSnips, controlRateRecon);
%     perturbRateReconPd = computeReconPd(perturbSnips, perturbRateRecon);
%     [controlTh, perturbTh, decoderChange, globalChange, meanChange] = pdChange(controlPd, perturbPd, controlRateReconPd, perturbRateReconPd);
%     reconControlThMat{nFactors} = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), controlTh, 'UniformOutput', false));
%     reconPerturbThMat{nFactors} = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), perturbTh, 'UniformOutput', false));
%     reconEmpiricalChangeMat{nFactors} = wrapToPi(reconPerturbThMat{nFactors}-reconControlThMat{nFactors});
%     reconMeanChangeMat{nFactors} = cell2mat(cellfun(@(x) cell2mat(struct2cell(x)), meanChange, 'UniformOutput', false));
% end
% 
% clear controlRateRecon perturbRateRecon;
% clear controlTh perturbTh decoderChange globalChange meanChange;

delete('PD Plots.ps');
for nFactors=1:10
    figure(nFactors);
    
    subplot(1,3,1);
    x = reconControlThMat{nFactors};
    y = controlThMat;
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