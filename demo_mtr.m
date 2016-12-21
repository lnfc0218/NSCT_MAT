len_cut=1:32;
sz=size(len_cut,2);
sz=[sz,sz];
T=mtr_nsctdec(sz,3);

H=T{1};
for i=2:size(T,2)
    for j=1:size(T{i},2)
        H=[H;T{i}{j}];
    end
end

x=imread('zoneplate.png');
x=im2double(x);
x=x(len_cut,len_cut);

x=reshape(x,[],1);
y=H*x;
y=reshape(y,size(len_cut,2),[]);
figure
imshow(y,[])


