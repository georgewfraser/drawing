function [controlPd, perturbPd] = extractionModulePD(fileFormat, dateFormat, dates, control, perturb)
control = floor(mean(control,2));
perturb = floor(mean(perturb,2));
controlPd = cell(size(dates));
perturbPd = cell(size(dates));
for iid=1:length(dates)
    controlData = load(sprintf(fileFormat, datestr(dates(iid),dateFormat), control(iid)));
    perturbData = load(sprintf(fileFormat, datestr(dates(iid),dateFormat), perturb(iid)));
    names = cellstr(controlData.header.cell_data.Firing);
    for iin=1:length(names)
        if(controlData.header.cell_data.ModulatedCellsList(iin))
            controlPd{iid}.(names{iin}) = controlData.header.cell_data.PD(iin,:);
            perturbPd{iid}.(names{iin}) = perturbData.header.cell_data_modified.PD(iin,:);
        end
    end
end