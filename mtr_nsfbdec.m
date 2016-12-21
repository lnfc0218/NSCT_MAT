function [sylo, syhi] = mtr_nsfbdec( sx, h0, h1, lev )

%  nsfbdec - computes the ns pyramid decomposition 
%   生成n级塔式分解的矩阵
%  调用格式 y = nsfbdec(x,h0,h1,L)
%  输入: 
%   sx: 
%       精细尺度图像的维度
%   h0, h1：
%       通过'atrousfilters' 生成的atrous滤波器
%  输出: 
%   sylo：
%      粗略尺度的图像
%   syhi:
%       精细尺度的图像
% 

%   SEE ALSO: ATROUSREC, ATROUSFILTERS

% 通过非下采样塔式分解，将 x 分解为等大小的高频和低频部分
% 对滤波器进行上采样而非对输入图像进行下采样


 
if lev ~= 0 
    I2 = eye(2); 
    shift = -2^(lev-1)*[1,1] + 2; % 延迟补偿
    L=2^lev;
    %***********************************************
    % 根据所在尺度，对滤波器进行上采样
    h_0=mtr_upsample2df(h0,lev);
    h_1=mtr_upsample2df(h1,lev);
    % 根据滤波器的长宽对输入数据进行对称延拓
    sh_0=size(h_0);
    sh_1=size(h_1);
    [sy_lo,sx0]=mtr_symext(sx,sh_0,shift);
    [sy_hi,sx1]=mtr_symext(sx,sh_1,shift);
    % 对经过对称延拓的数据进行卷积，去掉边缘，使输出同输入大小相同
    % 引入上一级操作的维度信息
    sylo=mtr_atrousc(sx0,h0,I2 * L);
    syhi=mtr_atrousc(sx1,h1,I2 * L); 
else
    % 第一级分解，对滤波器不做上采样
    % 直接对输入图像对称延拓，求完全卷积
    shift = [1, 1]; % 延迟补偿
    sh0=size(h0);
    sh1=size(h1);
    [sy_lo,sx0]=mtr_symext(sx,sh0,shift);
    [sy_hi,sx1]=mtr_symext(sx,sh1,shift);
    sylo=mtr_conv2(sx0,h0);
    syhi=mtr_conv2(sx1,h1);

end
% 将每级结果相乘并输出
sylo=sylo*sy_lo;
syhi=syhi*sy_hi;
  

