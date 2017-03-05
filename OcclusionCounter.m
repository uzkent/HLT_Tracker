Dt = dlmread('Input_MoreSamples_WTrees.txt');       % Input Data
c = 1;
for id = 1:size(Dt,1)
    I_F = Dt(id,2);                       % Initial frame where the TOI appears
    I_Fin = Dt(id,3);                     % Final Frame for tracking
    target.user_x = Dt(id,4);             % Initial X coordinate of TOI
    target.user_y = Dt(id,5);             % Initial Y coordinate of TOI

    first = '/Users/burakuzkent/Desktop/Research/Tracking/Ground_Truth/Scenario1/';
    second = Dt(id,1);
    fid = fopen([first,num2str(second),'_track.txt'],'r');

    %% Read data (coordinates of the TOI)
    C_data = textscan(fid, '%s %d %d');

    %% Initial Time of Appearance
    Cdata = cell2mat(C_data{1});
    toa = str2num([Cdata(:,19) Cdata(:,20) Cdata(:,21)]); 
    Indx = find(toa==Dt(id,2)+1);

    for i = 1:size(Cdata,1)-1
        Diff(i) = str2num([Cdata(i+1,19) Cdata(i+1,20) Cdata(i+1,21)])-str2num([Cdata(i,19) Cdata(i,20) Cdata(i,21)])-1; 
    end
    if id == 24
        e=2;
    end
    Occ(c) = sum(Diff(Indx:end)); % / (I_Fin-I_F);
    c = c+1;
    Diff = [];
end