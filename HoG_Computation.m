j = 1:2:10;
bins = 9;
for i=1:size(Training_Data,2)
    Temp = NoiseAdd_2(Training_Data{i});
    Im2 = sum(Temp(:,:,1:2:30),3);
    Im2 = imresize(Im2,[32,32]);
    [ginthist]=gradimageintegral(Im2);
    ginthist = padarray(ginthist,[1 1]);
    train{2}(i,:) = HoGTrain(ginthist)';
    RGB = []; 
end

for i=1:size(Test_Data,2)
    
    Im2 = sum(Temp(:,:,1:2:30),3);
    Im2 = imresize(Im2,[32,32]);
    [ginthist]=gradimageintegral(Im2);
    ginthist = padarray(ginthist,[1 1]);
    test{2}(i,:) = HoGTrain(ginthist)';
    RGB = [];
end


% Learn the SVM Binary Classifier with the Computed Features
[w,b,info] = vl_svmtrain(train{2}',Labels,0.02,'MaxNumIterations', 100000);

% Validate on the Validation Data
Scores = w' * test{2}' + b;
Scores( Scores>0 ) = 1;
Scores( Scores<0 ) = -1;
Results = TestLabels' - Scores;
Results(Results~=0) = 1;
1 - sum(Results)/size(TestLabels,1)