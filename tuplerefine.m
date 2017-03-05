function [a]=tuplerefine(a,bh,time)
%--------------------------------------------------------------------------
%   Explanation :
%       This function eliminates unlikely tuples by considering euclidean
%       distance between the measurements at time k-S+1 and k-S+2
%--------------------------------------------------------------------------
N=size(a,2);
ind=1;
for j=time-N+1:time-1
    row = zeros(size(a,1),1);
    rowtemp = zeros(size(a,1),1);
    for i=1:size(a,1)
        row(i) = i;
        if a(i,ind) == 0 || a(i,ind+1) == 0
            row(i) = 0;
        end
    end
    rowtemp=row;
    rowtemp(rowtemp==0)=[];
    [index]=find(row~=0);
    dis=bh{j}(a(rowtemp,ind),1:2)-bh{j+1}(a(rowtemp,ind+1),1:2);
    eucdis=sqrt(dis(:,1).^2+dis(:,2).^2);
    [bigind]=find(eucdis>75);
    a(index(bigind),:)=[];
    ind=ind+1;
end
end
