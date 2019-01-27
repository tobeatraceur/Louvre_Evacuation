function[open,close]=Astar(map)


[row,col]=size(map);

close=struct('row',-1,'col',-1,'g',0,'h',0);%????????????????????????

closelen=1;

open=struct('row',-1,'col',-1,'g',-1,'h',-1);%????????????????????????

openlen=0;

bindex=1;
%barrierrow;
%barriercol;
for k=1:row

   for j=1:col

       if map{k,j}.category==2

            barrierrow(bindex)=k;

            barriercol(bindex)=j;

            bindex=bindex+1;

       end

   end

end


for i=1:row

   for j=1:col

       if map{i,j}.category==5

            endrow=i;

            endcol=j;

           break;

       end

   end

end

%????????????????????close

for i=1:row

   for j=1:col

     if map{i,j}.category==4

          startrow=i;

          startcol=j;

          close(1).row=i;

          close(1).col=j;

         break;

     end

   end

end

%??????????????????open

%????????

direct=[0 -1;0 1;-1 0;1 0;1 -1;1 1;-1 -1;-1 1];

for i=1:8

   if all([close(1).row,close(1).col]+direct(i,:)>0) && close(1).row+direct(i,1)<=row && close(1).col+direct(i,2)<=col && map{close(1).row+direct(i,1),close(1).col+direct(i,2)}.category~=2

        open(openlen+1).row=close(1).row+direct(i,1);

        open(openlen+1).col=close(1).col+direct(i,2);

        openlen=openlen+1;

       %????g??????h????????

        open(openlen).g=1;

        open(openlen).h=abs(endrow-open(openlen).row)+abs(endcol-open(openlen).col);
        map{open(openlen).row,open(openlen).col}.parent = [close(1).row,close(1).col];

   end

end

% close

% open.h

 

%????????open??colse????????????????????????????????????

while openlen>0

   %????????????g+h????open????????

    min = realmax;

   for i=1:openlen

       if open(i).g+open(i).h<=min

            min=open(i).g+open(i).h;

            sindex=i;

       end

   end

   

   %??s????????close????????open??

    close(closelen+1).row=open(sindex).row;

    close(closelen+1).col=open(sindex).col;

    close(closelen+1).g=open(sindex).g;

    close(closelen+1).h=open(sindex).h;

    closelen=closelen+1;

%     openlen=openlen-1;

%     for i=sindex:openlen

%         open(i)=open(i+1);

%     end

%     open(openlen+1)=[];

openlen=0;

   

   %??????????

    %pause(0.3)  

   img = zeros(row,col);

   img(startrow,startcol)=10;

  for k=1:row

       for j=1:col

           if map{k,j}.category == 2

                %map{k,j}.category=5;
                img(k,j) = 5;

           end

       end

  end

   for k=2:closelen

        %img(close(k).row,close(k).col)=3;

   end

    img(endrow,endcol)=10;

    imagesc(img*10);

   

   %??????????????????????

   if close(closelen).row == endrow && close(closelen).col==endcol

       break;

   end

 

   %??????????????????????????????????????????open??

   for i=1:8

       if all([close(closelen).row,close(closelen).col]+direct(i,:)>0) && close(closelen).row+direct(i,1)<=row && close(closelen).col+direct(i,2)<=col && map{close(closelen).row+direct(i,1),close(closelen).col+direct(i,2)}.category~=2

          %????????????close??
          

           flag=false;

          for m=1:closelen

              if close(m).row==close(closelen).row+direct(i,1) && close(m).col==close(closelen).col+direct(i,2)

                   flag=true;

                  break;

              end

          end

          if flag

               continue;

          end

          

          %????????????open??

            flag=false;
            old = 0;

          for m=1:openlen

              if open(m).row==close(closelen).row+direct(i,1) && open(m).col==close(closelen).col+direct(i,2)

                   flag=true;
                   old = m;

                  break;

              end

          end

          if flag

               %more????????
               if close(closelen).g+ 1 +abs(endrow-(close(closelen).row+direct(i,1)))+abs(endcol-(close(closelen).row+direct(i,2))) < open(old).h + open(old).g
                   open(old).g = close(closelen).g+ 1;
                   open(old).h = abs(endrow-(close(closelen).row+direct(i,1)))+abs(endcol-(close(closelen).row+direct(i,2)));
                   map{close(closelen).row+direct(i,1),close(closelen).row+direct(i,2)}.parent = [close(closelen).row,close(closelen).col];
               end

               continue;

          else %open??????????

                open(openlen+1).row=close(closelen).row+direct(i,1);

                open(openlen+1).col=close(closelen).col+direct(i,2);

                openlen=openlen+1;

               %????g??????h????????

                open(openlen).g=close(closelen).g+1;

                open(openlen).h=abs(endrow-open(openlen).row)+abs(endcol-open(openlen).col);

                h=open(openlen).h
                map{open(openlen).row,open(openlen).col}.parent = [close(closelen).row,close(closelen).col];

          end 

       end

   end 
end

while true
       row = map{endrow,endcol}.parent(1);
       col = map{endrow,endcol}.parent(2);
       endrow = row;
       endcol = col;
       %[row,col]
       img(row, col) = 7;
       imagesc(img*10);
       if row == startrow && col == startcol
           break;
       end
end
