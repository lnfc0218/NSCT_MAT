function sy=mtr_efilter2(sx, f, extmod, shift)
% EFILTER2   2D Filtering with edge handling (via extension)
%
%  能进行边缘处理的二维滤波器
%   调用格式：
%       y=efilter2(x, f, [extmod], [shift])
%
% 输入:
%	sx:	
%       输入图像维度
%	f:	
%        二维滤波器
%	extmod:	
%       延拓类型（默认为'per'）
%	shift:	
%       指定卷积起始点，默认 [0 0]
%
% 输出:
%	y:	
%       对图像进行滤波的矩阵
%           表达式 Y(z1,z2)=X(z1,z2)*F(z1,z2)*z1^shift(1)*z2^shift(2)
%
%   注意：
%   	shift不得大于((size(f)-1)/2)
%       输出的维度与输入相同
%
% See also:	EXTEND2, SEFILTER2

if ~exist('extmod', 'var')
    extmod='per';
end

if ~exist('shift', 'var')
    shift=[0; 0];
end

% 周期延拓
sf=(size(f) - 1) / 2;

[sxext,sz]=mtr_extend2(sx, floor(sf(1)) + shift(1), ceil(sf(1)) - shift(1), ...
	       floor(sf(2)) + shift(2), ceil(sf(2)) - shift(2), extmod);

% 卷积，并裁剪边缘使之与输入图像尺寸相同
sy=mtr_conv2(sz,f);
sy=sy*sxext;