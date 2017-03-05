//
//  SpectralSearch.cpp
//
//  Created by Burak Uzkent on 06/03/15.
//
//

#include "mex.h"
#include "matrix.h"
#include "math.h"
#include <stdlib.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    /* Parameter Declarations */
    mxArray *tHist_1,*Dist_1;
    double *inMatrix,*Dist,*rHist,*tHist,*Mask;
    const mwSize *dims;
    mwSize nBands;
    mwSize dimx, dimy, dimz;
    
    /* create a pointer to the real data in the input matrix  */
    inMatrix= mxGetPr(mxDuplicateArray((prhs[0])));
    Mask= mxGetPr(mxDuplicateArray((prhs[1])));
    rHist= mxGetPr(mxDuplicateArray((prhs[2])));
    
    /* Dimensions of the Region of Interest */
    dims = mxGetDimensions(prhs[0]);
    dimy = (mwSize)dims[1]; dimx = (mwSize)dims[0]; dimz = 30;
    nBands = (mwSize)dims[2]/dimz;
    
    /* Spectral Distance Mask */
    Dist = (double*)mxMalloc(dimy*dimx*sizeof(double));
    tHist = (double*)mxMalloc(dimz*nBands*sizeof(double));
    
    /* Spectral Feature Vector Array */
    const mwSize dims3[]={dimx,dimy};
    Dist_1 = plhs[0] = mxCreateNumericArray( 2, dims3, mxDOUBLE_CLASS, mxREAL );
    Dist = mxGetPr(Dist_1);
    
    /* Compute Histogram for the given interval */
    int Row_Size = mxGetScalar(prhs[3]), Col_Size = mxGetScalar(prhs[4]);
    int Row_Offset = Row_Size, Col_Offset = Col_Size;
    int tl_x,tl_y,bl_x,bl_y,tr_y,tr_x,br_x,br_y;
    for (int cs = Col_Offset - 1; cs < dimy-Col_Offset ; cs++)
        for(int rs = Row_Offset - 1; rs < dimx-Row_Offset ; rs++)
          if (Mask[rs+cs*dimx] > 0)
          {
            for(int bds = 0 ; bds < nBands ; bds++)
            {
               double sum = 0;
               for (int bns = 0 ; bns < dimz ; bns++)
                    {
                        tl_x = rs - Row_Size; tl_y = cs - Col_Size;
                        bl_x = rs + Row_Size; bl_y = cs - Col_Size;
                        tr_x = rs - Row_Size; tr_y = cs + Col_Size;
                        br_x = rs + Row_Size; br_y = cs + Col_Size;
                        
                        tHist[bds*dimz+bns] = inMatrix[tl_x+tl_y*dimx+bns*dimx*dimy+bds*dimx*dimy*dimz]
                                +inMatrix[br_x+br_y*dimx+bns*dimx*dimy+bds*dimx*dimy*dimz]
                                -inMatrix[bl_x+bl_y*dimx+bns*dimx*dimy+bds*dimx*dimy*dimz]
                                -inMatrix[tr_x+tr_y*dimx+bns*dimx*dimy+bds*dimx*dimy*dimz];
                        
                        sum = sum + tHist[bds*dimz+bns];

                    }
               for (int bns = 0 ; bns < dimz ; bns++)
               {
                       
                 tHist[bds*dimz+bns] = tHist[bds*dimz+bns] / sum; 
                
                 float s = tHist[bds*dimz+bns] + rHist[bds*dimz+bns];
                 float d = tHist[bds*dimz+bns] - rHist[bds*dimz+bns];
                 
                 Dist[rs+cs*dimx] = Dist[rs+cs*dimx] + (d*d/(s+0.000001)) / 2; 
               }
            }
          }
            else   Dist[rs+cs*dimx] = 100;
}
       
