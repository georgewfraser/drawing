#include "mex.h"

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
    double p1, p2, *tx, *x, *ty, *y;
    int nx, ny, nrows, ix, iy, r;
    
    tx = mxGetPr(prhs[0]);
    x = mxGetPr(prhs[1]);
    ty = mxGetPr(prhs[2]);
    
    nx = mxGetN(prhs[1]);
    nrows = mxGetM(prhs[1]);
    ny = mxGetN(prhs[2]);
    
    plhs[0] = mxCreateDoubleMatrix(nrows,ny,mxREAL);
    y = mxGetPr(plhs[0]);
    
    for(r=0; r<nrows; r++) {

        // Interpolate linearly
        ix = 0;
        for(iy=0; iy<ny; iy++) {
            while(ix<nx-2 && tx[(ix+1)*nrows+r]<ty[iy*nrows+r]) {
                ix++;
            }

            if(ty[iy*nrows+r]<tx[ix*nrows+r]) { // ty is beyond left boundary of tx
                p2 = 0;
                p1 = 1;
            } else if(tx[(ix+1)*nrows+r]<ty[iy*nrows+r]) { // ty is beyond right boundary
                p2 = 1;
                p1 = 0;
            } else {
                p2 = (ty[iy*nrows+r]-tx[ix*nrows+r])/(tx[(ix+1)*nrows+r]-tx[ix*nrows+r]);
                p1 = 1-p2;
            }

            y[iy*nrows+r] = p1*x[ix*nrows+r] + p2*x[(ix+1)*nrows+r];
        }
    }
    
}
