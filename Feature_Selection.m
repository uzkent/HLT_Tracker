for i=1:128
    matFile = sprintf('/Users/burakuzkent/Desktop/Research/Tracking/IJCV_Data/S1_N2/I_%d.mat',i+1);
    load(matFile); % The background frame (1-10);
    Image = reshape(Image,394*573,61);
    mappedImage = compute_mapping(Image,'PCA',10); 
    Image = reshape(mappedImage,394,573,10);
    save(sprintf('/Users/burakuzkent/Desktop/Research/Tracking/IJCV_Data/S1_N2/I_PCA_%d.mat',i+1),'Image','-v7.3'); 
end
