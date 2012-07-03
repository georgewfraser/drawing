#include "mex.h"

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
    double *tx, *ty, *x, *y, p1, p2, *all_tx, *all_x, *all_ty, *all_y;
    int nx, ny, ncolumns, ix, iy, c;
    
    all_tx = mxGetPr(prhs[0]);
    all_x = mxGetPr(prhs[1]);
    all_ty = mxGetPr(prhs[2]);
    
    nx = mxGetM(prhs[1]);
    ncolumns = mxGetN(prhs[1]);
    ny = mxGetM(prhs[2]);
    
    plhs[0] = mxCreateDoubleMatrix(ny,ncolumns,mxREAL);
    all_y = mxGetPr(plhs[0]);
    
    for(c=0; c<ncolumns; c++) {
        // Set the pointers 
        x = all_x+c*nx;
        y = all_y+c*ny;
        tx = all_tx+c*nx;
        ty = all_ty+c*ny;

        // Interpolate linearly
        ix = 0;
        for(iy=0; iy<ny; iy++) {
            while(ix<nx-2 && tx[ix+1]<ty[iy]) {
                ix++;
            }
        
            if(ty[iy]<tx[ix]) { // ty is beyond left boundary of tx
                p2 = 0;
                p1 = 1;
            } else if(tx[ix+1]<ty[iy]) { // ty is beyond right boundary
                p2 = 1;
                p1 = 0;
            } else {
                p2 = (ty[iy]-tx[ix])/(tx[ix+1]-tx[ix]);
                p1 = 1-p2;
            }

            y[iy] = p1*x[ix] + p2*x[ix+1];
        }
    }
    
}
