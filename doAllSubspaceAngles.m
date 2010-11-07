controlEmpiricalPd = empiricalPd(controlRateMean);
controlEmpiricalPdAngles = controlSpaceAngle(controlEmpiricalPd, coeff);
perturbEmpiricalPd = empiricalPd(perturbRateMean);
perturbEmpiricalPdAngles = controlSpaceAngle(perturbEmpiricalPd, coeff);
waterfall(controlEmpiricalPdAngles)
waterfall(perturbEmpiricalPdAngles)
plot(mean(perturbEmpiricalPdAngles))
plot([mean(controlEmpiricalPdAngles); mean(perturbEmpiricalPdAngles)]')