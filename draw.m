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
map(20,41)=0;map(84,19)=0;map(62,71)=0;map(77,69)=0;map(69,89)=0;map(77,89)=0;map(38,159)=0;map(62,159)=0;map(69,21)=0;
map(31,123)=1;
imshow(map);
door=[[37,95];[37,94];[49,123];[50,123];[20,58];[20,57];[77,57];[77,58];[75,23];[75,24]];
%door=[[37,95];[37,94];[49,123];[50,123];[20,58];[20,57];[75,23];[75,24]];
%door=[[37,91];[37,92];[37,93];[62,91];[62,92];[62,93];[20,41];[72,41]];
for i=1:size(door,1)
    map(door(i,1),door(i,2))=3;
end


