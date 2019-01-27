function drawinfo(cellmachine)
%显示一个元胞自动机的信息素
%
map=zeros(size(cellmachine.cellmap));
for i=1:size(cellmachine.cellmap,1)
    for j=1:size(cellmachine.cellmap,2)
        if cellmachine.cellmap{i,j}.category~=2
            map(i,j)=sum(cellmachine.cellmap{i,j}.info(:));
        end
    end
end
mymax=max(map(:));

for i=1:size(cellmachine.cellmap,1)
    for j=1:size(cellmachine.cellmap,2)
        if cellmachine.cellmap{i,j}.category==2
            map(i,j)=0;
        else
            map(i,j)=map(i,j)/mymax;
        end
    end
end
imshow(map);


map=1000*ones(size(cellmachine.cellmap));
for i=1:size(cellmachine.cellmap,1)
    for j=1:size(cellmachine.cellmap,2)
        if cellmachine.cellmap{i,j}.category~=2
            map(i,j)=sum(cellmachine.cellmap{i,j}.info(:));
        end
    end
end


mymin=min(map(:));
for i=1:size(cellmachine.cellmap,1)
    for j=1:size(cellmachine.cellmap,2)
        if cellmachine.cellmap{i,j}.category==2
            map(i,j)=0;
        else
            map(i,j)=(map(i,j)-mymin)/(mymax-mymin);
        end
    end
end
imshow(map);

imagesc(map);
set(gca,'YDir','normal')
c=colorbar;
colormap(jet);



end

