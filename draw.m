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

door=[[36,91];[62,91]];
map(door(1,1),door(1,2))=3;
map(door(2,1),door(2,2))=3;

temp(:,:,1)=uint8(255)*uint8(im==1);
temp(:,:,2)=uint8(255)*uint8(im==1);
temp(:,:,3)=uint8(255)*uint8(im==1);

temp(big_size*door(1,1)-3:big_size*door(1,1)+3,big_size*door(1,2)-5:big_size*door(1,2)+5,1)=0;
temp(big_size*door(1,1)-3:big_size*door(1,1)+3,big_size*door(1,2)-5:big_size*door(1,2)+5,2)=uint8(255);
temp(big_size*door(1,1)-3:big_size*door(1,1)+3,big_size*door(1,2)-5:big_size*door(1,2)+5,3)=0;
temp(big_size*door(2,1)-3:big_size*door(2,1)+3,big_size*door(2,2)-5:big_size*door(2,2)+5,1)=0;
temp(big_size*door(2,1)-3:big_size*door(2,1)+3,big_size*door(2,2)-5:big_size*door(2,2)+5,2)=uint8(255);
temp(big_size*door(2,1)-3:big_size*door(2,1)+3,big_size*door(2,2)-5:big_size*door(2,2)+5,3)=0;
