function [ cluster ] = getCluster(username,account,clusterHost,ppn,queue,time,DataLocation,RemoteDataLocation,keyfile,ClusterMatlabRoot)
 cluster = parcluster('GenericProfile1');
 set(cluster,'HasSharedFilesystem',false);
 set(cluster,'JobStorageLocation',DataLocation);
 set(cluster,'OperatingSystem','unix');
 set(cluster,'ClusterMatlabRoot',ClusterMatlabRoot);
 set(cluster,'IndependentSubmitFcn',{@independentSubmitFcn,clusterHost,RemoteDataLocation,account,username,keyfile,time,queue});
 set(cluster,'CommunicatingSubmitFcn',{@communicatingSubmitFcn,clusterHost,RemoteDataLocation,account,username,keyfile,time,queue,ppn});
 set(cluster,'GetJobStateFcn',{@getJobStateFcn,username,keyfile});
 set(cluster,'DeleteJobFcn',{@deleteJobFcn,username,keyfile});
