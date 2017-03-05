/*==========================================================
 * interp_c.cpp - example in MATLAB External Interfaces
    This function interpolates a given function X using the given
    horizontal and vertical maps
 *  Author : Burak Uzkent
 *
 *========================================================*/
/* $Revision: 1.1.10.4 $ */

#include "mex.h"
#include "math.h"

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    mxArray *inMatrix,*outMatrix,*mapMatrix;              /* output matrix */
    double *out,*in,*map_x,*map_y;
    const mwSize *dims;
    int dimx, dimy, numdims;

    /* create a pointer to the real data in the input matrix  */
    in = mxGetPr(mxDuplicateArray((prhs[0])));
    
    /* create a pointer to the real data in the input matrix  */
    map_x = mxGetPr(mxDuplicateArray((prhs[1])));
    map_y = mxGetPr(mxDuplicateArray((prhs[2])));
    
    // figure out dimensions
    dims = mxGetDimensions(prhs[0]);
    dimy = (int)dims[0]; dimx = (int)dims[1];
    
    //associate outputs
    outMatrix = plhs[0] = mxCreateDoubleMatrix(dimy,dimx,mxREAL);
    out = mxGetPr(outMatrix);
    
    mwSize i,j;     // Iteration variables
    
    /* Compute the Warped Image - Nearest Neighbor Interpolation */
//     mwSize x,y;
//     for (i=0; i< dimx; i++) {
//         for (j=0; j<dimy; j++) {
//          x = round(map_x[i*dimy+j]);
//          y = round(map_y[i*dimy+j]);
//          if ((x < 0 || y <0) || (x >= dimx || y >= dimy))
//               out[i*dimy+j] = 0;
//          else out[i*dimy+j] = in[x*dimy+y];
//         }
//     }
    
//     /* Compute the Warped Image - Linear Interpolation */
//     mwSize yo,y1;
//     double x,y,out1,out2;
//     for (i=0; i< dimx; i++) {
//         for (j=0; j<dimy; j++) {
//          x = round(map_x[i*dimy+j]);
//          y = map_y[i*dimy+j];
//          yo = floor(y);
//          y1 = yo +1;
//          if ((x < 0 || yo <0) || (x >= dimx || yo >= dimy))
//               out1 = 0;
//          else out1 = in[x*dimy+yo];
//          if ((x < 0 || y1 < 0) || (x >= dimx || y1 >=dimy))
//               out2 = 0;
//          else out2 = in[x*dimy+y1];
//          out[i*dimy+j] = out1 + double((y - yo) * (out2 - out1) / (y1 - yo));
//         }
//     }
    
    /* Compute the Warped Image - Bilinear Interpolation */
    mwSize y1,y2,x1,x2;
    double x,y,out1,out2,xy1,xy2,out11,out12,out21,out22;
    for (i=0; i< dimx; i++) {
        for (j=0; j<dimy; j++) {
         x = map_x[i*dimy+j];
         x1 = floor(x);
         x2 = x1 + 1;
         y = map_y[i*dimy+j];
         y1 = floor(y);
         y2 = y1 +1;
         if ((x1 < 0 || y1 <0) || (x1 >= dimx || y1 >= dimy))
              out11 = 0;
         else out11 = in[x1*dimy+y1];
         if ((x2 < 0 || y1 < 0) || (x2 >= dimx || y1 >=dimy))
              out21 = 0;
         else out21 = in[x2*dimy+y1];
         if ((x1 < 0 || y2 <0) || (x1 >= dimx || y2 >= dimy))
              out12 = 0;
         else out12 = in[x1*dimy+y2];
         if ((x2 < 0 || y2 < 0) || (x2 >= dimx || y2>=dimy))
              out22 = 0;
         else out22 = in[x2*dimy+y2];
         xy1 = double(out11 * (x2 - x) / (x2 - x1) + out21 * (x - x1) / (x2 - x1));
         xy2 = double(out12 * (x2 - x) / (x2 - x1) + out22 * (x - x1) / (x2 - x1));
         out[i*dimy+j] = double(xy1 * (y2 - y) / (y2 - y1) + xy2 * (y - y1) / (y2 - y1));
        }
    }
}
