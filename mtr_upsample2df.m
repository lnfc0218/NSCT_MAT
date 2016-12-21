function h0=mtr_upsample2df(h0, power)

% 对滤波器进行操作不必用矩阵形式
% 可用稀疏矩阵提高效率
[m,n]=size(h0);
R1=zeros(2^power*m,m);
R2=zeros(n,2^power*n);
for i=1:m
    R1(1+(i-1)*2^(power),i)=1;
end
for i=1:n
    R2(i,1+(i-1)*2^(power))=1;
end
h0=R1*h0*R2;
end

