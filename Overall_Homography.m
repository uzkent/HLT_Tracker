H_All = ones(3,3);
for i = 2 : 60
    if i==2
        H_All = H_All .* H{i};
    else
        H_All = H_All * H{i};
    end
end
for i = 23 : 156 %size(Panchromatic,2)
    [~,~,H{i}] = sift_mosaic(Panchromatic{i-1},Panchromatic{i});
end

[c ind] = min(min(abs(u_-75)+abs(v_-413)));
[c ind2] = min((abs(u_-75)+abs(v_-413)));