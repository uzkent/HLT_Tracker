warning('off','all');
addpath('/home/bxu2522/libsvm-3.20/matlab/');

% matlabpool 32
% create a local cluster object
% pc = parcluster;
% pc.NumWorkers = 100; 
% explicitly set the JobStorageLocation to the temp directory that was created in your sbatch script
%pc.JobStorageLocation = strcat('/home/bxu2522/Tasks/', getenv('SLURM_JOB_ID'))
 
% start the parallel pool with N number of  workers
parpool(24);

% Define Model Parameters
model.D = 15;
model.Tndvi = 2000.25;
model.Fusion = 'Adaptive';
coeffs = 8;
N_Groups = [6,10,15];

% Run the Tracking Code in paralel
iterations = [1,1,43];  % 43 Represents the Number of Targets to be tracked at Seperate Runs
parfor ix = 1:prod(iterations)
    [mcrun,n_groups,id]=ind2sub(iterations,ix);
    %% Call the Main Tracking Source File
    %% \param[in] id : represents the target ID
    %% \param[in] model : includes the model parameters for the Gaussian Mixture Filter and so on
    %% \param[in] n_groups : How Many Number of Likelihood Maps to Extract from the ROI
    %% \param[out] metric{ix} : the metric cell container to store the tracking results
    [metric{ix}]=Main_Tracking(id,model,coeffs,3+1,n_groups); % Call the Main Tracking Code and save the results
    % to the metric cell contrainter
end
save(['/home/bxu2522/Code_HoGSVM_HSI2/Adaptive.mat'],'metric'); % Save the Individual Tracking Results into a Mat File
[Tp,Tgp,Pr,Rc] = EvaluateResults(metric);  % Compute the Overall Tracking Results
Tp
Tgp
Pr
Rc
