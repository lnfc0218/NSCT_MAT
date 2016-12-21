function A=mtr_zconv2(sx,h,m)


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

function y=getbasis(co,sz,h,m)

if isequal(m,[1 -1;1 1])
    h0=rot45(h);
else
    h0=my_upsamp2df(h,m);
end

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


function h=rot45(h0)
 
% rot45 - rotate input matrix h0 clockwise by 45 degrees
% 
% 将输入矩阵顺时针旋转45°
%
% q1=[1 -1;11];
% 

h=zeros(2*size(h0)-1);
[sz1,sz2]=size(h0);

for i=1:sz1
    
    r=i+(0:sz2-1);
    c=sz2-i+(1:sz2);
    
    for j=1:sz2

        h(r(j),c(j))=h0(i,j);
    end
end

end

function h=my_upsamp2df(h0, mup)
    

[m,n]=size(h0);

power=log2(mup(1,1));

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





