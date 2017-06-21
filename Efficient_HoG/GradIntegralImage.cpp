//
//  GradIntegralImage.cpp
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
    mxArray *Dist_1;
    double *phase,*mag,*ginthist,*interval;
    mwSize rows,cols;
    const mwSize *dims;
    
    /* create a pointer to the real data in the input matrix  */
    interval = mxGetPr(mxDuplicateArray((prhs[0])));
    phase = mxGetPr(mxDuplicateArray((prhs[1])));
    mag = mxGetPr(mxDuplicateArray((prhs[2])));
    
    /* Dimensions of the Region of Interest */
    dims = mxGetDimensions(prhs[1]);
    rows = (mwSize)dims[1]; cols = (mwSize)dims[0];
    
    /* Spectral Distance Mask */
    ginthist = (double*)mxMalloc(rows*cols*9*sizeof(double));
    
    /* Spectral Feature Vector Array */
    const mwSize dims3[]={rows,cols,9};
    Dist_1 = plhs[0] = mxCreateNumericArray( 3, dims3, mxDOUBLE_CLASS, mxREAL );
    ginthist = mxGetPr(Dist_1);
    
    /* Compute Histogram for the given interval */
    int lowerIndex, upperIndex;
    for (int cs = 0; cs < cols ; cs++)
        for(int rs = 0; rs < rows ; rs++)
        {
            for (int i = 0; i < 8 ; i++)
            {
                if ((phase[rows*cs+rs] > interval[i]) && (phase[rows*cs+rs] < interval[i+1]))
                {
                    lowerIndex = i;
                    upperIndex = i+1;
                }   
            }
        
            /* Compute the closeness of the smaller and larger bin */
            float lowerCont = abs(phase[rows*cs+rs] - float(interval[lowerIndex]));
            float upperCont = abs(float(interval[upperIndex]) - phase[rows*cs+rs]);

            /* Compute the magnitude to be assigned to small and large bin */
            float lowerMag = mag[rows*cs+rs] * upperCont/(upperCont + lowerCont);
            float upperMag = mag[rows*cs+rs] - lowerMag;

            ginthist[rows*cs+rs+(lowerIndex*rows*cols)] = lowerMag; 
            ginthist[rows*cs+rs+(upperIndex*rows*cols)] = upperMag;
        
        }    
}
