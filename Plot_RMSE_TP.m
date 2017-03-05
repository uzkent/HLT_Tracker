tic
parfor idx=1:50
     [m]=Main(Panchromatic,9);
     output{idx}=m;
end
toc

tp=0;
A=nan(95,100)';
for i=1:size(output,2)
tp=tp+output{i}.tp_rate;
B=output{i}.rmse;
A(i,:)=[B nan(95-size(B,2),1)'];
end
rmse = nanmean(A,1);
tp = tp/size(output,2);
plot(rmse,'k-o')

