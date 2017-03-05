RGB = [];
RGB2 = [];
load Road_Classifier.mat
ml.RD_SVM = linearSVM;   % Transfer the road classifier-SVM to a global variable
for id = 33:45
    %% LOAD DATA
    Dt = dlmread('Input.txt','|', 1,0);   % Input Data
    IF = Dt(id,1);                       % Initial frame where the TOI appears
    target.user_x = Dt(id,3);             % Initial X coordinate of TOI
    target.user_y = Dt(id,4);             % Initial Y coordinate of TOI
    for j=1:size(target.user_y,1)

        % Center of the selected region
        mu = [target.user_x(j,1),target.user_y(j,1)];

        % ROI containing the target
        rows2=ceil(mu(2)-10):ceil(mu(2)+9);
        cols2=ceil(mu(1)-10):ceil(mu(1)+9);

        % Read the HSI image
        Im_1 = matfile(sprintf('../Scenario/Image_%d.mat',IF+1));
        temp_sp2 = Im_1.Image(rows2,cols2,1:1:61);
        temp_sp2 = NoiseAdd_2(temp_sp2);    
        A = temp_sp2;
        RGB = [RGB cat(3,sum(A(:,:,21:2:30),3),sum(A(:,:,11:2:20),3),sum(A(:,:,1:2:10),3))];

        % Classify the Road Pixels and exclude them from the histogram
        test_data = reshape(temp_sp2,size(temp_sp2,1)*size(temp_sp2,2),size(temp_sp2,3));
        [Labels,~,~] = svmpredict(ones(size(test_data,1),1),50*test_data(:,1:2:61), ml.RD_SVM,'-q -b 1');
        Indexes = find(Labels==1);
        test_data(Indexes,:) = -1;
        Veg = (test_data(:,43) - test_data(:,23))./(test_data(:,43) + test_data(:,23)); 
        Veg(Veg<0.25) = -1;
        Veg(Veg>0.25) = 0;
        Veg = reshape(-Veg,size(Veg,1)*size(Veg,2),1);
        test_data = test_data .* repmat(Veg,1,61);
        temp_sp2 = reshape(test_data,size(temp_sp2,1),size(temp_sp2,2),size(temp_sp2,3));

        % Collect Spectral Histogram Features
        temp_sp2(temp_sp2<=0) = 0;
        temp_sp2(temp_sp2~=0) = 1;
        A = temp_sp2;
        RGB2 = [RGB2 cat(3,sum(A(:,:,21:2:30),3),sum(A(:,:,11:2:20),3),sum(A(:,:,1:2:10),3))];


    end
end