function  img=hcon2d(im)

if isempty(im)==1
   img=[];
else
    [m,n,p]=size(im);
    %  J is bands, 
    %img=zeros(p,m*n);
    %for j=1:p
        %img(j,:)=reshape(squeeze(im(:,:,j)),1,m*n);
    %end
    if m>1
       img=reshape(im,p,m*n);
    else
        for j=1:n
            img(:,j)=im(:,j,:);
        end
    end
end
    