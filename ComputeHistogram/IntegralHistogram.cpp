//
//  IntegralHistogram.cpp
//  ComputeHistogram
//
//  Created by Burak Uzkent on 5/7/15.
//
//

#include "mex.h"
#include "matrix.h"
#include <stdlib.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    /* output matrix */
    mxArray *outMatrix;
    double *inMatrix,*out,*out2,pixel_int,bin_up,bin_down;
    const mwSize *dims;
    const mwSize nBins = 10;
    mwSize dimx, dimy, dimz;
    
    /* create a pointer to the real data in the input matrix  */
    inMatrix= mxGetPr(mxDuplicateArray((prhs[0])));
    
    /* Dimensions of the Region of Interest */
    dims = mxGetDimensions(prhs[0]);
    dimy = (mwSize)dims[0]; dimx = (mwSize)dims[1]; dimz = (mwSize)dims[2];

    out = (double*)mxMalloc(dimy*dimx*dimz*nBins*sizeof(double));

    //associate outputs
    const mwSize dims2[]={dimy,dimx,dimz*nBins};
    outMatrix = plhs[0] = mxCreateNumericArray( 3, dims2, mxDOUBLE_CLASS, mxREAL );
    out = mxGetPr(outMatrix);
    
    /* Interval for the bins */
    double dist_down,dist_up;
    for (int bd = 0; bd<dimz ; bd++)
        for(int rw = 0 ; rw<dimx ; rw++)
            for(int cl = 0; cl<dimy ; cl++)
            {
                pixel_int = inMatrix[cl+rw*dimx+bd*(dimx*dimy)];
                
                for(int m = 1; m < 11 ; m++){
                    
                    bin_down = m * 0.1 - 0.1;
                    bin_up = m * 0.1;
                    
                    if (pixel_int > bin_down && pixel_int < bin_up){
                        dist_down = pixel_int - bin_down;
                        dist_up = bin_up - pixel_int;
                        out[cl+rw*dimy+bd*(dimx*dimy)+(m*dimy*dimx)] = dist_up / 0.1;
                        out[cl+rw*dimy+bd*(dimx*dimy)+((m-1)*dimy*dimx)] = dist_down / 0.1;
                        break;}
                }
            }
}