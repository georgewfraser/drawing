function [pShift, cShift] = showPdShift(controlPd, perturbPd, controlEmpiricalPd, perturbEmpiricalPd, crrBest)
clf;

pShift = [];
cShift = [];
for day=1:length(controlPd)
    cPD = unravel(controlPd{day}); cPD = cPD(1:2,:);
    pPD = unravel(perturbPd{day}); pPD = pPD(1:2,:);
    cePD = unravel(controlEmpiricalPd{day});
    pePD = unravel(perturbEmpiricalPd{day});

    perturbed = sum(abs(pPD-cPD)) ~= 0;
    
    dists = corr(unravel(crrBest{day}));
    
    colors = jet(length(perturbed));
    for unit=find(perturbed)
        closest = dists(:,unit)==max(dists(~perturbed,unit));
        [ceTh1, ceR1] = cart2pol(cePD(1,unit),cePD(2,unit));
        [ceTh2, ceR2] = cart2pol(cePD(1,closest),cePD(2,closest));
        [peTh1, peR1] = cart2pol(pePD(1,unit),pePD(2,unit));
        [peTh2, peR2] = cart2pol(pePD(1,closest),pePD(2,closest));
        [cTh1, cR1] = cart2pol(cPD(1,unit),cPD(2,unit));
        [pTh1, pR1] = cart2pol(pPD(1,unit),pPD(2,unit));
        perturbation = wrapToPi(pTh1-cTh1);
        
        ceTh2 = wrapToPi(ceTh2-ceTh1)*sign(perturbation);
        peTh2 = wrapToPi(peTh2-ceTh1)*sign(perturbation);
        peTh1 = wrapToPi(peTh1-ceTh1)*sign(perturbation);
        ceTh1 = 0;
        
        [ceX1, ceY1] = pol2cart(ceTh1, ceR1);
        [peX1, peY1] = pol2cart(peTh1, peR1);
        [ceX2, ceY2] = pol2cart(ceTh2, ceR2);
        [peX2, peY2] = pol2cart(peTh2, peR2);
        
        subplot(2,2,1), hold on
        line([0 ceX1], [0 ceY1], 'Color', colors(unit,:));
        subplot(2,2,2), hold on
        line([0 peX1], [0 peY1], 'Color', colors(unit,:));
        subplot(2,2,3), hold on
        line([0 ceX2], [0 ceY2], 'Color', colors(unit,:));
        subplot(2,2,4), hold on
        line([0 peX2], [0 peY2], 'Color', colors(unit,:));
        
        pShift(end+1) = peTh1;
        cShift(end+1) = peTh2;
    end
end
end
    
    % Identify closest in factor space
    % Identify furthest in factor space that is close in PD