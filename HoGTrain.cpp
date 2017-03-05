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
    mxArray *Dist_1,*Dist_2,*Dist;
    double *ginthist,*LMap,*weight,*bias,*CellHists,*hogFeatures,*DistanceMap;
    mwSize rows,cols;//bins,nHorCells,nVerCells,WindowSize,CellSize;
    const mwSize *dims;
 
    /* create a pointer to the real data in the input matrix  */
    ginthist = mxGetPr(mxDuplicateArray((prhs[0])));
    
    /* Dimensions of the Region of Interest */
    dims = mxGetDimensions(prhs[0]);
    rows = (mwSize)dims[1]; cols = (mwSize)dims[0];
    int bins = 9;
    int nHorCells = 8;
    int nVerCells = 8;
    int WindowSize = 32;
    int CellSize = 4;
    
    /* Spectral Distance Mask */
    CellHists = (double*)mxMalloc(nHorCells*nVerCells*bins*sizeof(double));
    hogFeatures = (double*)mxMalloc(1764*1*sizeof(double));
    DistanceMap = (double*)mxMalloc(rows*cols*sizeof(double));
    
    /* Spectral Feature Vector Array */
    const mwSize dims3[]={576};
    const mwSize dimsHoG[]={1764};
    Dist_1 = plhs[1] = mxCreateNumericArray( 1, dims3, mxDOUBLE_CLASS, mxREAL );
    Dist_2 = plhs[0] = mxCreateNumericArray( 1, dimsHoG, mxDOUBLE_CLASS, mxREAL );
    CellHists = mxGetPr(Dist_1);
    hogFeatures = mxGetPr(Dist_2);
    
    
    /* Compute Histogram for the given interval */
    for (int rsIm = 0; rsIm < 1; rsIm++)
    {
        for(int csIm = 0; csIm < 1; csIm++)
        {
            for (int rs = 0; rs < nVerCells ; rs++)
                for(int cs = 0; cs < nHorCells; cs++)
                {
                    int x1 = rs * CellSize + (csIm+cs*CellSize) * rows + rsIm;
                    int x2 = x1 + CellSize;    
                    int x3 = rs * CellSize + (csIm+(cs+1)*CellSize) * rows + rsIm;
                    int x4 = x3 + CellSize;
                    // mexPrintf("%d,%d,%d,%d\n",x1,x2,x3,x4);
                    for (int i = 0; i < bins ; i++)
                    {
                        CellHists[cs*8+rs+(i*64)] = ginthist[x1+(i*rows*cols)]+ginthist[x4+(i*rows*cols)]-ginthist[x2+(i*rows*cols)]-ginthist[x3+(i*rows*cols)];
                    }
                }    
           // Normalize the resulting block histograms
           int counter = 0;
           for (int rs2 = 0; rs2 < nVerCells-1 ; rs2++)
               for(int cs2 = 0; cs2 < nHorCells-1; cs2++)
               {
                float CellMagnitude = 0;
                float magnitude;
                for (int i = 0; i < bins ; i++)
                    {
                    for (int cInd = 0; cInd < 2 ; cInd++)
                    {
                        for(int rInd = 0; rInd < 2; rInd++)
                        {
                            // Get histograms for the cells in this block. (4 cells in a Block)
                            magnitude = CellHists[(cs2+cInd)*nVerCells+rs2+rInd+(i*64)];
                            hogFeatures[counter] = magnitude;
                            CellMagnitude = CellMagnitude + pow(magnitude,2);
                            counter = counter + 1;
                        }
                   }
                }
                counter = counter - 36;
                for (int i = 0; i < 36 ; i++)
                {
                    // Get histograms for the cells in this block. (4 cells in a Block)
                    hogFeatures[counter] = hogFeatures[counter]/(sqrt(CellMagnitude)+0.001);
                    counter = counter + 1;
                }
               }
    }
}
}
