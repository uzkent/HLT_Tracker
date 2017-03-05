# Aerial Hyperspectral Target Tracking using Adaptive Likelihood Map Fusion
<p> This code performs single aerial target tracking using hyperspectral videos.
We initially select a target and compute N number of distance maps in a ROI and 
fuse these distance maps. The final map is thresholded and applied morphological
opening and connected component labeling. Next, a multi-dimensional data assignment
algorithm is used with the hyperspectral and kinematic likelihoods to update the 
Gaussian Mixture Filter Components. </p>

## How to Run the Code on the Server
<p> The shell scripting files are run to run the tracking algorithm with the given
settings. The terminal command to run the shell script is :
   <ul>
      <li> sbatch --qos=free batchScript_Detection35.sh
   </ul>
</p>

<p>The shell file includes commands to run the tracker with certain settings. For example,
we request to be allocated a certain number of CPUs and nodes in each CPU. In the shell file
the tracker is run with the command shown below :
   <ul>
      <li> matlab -nodisplay -nosplash -nodesktop < MonteCarloRun_35.m
   </ul>
</p>

### The contents of the MonteCarloRun_35.m Main Source File
<p> parpool(N) : starts N number of workers to run the tracker algoritm in paralel. </p>

<p> model.D : represents the number of dimension considered in the Multi-dimensional Assignment
Algorithm </p>

<p> model.Fusion : Calls the Desired Fusion Method to Fuse Likelihoods ROI Maps. The Options are :
<ul>
   <li> Adaptive
   <li> Classic
   <li> VR (Variance Ratio Method)
</ul>

<p> model.N_Groups : How many number of Likelihood Maps are extracted from the full spectrum </p>

<p> Main_Tracking calls the main tracking source file to track the target with the given ID  </p>

## How to Run the Code Locally
<p> Download the code to your local computer using a file transfer software. Next, run the tracker
using the Main Source file Main_Tracking(). You can use the command below to run the tracker locally
<ul>
   <li> Main_Tracking(targetID,~,~,~,n_groups); % n_groups : number of likelihood maps
</ul>
