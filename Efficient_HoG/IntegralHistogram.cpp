//
//  IntegralHistogram.cpp
//  ComputeHistogram
//
//  Created by Burak Uzkent on 5/7/15.
//
//

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include <stdlib.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    /* output matrix */
    mxArray *outMatrix;
    double *inMatrix,*out,pixel_int,bin_up,bin_down;
    const mwSize *dims;
    const mwSize nBins = 30;
    mwSize dimx, dimy, dimz;
    
    /* create a pointer to the real data in the input matrix  */
    inMatrix= mxGetPr(mxDuplicateArray((prhs[0])));
    
    /* Dimensions of the Region of Interest */
    dims = mxGetDimensions(prhs[0]);
    dimx = (mwSize)dims[0]; dimy = (mwSize)dims[1]; dimz = (mwSize)dims[2]-2;
    out = (double*)mxMalloc(dimy*dimx*dimz*nBins*sizeof(double));

    //associate outputs
    const mwSize dims2[]={dimx,dimy,dimz*nBins};
    outMatrix = plhs[0] = mxCreateNumericArray( 3, dims2, mxDOUBLE_CLASS, mxREAL );
    out = mxGetPr(outMatrix);

    /* Interval for the bins */
    double dist_down,dist_up,mFactor = 0.0259;
    for (int bd = 1; bd<dimz+1 ; bd++)
        for(int cl = 0 ; cl<dimy ; cl++)
            for(int rw = 0; rw<dimx ; rw++)
            {
                pixel_int = inMatrix[rw+cl*dimx+bd*(dimx*dimy)];
                for(int m = 1; m < nBins+1 ; m++){
                                                        
                    if (m == nBins)
                    {
                        bin_down = m * mFactor - mFactor;
                        bin_up = m * mFactor + 5;
                        if (pixel_int > bin_down && pixel_int < bin_up){
                            out[rw+cl*dimx+(bd-1)*nBins*(dimx*dimy)+(m-1)*(dimx*dimy)] = 1;
                            break;
                        }
                    } 
                                        
                    bin_down = m * mFactor - mFactor;
                    bin_up = m * mFactor;
                    
                    if (pixel_int > bin_down && pixel_int < bin_up){
                        dist_down = pixel_int - bin_down;
                        dist_up = bin_up - pixel_int;   
                        out[rw+cl*dimx+(bd-1)*nBins*(dimx*dimy)+m*(dimx*dimy)] = dist_down / mFactor;
                        out[rw+cl*dimx+(bd-1)*nBins*(dimx*dimy)+(m-1)*(dimx*dimy)] = dist_up / mFactor;
                        break;
                    }                                       
                }
            }
    
}
