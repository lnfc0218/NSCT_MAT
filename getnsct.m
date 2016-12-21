function y=getnsct(x,A)

% 将生成矩阵与原图像相乘

sx=size(x);

x=reshape(x,[],1);

y=cell(size(A));
y{1,1}=reshape(A{1,1}*x,sx(1),sx(2));
for i=2:size(A,2)
    for j=1:size(A{i},2)
        y{i}{j}=reshape(A{i}{j}*x,sx(1),sx(2));
    end
end

