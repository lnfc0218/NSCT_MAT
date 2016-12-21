% demo
% 本演示对32*32的图像矩阵进行3级NSCT变换
% 其输出为单元数组，其子带排列顺序见mtr_nsctdec,与Contourlet程序等效
%
% 可通过修改len_cut的来修改裁剪图像矩阵的大小和窗口位置



len_cut=1:32;
sz=size(len_cut,2);
sz=[sz,sz];
x=imread('zoneplate.png');
x=im2double(x);
x=x(len_cut,len_cut);

T=mtr_nsctdec(sz,3);% 获取变换矩阵
y=getnsct(x,T);% 根据变换矩阵生成含低通子带和带通方向子带的单元图像矩阵




