function calculate(cellmachine)
%主义cost_input要特别大
    open_list=cellmachine.door_position;
    for i=1:size(open_list,1)
        cellmachine.cellmap{open_list(i,1),open_list(i,2)}.cost=0.1;
    end   
    
    while size(open_list,1)>0
        c=cellmachine.cellmap{open_list(1,1),open_list(1,2)}.cost;
        i=open_list(1,1);j=open_list(1,2);
        if i>1&&j>1
            if cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)-1}.category~=2
                if cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)-1}.cost>1+c
                    cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)-1}.cost=c+1;
                    open_list=[open_list;[open_list(1,1)-1,open_list(1,2)-1]];
                end
            end
        end
        
       if i>1
            if cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)}.category~=2
                if cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)}.cost>1+c
                    cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)}.cost=c+1;
                    open_list=[open_list;[open_list(1,1)-1,open_list(1,2)]];
                end
            end
        end
        
        if i>1&&j<cellmachine.N
            if cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)+1}.category~=2
                if cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)+1}.cost>1+c
                    cellmachine.cellmap{open_list(1,1)-1,open_list(1,2)+1}.cost=c+1;
                    open_list=[open_list;[open_list(1,1)-1,open_list(1,2)+1]];
                end
            end
        end
        
        if j>1
            if cellmachine.cellmap{open_list(1,1),open_list(1,2)-1}.category~=2
                if cellmachine.cellmap{open_list(1,1),open_list(1,2)-1}.cost>1+c
                    cellmachine.cellmap{open_list(1,1),open_list(1,2)-1}.cost=c+1;
                    open_list=[open_list;[open_list(1,1),open_list(1,2)-1]];
                end
            end
        end
        
        if j<cellmachine.N
            if cellmachine.cellmap{open_list(1,1),open_list(1,2)+1}.category~=2
                if cellmachine.cellmap{open_list(1,1),open_list(1,2)+1}.cost>1+c
                    cellmachine.cellmap{open_list(1,1),open_list(1,2)+1}.cost=c+1;
                    open_list=[open_list;[open_list(1,1),open_list(1,2)+1]];
                end
            end
        end
        
        if i<cellmachine.M&&j>1
            if cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)-1}.category~=2
                if cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)-1}.cost>1+c
                    cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)-1}.cost=c+1;
                    open_list=[open_list;[open_list(1,1)+1,open_list(1,2)-1]];
                end
            end
        end
        
       if i<cellmachine.M
            if cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)}.category~=2
                if cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)}.cost>1+c
                    cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)}.cost=c+1;
                    open_list=[open_list;[open_list(1,1)+1,open_list(1,2)]];
                end
            end
        end
        
        if i<cellmachine.M&&j<cellmachine.N
            if cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)+1}.category~=2
                if cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)+1}.cost>1+c
                    cellmachine.cellmap{open_list(1,1)+1,open_list(1,2)+1}.cost=c+1;
                    open_list=[open_list;[open_list(1,1)+1,open_list(1,2)+1]];
                end
            end
        end        
        open_list(1,:)=[];      
    end
end
