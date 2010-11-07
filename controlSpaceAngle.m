function angles = controlSpaceAngle(controlPd, coeff)
angles = nan(length(controlPd),length(coeff));
for day=1:length(controlPd)
    controlFields = fieldnames(controlPd{day});
    coeffFields = fieldnames(coeff{1}{day});
    commonFields = intersect(controlFields,coeffFields);
    for nFactors=1:length(coeff)
    controlPd{day} = orderfields(rmfield(controlPd{day},setdiff(controlFields,commonFields)));
        coeff{nFactors}{day} = orderfields(rmfield(coeff{nFactors}{day},setdiff(coeffFields,commonFields)));

        controlSpace = cell2mat(struct2cell(controlPd{day}));
        controlSpace = controlSpace(:,1:2);
        coeffSpace = cell2mat(struct2cell(coeff{nFactors}{day}));
        angles(day,nFactors) = subspace(controlSpace, coeffSpace);
    end
end