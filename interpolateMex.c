#include "mex.h"

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
    double *tx, *ty, *x, *y, p1, p2;
    int nx, ny, ncolumns, ix, iy, c;
    
    tx = mxGetPr(prhs[0]);
    x = mxGetPr(prhs[1]);
    ty = mxGetPr(prhs[2]);
    
    nx = mxGetM(prhs[1]);
    ncolumns = mxGetN(prhs[1]);
    ny = mxGetM(prhs[2])*mxGetN(prhs[2]);
    
    plhs[0] = mxCreateDoubleMatrix(ny,ncolumns,mxREAL);
    y = mxGetPr(plhs[0]);
    
    // Check for edge cases
    if(tx[0]>ty[0]) {
        tx[0] = ty[0];
    }
    if(tx[nx-1]<ty[ny-1]) {
        tx[nx-1] = ty[ny-1];
    }
    
    // Interpolate linearly
    ix = 0;
    for(iy=0; iy<ny; iy++) {
        while(ix<nx-1 && tx[ix+1]<ty[iy]) {
            ix++;
        }
        
        p2 = (ty[iy]-tx[ix])/(tx[ix+1]-tx[ix]);
        p1 = 1-p2;
        
        for(c=0; c<ncolumns; c++) {
            y[c*ny+iy] = p1*x[c*nx+ix] + p2*x[c*nx+ix+1];
        }
    }
    
}
