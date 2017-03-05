warning('off','all');
addpath('/home/bxu2522/libsvm-3.20/matlab/');

matlabpool 8
% create a local cluster object
% pc = parcluster;
% pc.NumWorkers = 100; 
% explicitly set the JobStorageLocation to the temp directory that was created in your sbatch script
%pc.JobStorageLocation = strcat('/home/bxu2522/Tasks/', getenv('SLURM_JOB_ID'))
 
% start the parallel pool with 12 workers
% parpool(100);

% Run the Tracking Code in paralel
%c = 1;
%for id = 33:45
   parfor i = 1:8
      [metric{i}]=Main_Detection(35);
   end
%   Output{c} = metric;
%   c = c+1;
%end
save eval35_Det.mat metric;
