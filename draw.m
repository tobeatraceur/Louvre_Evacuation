function map=draw()
close all;clear;
big_size=5;
temp=imread('map2.png');
t=rgb2gray(temp);
p=t~=247;
se = strel('disk',2);%½á¹¹ÔªËØse
q=imopen(p,se);
ppp=bwlabel(q,8);
im=double(ppp==1);
map=double(imresize(im,1/big_size)>0.8);
imshow(map);
door=[[35,91];[62,91];[20,41];[72,41]];
for i=1:size(door,1)
    map(door(i,1),door(i,2))=3;
end


