function A=mtr_zconv2S(sx,h,m)

A=zeros(sx(1)*sx(2));
for j=1:sx(2)
    for i=1:sx(1)
        co=[i j];
        b0=getbasis(co,sx,h,m);
        b1=reshape(b0,[],1);
        
        A(:,sx(1)*(j-1)+i)=b1(:,1);
    end
end


end

% 生成基函数矩阵
function y=getbasis(co,sz,h,m)
power=log2(m(1,1));
h0=my_upsamp2df(h,power);

mid=(1+size(h0))/2;

shift=co-mid;

y=zeros(sz);

for j=1:size(h0,2)
    for i=1:size(h0,1)
        i1=mod(i+shift(1),sz(1));
        j1=mod(j+shift(2),sz(2));
        if 0==i1
            i1=sz(1);
        end
        if 0==j1
            j1=sz(2);
        end
        y(i1,j1)=y(i1,j1)+h0(i,j);
    end
end
end

function h=my_upsamp2df(h0, power)

[m,n]=size(h0);
R1=zeros(2^power*(m-1)+1,m);
R2=zeros(n,2^power*(n-1)+1);
for i=1:m
    R1(1+(i-1)*2^(power),i)=1;
end
for i=1:n
    R2(i,1+(i-1)*2^(power))=1;
end
h=R1*h0*R2;
end




