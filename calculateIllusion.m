function illusion = calculateIllusion(snips)
illusion = snips.progress;
illusion = illusion-2;
illusion = illusion/2;
illusion(illusion<0) = 0;
illusion(illusion>1) = 1;
illusion(~snips.is_illusion,:) = 0;
% Map [0,1] to [0,1.8]
illusion = 1+illusion*.8;
illusion(~snips.is_ellipse,:) = 1./illusion(~snips.is_ellipse,:);
illusion = illusion-1;
end