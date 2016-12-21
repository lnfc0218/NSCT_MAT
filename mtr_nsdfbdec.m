function sy=mtr_nsdfbdec( sx, dfilter, clevels )
% NSDFBDEC   Nonsubsampled directional filter bank decomposition.
%   非下采样方向滤波器组分解
%   生成对输入图像进行二叉树式非下采样方向分解的矩阵
%   因为不对图像进行下采样而具有移不变特性
%  
%   调用格式：    sy=nsdfbdec( sx, dfilter, [clevels] )
%
% 输入:
%   sx:
%       向量，输入图像维度
%   dfilter:	
%       字符串，进行方向分解选择的滤波器
%       生成两个方向滤波器和八个平行四边形滤波器
%   clevels:
%       非负整数，对应分解级数
%
% OUTPUT:
%	sy:
%       单元数组
%       输出子带
%
% See also:     DFILTERS, PARAFILTERS, mtr_nssfbdec.


% Input check
if ~exist('clevels', 'var')
    clevels=0 ;
    sy{1}=sx;
    return;
end
if (clevels ~= round(clevels)) || (clevels < 0)
    error('Number of decomposition levels must be a non-negative integer');
end
if clevels == 0
    % 不进行分解，直接输出
    sy{1}=sx;    
    return;
end
if ~ischar( dfilter )
    if iscell( dfilter )
        if length( dfilter ) ~= 4
            error('You shall provide a cell of two 2D directional filters and two groups of 2D parallelogram filters!');
        end
    else
        error('You shall provide the name of directional filter or all filters!');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 生成扇形滤波器、平行四边形滤波器和基本采样矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%如果输入非字符型，不走该条
if ischar( dfilter )
    
    % 取得钻石型滤波器
    [h1, h2]=dfilters(dfilter, 'd');
    % 非下采样尺度要求
    h1=h1./sqrt(2) ;
    h2=h2./sqrt(2) ;
    
    % 通过调制生成第一级扇形滤波器
    k1=modulate2(h1, 'c');
    k2=modulate2(h2, 'c'); 
    
    % 通过钻石型滤波器生成平行四边形滤波器
    [f1, f2]=parafilters( h1, h2 ) ;

else

    % k1, k2 为扇形滤波器
    k1=dfilter{1} ;
    k2=dfilter{2} ;
    

    % f1, f2 为平行四边形滤波器
    f1=dfilter{3} ;
    f2=dfilter{4} ;    
end 


% 五株采样矩阵，将原滤波器顺时针旋转45°
q1=[1, -1; 1, 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第一级分解
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if clevels == 1
    % 在第一级分解中，采用扇形滤波器组，不对滤波器进行操作
    [sy{1}, sy{2}]=mtr_nssfbdec( sx, k1, k2 ) ;        
    
else    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第二级分解
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 在第一级分解中，采用扇形滤波器组，不对滤波器进行操作
    [sx1, sx2]=mtr_nssfbdec( sx, k1, k2 ) ;

    % 在第二级分解中，对扇形滤波器组进行五株采样，得到象限滤波器组
    [sy{1}, sy{2}]=mtr_nssfbdec( sx, k1, k2, q1 ) ;
    [sy{3}, sy{4}]=mtr_nssfbdec( sx, k1, k2, q1 ) ;
    sy{1}=sy{1}*sx1;
    sy{2}=sy{2}*sx1;
    sy{3}=sy{3}*sx2;
    sy{4}=sy{4}*sx2;

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第三级以及更高级别的分解
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
    % 三级及以上分解
    for l=3:clevels
        % 为新子带预分配空间
        sy_old=sy;    
        sy=cell(1, 2^l);
	
        % 上半通道
        for k=1:2^(l-2)
            

            % 计算公式来自Minh N. Do的博士论文，公式(3.18)
            
            slk=2*floor( (k-1) /2 ) - 2^(l-3) + 1 ;
            mkl=2*[ 2^(l-3), 0; 0, 1 ]*[1, 0; -slk, 1]; 
            i=mod(k-1, 2) + 1;
            [sy{2*k-1}, sy{2*k}]=mtr_nssfbdec( sx, f1{i}, f2{i}, mkl );
            sy{2*k-1}=sy{2*k-1}*sy_old{k};
            sy{2*k}=sy{2*k}*sy_old{k};
        end	
	
        % 下半通道
        for k=2^(l-2)+1 : 2^(l-1)
            
            % 计算s_{(l-1)}(k):
            slk=2 * floor( ( k-2^(l-2)-1 ) / 2 ) - 2^(l-3) + 1 ;
            % 计算采样矩阵
            mkl=2*[ 1, 0; 0, 2^(l-3) ]*[1, -slk; 0, 1]; 
            i=mod(k-1, 2) + 3;
            % 通过两通道滤波器进行分解
            [sy{2*k-1}, sy{2*k}]=mtr_nssfbdec( sx, f1{i}, f2{i}, mkl );
            sy{2*k-1}=sy{2*k-1}*sy_old{k};
            sy{2*k}=sy{2*k}*sy_old{k};
        end
    end
end