function [sy1, sy2]=mtr_nssfbdec( sx, f1, f2, mup )
% NSSFBDEC   Two-channel nonsubsampled filter bank decomposition with periodic extension.
%   双通道非下采样滤波（周期延拓）
%   NSSFBDEC 计算等效输入图像与经MUP进行上采样的分析滤波器F1和F2卷积的矩阵 
%   无下采样操作，因此为移不变运算
%  
%   调用格式：
%       mtr_nssfbdec( sx, f1, f2, [mup] )
%
% 输入:
%   sx:
%       图像矩阵维度
%	f1:	
%		上半通道滤波器
%	f2:	
%		下半通道滤波器
%   mup:
%       上采样矩阵或整数
%       整数对应可分离上采样
%
% 输出:
%	sy1:
%       上半子带变换矩阵 
%	sy2:
%       下半子带变换矩阵
%
%
% See also:     EFILTER2, ZCONV2, ZCONV2S.

               

% Check input
if ~exist('mup', 'var')
    % 周期延拓并进行卷积
    sy1=mtr_efilter2( sx, f1 );
    sy2=mtr_efilter2( sx, f2 );
    return ;
end
% 如无上采样
if isequal(mup,1)||isequal(mup,eye(2))
    % 周期延拓并进行卷积
    sy1=mtr_efilter2( sx, f1 );
    sy2=mtr_efilter2( sx, f2 );
    return ;
end

% 如mup为上采样矩阵
if isequal(size(mup),[2 2])
% 不可分离采样矩阵
    
    % 周期延拓并同不可分离滤波器进行卷积
    sy1=mtr_zconv2( sx, f1, mup );
    sy2=mtr_zconv2( sx, f2, mup );
    
elseif size(mup) == [1, 1]
% 可分离采样矩阵

    % 周期延拓并进行卷积
    mup=mup * eye(2) ;
    sy1=mtr_zconv2S ( sx, f1, mup );
    sy2=mtr_zconv2S ( sx, f2, mup ); 
        
else
    error('The upsampling parameter should be an integer or two-dimensional integer matrix!');
end



