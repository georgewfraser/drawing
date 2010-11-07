#include "mex.h"

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
    double *values, *counts, *edges;
    int nvalues, nedges, lb, rb;
    
    values = mxGetPr(prhs[0]);
    edges = mxGetPr(prhs[1]);
    nvalues = mxGetM(prhs[0])*mxGetN(prhs[0]);
    nedges = mxGetM(prhs[1])*mxGetN(prhs[1]);
    plhs[0] = mxCreateDoubleMatrix(nedges-1,1,mxREAL);
    counts = mxGetPr(plhs[0]);
    
    if(nvalues==0) {
        return;
    }
    
    // Find the starting value by binary search
    if(values[0]>edges[0]) {
        rb = 0;
    } else if(values[nvalues-1]<edges[0]) {
        return;
    } else {
        lb = 0;
        rb = nvalues-1;

        while(lb<rb-1) {
            if(values[(lb+rb)/2] < edges[0]) {
                lb = (lb+rb)/2;
            } else {
                rb = (lb+rb)/2;
            }
        }
    }
    
    // Sweep through the values, counting, until they get too big
    lb = 0;
    while(rb<nvalues && values[rb]<edges[nedges-1]) {
        // Advance the edge caret until the current value is in the current bin
        while(edges[lb+1]<values[rb]) {
            lb++;
        }
        // Increment the current bin
        counts[lb]++;
        // Increment the value caret
        rb++;
    }
}
            