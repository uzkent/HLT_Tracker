rw_1=797;
rw_2=806;
cl_1=373;
cl_2=389;
for i=size(Data2,2)+1:size(Data2,2)+20
    rw1=randi([rw_1-3 rw_1+5]);
    rw2=randi([rw_2-3 rw_2+3]);
    cl1=randi([cl_1-2 cl_1+5]);
    cl2=randi([cl_2-2 cl_2+2]);
    Data2{i}=Image(rw1:rw2,cl1:cl2,:);
    % temp{i}=sum(Data2{i},3);
end


for i=size(Data2,2)+1:size(Data2,2)+100
    rw_1=674;
    rw_2=709;
    cl_1=38;
    cl_2=88;
    rw1=randi([rw_1 rw_2-15]);
    cl1=randi([cl_1 cl_2-15]);
    indr=randi([10 12]);
    indc=randi([10 12]);
    Data2{i}=Image(rw1:rw1+indr,cl1:cl1+indc,:);
    temp2{i}=sum(Data2{i},3);
end

for i=size(Data2,2)+1:size(Data2,2)+20
    rw_1=802;
    cl_1=512;
    rw1=randi([rw_1-1 rw_1+1]);
    cl1=randi([cl_1-1 cl_1+1]);
    indr=randi([10 11]);
    indc=randi([12 13]);
    Data2{i}=Image(rw1:rw1+indr,cl1:cl1+indc,:);
    temp2{i}=sum(Data2{i},3);
end