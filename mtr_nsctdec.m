function sy=mtr_nsctdec(sz, levels, dfilt, pfilt )
% NSSCDEC   Nonsubsampled Contourlet Transform Decomposition
% 非下采样轮廓波变换_分解部分
%
% 调用格式	sy=nsctdec(sx, levels, [dfilt, pfilt] )
%
% 输入:
%
%   sz:      
%       向量，输入二维图像矩阵的维度
%   levels:  
%       行向量，每级塔式分解对应的方向分解数（从粗略到精细）
%       如分解级数为0，则进行二维小波临界采样
%   dfilt:  
%       字符串，进行方向分解选择的滤波器
%       默认选项 'dmaxflat7'
%       详见 dfilters.m
%   pfilt:  
%       字符串，进行塔式分解选择的滤波器
%       默认选项 'maxflat'
%       详见 'atrousfilters.m'
%
%
% 输出:
%
%   sy:  
%       单元数组向量
%       将输入图像进行非下采样轮廓波分解的矩阵
%       y{1}为低通子带进行变换的矩阵
%       其他单元分别为该层塔式分解对应的带通方向子带进行变换的矩阵
%
% 排列方式：
%   对向量 nlevs=[l_J,...,l_2, l_1]且l_j >= 2.
%   Then for 对于塔式分解 j=1,...,J以及每级塔式分解对应的方向分解序数 k=1,...,2^l_j 
%       单元数组序号为：
%           y{J+2-j}{k}(n_1, n_2)
%       对应的轮廓波分解系数为2^j,方向序号为k
%       (n_1 * 2^(j+l_j-2), n_2 * 2^j) 对应 k <= 2^(l_j-1), 
%       (n_1 * 2^j, n_2 * 2^(j+l_j-2)) 对应 k > 2^(l_j-1).
%   序号 k 从1 到 2^l_j对应的方向为从135°开始
%   对于 k <= 2^(l_j-1)为顺时针旋转90°
%   对于 k > 2^(l_j-1)为逆时针旋转90°
%   （参见论文Fig. 3.(b)）
%
% See also:	ATROUSFILTERS, DFILTERS, NSCTREC, NSFBDEC, NSDFBDEC.



% 判断输入是否有效
%判断向量 levels 是否为数
if ~isnumeric( levels )
    error('The decomposition levels shall be integers');
end
if isnumeric( levels )
    % 判断向量 levels 是否为整数
    if round( levels ) ~= levels
        error('The decomposition levels shall be integers');
    end
end

% 读入塔式分解与方向分解选择的滤波器类型，如没有输入，转入默认值
if ~exist('dfilt', 'var')
    dfilt='dmaxflat7' ;
end;

if ~exist('pfilt', 'var')
    pfilt='maxflat' ; 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 生成扇形滤波器，平行四边形滤波器，塔式滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 建立单元数组
filters=cell(4,1) ;
% 取得钻石型滤波器
[h1, h2]=dfilters(dfilt, 'd');
% 根据非下采样要求改变尺度
h1=h1./sqrt(2) ;
h2=h2./sqrt(2) ;

% 通过调制生成扇形滤波器
filters{1}=modulate2(h1, 'c');
filters{2}=modulate2(h2, 'c'); 
 

% 钻石型滤波器，通过错切变换，生成平行四边形滤波器
[filters{3}, filters{4}]=parafilters( h1, h2 ) ;

%对 h1,h2 重新赋值
[h1, h2, ~, ~]=atrousfilters(pfilt); 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 非下采样轮廓波变换
% 树状滤波器组
% 非下采样塔式结构进行多尺度分解
% 非下采样方向滤波器组进行多方向分解
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 分解级数
clevels=length( levels ) ;
nIndex=clevels + 1 ;
% 初始化输出
sy=cell(1, nIndex) ;

% 初始化每层低通分量以便迭代
sxlo=speye(sz(1)*sz(2));


% 非下采样塔式分解
for i= 1 : clevels   
    
    
    % 非下采样轮廓波变换
    % 非下采样塔式分解
    [sx_lo, sx_hi]=mtr_nsfbdec(sz, h1, h2, i-1) ;
    
    sxhi=sx_hi*sxlo;
        
    if levels(nIndex-1) > 0     
        % 对带通图像进行非下采样方向分解
        sx_dir=mtr_nsdfbdec(sz, filters, levels(nIndex-1));
        sxhi_dir=cell(size(sx_dir));
        for i=1:size(sx_dir,2)
            sxhi_dir{i}=sx_dir{i}*sxhi;
        end
        
        sy{nIndex}=sxhi_dir ;
    else
        % 直接保存结果
        sy{nIndex}=sx_hi ;
    end
    
    % 更新非下采样金字塔的系数
    nIndex=nIndex - 1 ;
    
    % 准备下一次迭代
    sxlo=sx_lo*sxlo;
end

% 低通分量
sy{1}=sxlo;