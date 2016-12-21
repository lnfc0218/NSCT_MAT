function H = mtr_conv2(sx, y)
%矩阵相乘实现conv2(A,B,'valid')的功能，a b是A的行/列数C=H*A(:)为conv2(A,B,'valid')
%的结果的列向量形式，C的维数为[a+ry-1,b+cy-1]
a=sx(1);
b=sx(2);
[ry, cy]=size(y);
if a<ry || b<cy
   H=[];
else
    y=rot90(y,2);
    H=zeros((a-ry+1)*(b-cy+1), a*b);
    % 查资料，如何改成稀疏形式
    y=[y;zeros(a-ry,cy)];
    for k1=1:a-ry+1
        y1=circshift(y, [k1-1, 0]);
        f1=[(y1(:))',zeros(1, (b-cy)*a)];   
        H(k1, :)=f1;
    end

    for k2=1:a-ry+1
        y2=circshift(y, [k2-1, 0]);
        f2=[zeros(1, (b-cy)*a), (y2(:))'];   
        H((b-cy)*(a-ry+1)+k2, :)=f2;  
    end
    if b-cy>2
        
       for i=2:b-cy
           
           for j=1:a-ry+1
               y3=circshift(y, [j-1, 0]);
               f3=[zeros(1, (i-1)*a),(y3(:))',zeros(1, (b-cy-(i-1))*a)];
               H((i-1)*(a-ry+1)+j, :)=f3;
           end
       end
    end
    
end
%输出时
%    c=H*A(:)
%C=reshape(c,a-ry+1,b-cy+1)=conv2(A,B,'valid')