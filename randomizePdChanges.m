function perturbRateMeanFake = randomizePdChanges(controlEmpiricalPd, perturbEmpiricalPd, controlRateMean)
ROW_TH = (-pi+pi/8:pi/8:pi)';
ROW_TH_3 = [ROW_TH-2*pi; ROW_TH; ROW_TH+2*pi];

perturbRateMeanFake = cell(size(controlRateMean));

for day=1:length(controlEmpiricalPd)
    perturbRateMeanFake{day} = struct();
    
    controlTh = structfun(@(x) cart2pol(x(1),x(2)), controlEmpiricalPd{day},'UniformOutput',false);
    perturbTh = structfun(@(x) cart2pol(x(1),x(2)), perturbEmpiricalPd{day},'UniformOutput',false);
    % These deltaTh's are a little big occasionally due to poorly modulated
    % cells
    deltaTh = wrapToPi(unravel(perturbTh)-unravel(controlTh));
    deltaTh = deltaTh(randperm(numel(deltaTh)));
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
        control3 = repmat(controlRateMean{day}.(name),3,1);
        perturbRateMeanFake{day}.(name) = interp2(1:20,ROW_TH_3,control3,1:20,wrapToPi(ROW_TH-deltaTh_name));
%         if(deltaTh_name~=0)
%             subplot(1,2,1)
%             imagesc(controlRateMean{day}.(name))
%             subplot(1,2,2)
%             imagesc(perturbRateMeanFake{day}.(name))
%             keyboard;
%         end
    end
end