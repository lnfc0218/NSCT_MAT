function [T,sz]=mtr_extend2(sx,ru,rd,cl,cr,extmod)


	           
rx=sx(1);
cx=sx(2);
    
switch extmod
    case 'per'
	I = getPerIndices(rx, ru, rd);
    T1=zeros(size(I,2),rx);
    for i=1:size(I,2)
        T1(i,I(1,i))=1;
    end
	
	I = getPerIndices(cx, cl, cr);
    T2=zeros(cx,size(I,2));
    for i=1:size(I,2)
        T2(I(1,i),i)=1;
    end
     
    T=kron(T2',T1);
    sz=[size(T1,1),size(T2,2)];
	
	
    otherwise
	error('Invalid input for EXTMOD')
end	

%----------------------------------------------------------------------------%
% ÄÚ²¿º¯Êý
%----------------------------------------------------------------------------%
function I = getPerIndices(lx, lb, le)

I = [lx-lb+1:lx , 1:lx , 1:le];

if (lx < lb) | (lx < le)
    I = mod(I, lx);
    I(I==0) = lx;
end