first = '/Users/burakuzkent/Desktop/Image_Set/MultiSpectral/';
files = dir( fullfile(first,'*img') );
files = {files.name}';
files = sort_nat(files);
for i = 1:107
    full = [first files{i}];
    Image = enviread(full);
    Image = NoiseAdd_2(Image);
    for j = 1:5
        Image2(:,:,j)=(255*Image(:,:,j)./max(max(Image(:,:,j))));
    end
    ImageSave = [Image2(:,:,1) Image2(:,:,2) Image2(:,:,3) Image2(:,:,4) Image2(:,:,5)];
    full2 = [first 'Image_' num2str(i) '.png'];
    imwrite(uint8(ImageSave),full2);
end