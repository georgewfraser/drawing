#include "mex.h"

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
	double *spikes, *samples, *values, maxLag;
    int iiSpike, iiSample, iiLeft, nSamples, nSpikes;
    
    spikes = mxGetPr(prhs[0]);
    samples = mxGetPr(prhs[1]);
    maxLag = *mxGetPr(prhs[2]);
    
    nSpikes = mxGetM(prhs[0]) * mxGetN(prhs[0]);
    nSamples = mxGetM(prhs[1]) * mxGetN(prhs[1]);
    
    plhs[0] = mxCreateDoubleMatrix(mxGetM(prhs[0]),mxGetN(prhs[0]),mxREAL);
    values = mxGetPr(plhs[0]);
    
    iiLeft = 0;
    for(iiSample=0; iiSample<nSamples; iiSample++) {
        while(iiLeft<nSpikes && spikes[iiLeft]<samples[iiSample]-maxLag) {
            iiLeft++;
        }
        
        for(iiSpike=iiLeft; iiSpike<nSpikes && spikes[iiSpike]<samples[iiSample]+maxLag; iiSpike++) {
            values[iiSpike] = 1;
        }
    }
}
    