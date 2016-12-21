function T=mtr_atrousc(sx,h,m)

A=mtr_zconv2S(sx,h,m);

xr=sx(1);
xc=sx(2);
[hr,hc]=size(h);
power=log2(m(1,1));

% 对边缘进行裁剪，使之同原输入图像尺寸相同
yr=xr+1-pow2(power)*hr;
T1=[zeros(yr,xr-yr-power*(hr-1)),eye(yr),zeros(yr,power*(hr-1))];
yc=xc+1-pow2(power)*hc;
T2=[zeros(xc-yc-power*(hc-1),yc);eye(yc);zeros(power*(hc-1),yc)];

T=kron(T2',T1)*A;

