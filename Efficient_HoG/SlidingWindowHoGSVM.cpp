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
    mwSize rows,cols;
    const mwSize *dims;
 
    /* Create a pointer to the real data in the input matrix  */
    weight = mxGetPr(mxDuplicateArray((prhs[0])));
    bias = mxGetPr(mxDuplicateArray((prhs[1])));
    ginthist = mxGetPr(mxDuplicateArray((prhs[2])));
    
    /* Dimensions of the Region of Interest */
    dims = mxGetDimensions(prhs[2]);
    rows = (mwSize)dims[1]; cols = (mwSize)dims[0];
    int bins = 9;
    int nHorCells = 8;
    int nVerCells = 8;
    int WindowSize = 32;
    int CellSize = 4;
    
    /* Spectral Distance Mask */
    int RowsMap = rows - 2;
    int ColsMap = cols - 2;
    CellHists = (double*)mxMalloc(576*1*sizeof(double));
    hogFeatures = (double*)mxMalloc(1764*1*sizeof(double));
    DistanceMap = (double*)mxMalloc(RowsMap*ColsMap*sizeof(double));
    
    /* Spectral Feature Vector Array */
    const mwSize dims3[]={576,1};
    const mwSize dimsHoG[]={1764,1};
    Dist_1 = mxCreateNumericArray( 2, dims3, mxDOUBLE_CLASS, mxREAL );
    Dist_2 = mxCreateNumericArray( 2, dimsHoG, mxDOUBLE_CLASS, mxREAL );
    CellHists = mxGetPr(Dist_1);
    hogFeatures = mxGetPr(Dist_2);
    
    /* Spectral Feature Vector Array */
    const mwSize dims2[]={RowsMap,ColsMap};
    Dist = plhs[0] = mxCreateNumericArray( 2, dims2, mxDOUBLE_CLASS, mxREAL );
    DistanceMap = mxGetPr(Dist);
    
    /* Compute Histogram for the given interval */
    for (int rsIm = 0; rsIm < rows-WindowSize; rsIm++)
    {
        for(int csIm = 0; csIm < cols-WindowSize; csIm++)
        {
           for (int rs = 0; rs < nVerCells ; rs++)
               for(int cs = 0; cs < nHorCells; cs++)
                {
                    int x1 = rs * CellSize + (csIm+cs*CellSize) * rows + rsIm;
                    int x2 = x1 + CellSize;    
                    int x3 = x1 + CellSize*rows;
                    int x4 = x3 + CellSize;
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
                float magnitude = 0;
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
                    hogFeatures[counter] = hogFeatures[counter]/(sqrt(CellMagnitude)+0.0001);
                    counter = counter + 1;
                }
               }
           // Perform SVM Prediction
           float finalresult = 0;
           for (int i = 0; i < 1764 ; i++)
           {
             finalresult = finalresult + weight[i] * (hogFeatures[i]+0.0001);
           }
           DistanceMap[(csIm+17)*RowsMap-2+rsIm+17] = finalresult - 0.052; 
        }
    }
}
