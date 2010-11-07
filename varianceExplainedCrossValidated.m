function [explained, reconstruction, coeff] = varianceExplainedCrossValidated(rate)
[explained, reconstruction, coeff] = pcaExplainedCrossValidated(rate);