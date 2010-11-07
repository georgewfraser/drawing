function perturbRateHypotheticalMean = hypotheticalCreditAssignmentMeans(controlPd, perturbPd, controlRateMean)
ROW_TH = -pi+pi/8:pi/8:pi;

perturbRateHypotheticalMean = cell(size(controlRateMean));

for day=1:length(controlPd)
    perturbRateHypotheticalMean{day} = struct();
    
    controlTh = structfun(@(x) cart2pol(x(1),x(2)), controlPd{day},'UniformOutput',false);
    perturbTh = structfun(@(x) cart2pol(x(1),x(2)), perturbPd{day},'UniformOutput',false);
    deltaTh = wrapToPi(unravel(perturbTh)-unravel(controlTh));
    deltaTh = reravel(deltaTh, controlTh);
    
    fields = fieldnames(controlRateMean{day});
    for unit=1:length(fields)
        name = fields{unit};
        % This is the theta value for each row of the tuning image
        if(isfield(deltaTh,name))
            deltaTh_name = deltaTh.(name);
        else
            deltaTh_name = 0;
        end
        shiftRows = mod(round((0:15)-deltaTh_name/(pi/8)),16)+1;
        perturbRateHypotheticalMean{day}.(name) = controlRateMean{day}.(name)(shiftRows,:);
%         if(deltaTh_name~=0)
%             subplot(1,2,1)
%             imagesc(controlRateMean{day}.(name))
%             subplot(1,2,2)
%             imagesc(perturbRateHypotheticalMean{day}.(name))
%             keyboard;
%         end
    end
end