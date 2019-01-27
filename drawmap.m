function drawmap(cellmachine,n,num)
%DRAWMAP 此处显示有关此函数的摘要
%n为当前显示第几层，num为一共的层数
h=5;
%figure;
im=zeros(h*cellmachine.M,h*cellmachine.N,3);
im=uint8(im);
for i=1:cellmachine.M
    for j=1:cellmachine.N
        if cellmachine.cellmap{i,j}.category==0
            im(i*h-h+1:i*h,j*h-h+1:j*h,1)=255;
            im(i*h-h+1:i*h,j*h-h+1:j*h,2)=255;
            im(i*h-h+1:i*h,j*h-h+1:j*h,3)=255;
        end
        
        if cellmachine.cellmap{i,j}.category==1
            im(i*h-h+2:i*h-1,j*h-h+2:j*h-1,1)=255;
            im(i*h-h+2:i*h-1,j*h-h+2:j*h-1,2)=0;
            im(i*h-h+2:i*h-1,j*h-h+2:j*h-1,3)=0;
        end
            
        if cellmachine.cellmap{i,j}.category==3
            im(i*h-h+1:i*h,j*h-h+1:j*h,1)=0;
            im(i*h-h+1:i*h,j*h-h+1:j*h,2)=255;
            im(i*h-h+1:i*h,j*h-h+1:j*h,3)=0;
        end
        
        if cellmachine.cellmap{i,j}.category==4
            im(i*h-h+1:i*h,j*h-h+1:j*h,1)=0;
            im(i*h-h+1:i*h,j*h-h+1:j*h,2)=0;
            im(i*h-h+1:i*h,j*h-h+1:j*h,3)=255;
        end
        
        if cellmachine.cellmap{i,j}.category==5
            im(i*h-h+1:i*h,j*h-h+1:j*h,1)=0;
            im(i*h-h+1:i*h,j*h-h+1:j*h,2)=255;
            im(i*h-h+1:i*h,j*h-h+1:j*h,3)=255;
        end
        
        if cellmachine.cellmap{i,j}.category==6
            im(i*h-h+1:i*h,j*h-h+1:j*h,1)=255;
            im(i*h-h+1:i*h,j*h-h+1:j*h,2)=0;
            im(i*h-h+1:i*h,j*h-h+1:j*h,3)=255;
        end
    end
end

    im_show=im;
    subplot(num,1,n);
    imshow(im_show);
    title(['floor ',num2str(n),' of ',num2str(num)]);
end
