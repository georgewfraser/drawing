function R2 = weightedFactorDependence(coeff1, coeff2)
N_FACTORS = length(coeff1);
N_DAYS = length(coeff1{1});
R2 = nan(N_DAYS,N_FACTORS);

for day=1:N_DAYS
    C1 = unravel(coeff1{N_FACTORS}{day})';
    C2 = unravel(coeff2{N_FACTORS}{day})';
    R2(day,:) = subspacea(C1,C2);
end
    