classdef cellmachine < handle
    %CELLMACHINE �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        cellmap;%mycell���ɵ�Ԫ��
        M;
        N;%��ͼ��С
        
        peoplenum_total;%������
        peoplenum_now;%���ڵ�����
        
        people_position;%�˵ĵ�ǰ����
        start_position;%�˵ĳ�ʼ����
        door_position;%�ŵĳ�ʼ����
        wall_position;%ǽ�ĳ�ʼ����
        target=[2,8];%Ӧ����ԱĿ�ĵ�
        
        path;%��¼ÿһ���˵�·��
        count;%��¼·�������Ĵ���
        
        ro=0.05;%�ӷ�ϵ��
        epoch=13;%��������
        
    end
    
    methods
        function obj = cellmachine(varargin)
            %����һ��Ԫ���Զ���
            %�������˵ķֲ���ǽ�ķֲ����ŵķֲ�
            if nargin==1
                map=varargin{1};
                obj.start_position=[];%�˵ĳ�ʼ����
                obj.people_position=[];
                obj.door_position=[];%�ŵĳ�ʼ����
                obj.wall_position=[];
                for i=1:size(map,1)
                    for j=1:size(map,2)
                        if(map(i,j)==3)%��
                            obj.door_position=[obj.door_position;[i,j]];
                        end
                        if(map(i,j)==0)%ǽ
                            obj.wall_position=[obj.wall_position;[i,j]];
                        end                             
                    end
                end
                obj.M=size(map,1);
                obj.N=size(map,2);
                
                peoplenum=10;%һ������Ϊ��������3600���Ķ��ٷ�֮һ
                N=randperm(obj.M*obj.N,ceil(obj.M*obj.M/peoplenum));
            end
            
            
            

            
            %���ó�ʼ����
            if  nargin==0
                obj.start_position=[3,3;5,5;4,4;6,6;7,7;8,8;3,4;4,5;5,6;6,7;7,8;8,9;3,9;4,8;5,7;7,5;8,4;9,3;9,6;2,9];%�˵ĳ�ʼ����
                obj.people_position=[3,3;5,5;4,4;6,6;7,7;8,8;3,4;4,5;5,6;6,7;7,8;8,9;3,9;4,8;5,7;7,5;8,4;9,3;9,6;2,9];
                obj.door_position=[10,8;1,2];%�ŵĳ�ʼ����
                obj.wall_position=[2,2;3,2;4,2;5,2];%ǽ�ĳ�ʼ����
                obj.M=10;
                obj.N=10;%�ߺͿ�
            end
            
            
            %�յس�ʼ��
            for i=1:obj.M
                for j=1:obj.N
                    obj.cellmap{i,j}=mycell(i,j,0,obj.M+obj.N,0.5,1);%����Ӱ�����Ӷ���ʼ��Ϊ0.5
                    for k=1:size(obj.door_position,1)
                        distance=abs(i-obj.door_position(k,1))+abs(j-obj.door_position(k,2));
                        if distance<obj.cellmap{i,j}.cost
                            obj.cellmap{i,j}.cost=distance;
                        end
                    end
                end
            end
            
            %��ʼ���ˡ��š�ǽ
            for i=1:size(obj.people_position,1)
                obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)}.category=1;
            end
            for i=1:size(obj.door_position,1)
                obj.cellmap{obj.door_position(i,1),obj.door_position(i,2)}.category=3;
            end
            for i=1:size(obj.wall_position,1)
                obj.cellmap{obj.wall_position(i,1),obj.wall_position(i,2)}.category=2;
            end
            
            for k=1:obj.M*obj.M/peoplenum
                temp_n=mod(N(k),obj.N);
                if temp_n==0
                    temp_n=obj.N;
                end
                if obj.cellmap{ceil(N(k)/obj.N),temp_n}.category==0
                    obj.people_position=[obj.people_position;[ceil(N(k)/obj.N),temp_n]];
                    obj.start_position=[obj.start_position;[ceil(N(k)/obj.N),temp_n]];
                    obj.cellmap{ceil(N(k)/obj.N),temp_n}.category=1;
                end
            end
            
            
            %·����ʼ��
            for i=1:size(obj.people_position,1)
                obj.path{i} = [obj.people_position(i,1),obj.people_position(i,2)];
            end
            obj.peoplenum_total=size(obj.people_position,1);
            obj.peoplenum_now=size(obj.people_position,1);
            obj.count = false(obj.peoplenum_total,obj.M,obj.N,8);
            %obj.count = false(obj.peoplenum_total,obj.M,obj.N,obj.M,obj.N);
        end
        
        function one_step(obj,first_flag,step_flag)%first_flagΪ�ִΣ�step_flagΪ����
            %ÿ��Ԫ��������һ��
            %��ÿһ��Ԫ�����ü��㺯��/��ͻ����/�����˵�λ��/��¼·��

            for i = 1:size(obj.people_position,1)
                if obj.people_position(i,1)==-1
                    continue;
                end
                    
                cost=obj.M*obj.N*ones(8,1);
                if obj.people_position(i,1)-1>0 && obj.people_position(i,2)-1>0
                    cost(1)=obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)-1}.cost;
                end
                if obj.people_position(i,1)-1>0
                    cost(2)=obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)}.cost;
                end
                if obj.people_position(i,1)-1>0 && obj.people_position(i,2)+1<=obj.N
                    cost(3)=obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)+1}.cost;
                end
                if obj.people_position(i,2)-1>0
                    cost(8)=obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)-1}.cost;
                end
                if  obj.people_position(i,2)+1<=obj.N
                    cost(4)=obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)+1}.cost;
                end
                if obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)-1>0
                    cost(7)=obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)-1}.cost;
                end
                if obj.people_position(i,1)+1<=obj.M
                    cost(6)=obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)}.cost;
                end
                if obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)+1<=obj.N
                    cost(5)=obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)+1}.cost;
                end
                
                obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)}.walk_a_step(cost);
            end
            for i = 1:size(obj.people_position,1)
                %�����Ѿ���ȥ����
                if obj.people_position(i,1) == -1
                    continue;
                end

                present_cell = obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)};
                next_cell = present_cell;
                change_flag = 0;%�Ƿ�ı�λ��
                change_position = 0;%8������ʾ�ı�ķ���
                %��һ������ȡ���Ŵ���
                [~,num] = sort(present_cell.next_step,'descend');%numΪ�����е���ţ�����һ���ķ���
                if first_flag == 1 || first_flag == obj.epoch || mod(step_flag,4) ~= 0
                    for j = 1:8
                        if num(j) == 1 && obj.people_position(i,1)-1>0 && obj.people_position(i,2)-1>0
                            next_cell = obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)-1};
                        end
                        if num(j) == 2 && obj.people_position(i,1)-1>0 && obj.people_position(i,2)<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)};
                        end
                        if num(j) == 3 && obj.people_position(i,1)-1>0 && obj.people_position(i,2)+1<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)+1};
                        end
                        if num(j) == 4 && obj.people_position(i,1)>0 && obj.people_position(i,2)+1<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)+1};
                        end
                        if num(j) == 5 && obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)+1<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)+1};
                        end
                        if num(j) == 6 && obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)};
                        end
                        if num(j) == 7 && obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)-1>0
                            next_cell = obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)-1};
                        end
                        if num(j) == 8 && obj.people_position(i,1)>0 && obj.people_position(i,2)-1>0
                            next_cell = obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)-1};
                        end

                        if next_cell.category == 0 || next_cell.category == 3
                            change_flag = 1;
                            change_position = num(j);
                            break;
                        end
                    end
                    
                    
                %�ǵ�һ������    
                else
                
                    A=ones(1,100);%AΪ������
                    x=rand(1,100);
                    A(x<present_cell.next_step(1))=1;
                    sum_posibility = 0;
                    for j=1:7
                        sum_posibility = sum_posibility + present_cell.next_step(j);
                        A(x>=sum_posibility)=j+1;
                    end


                    position_tried = zeros(8,1);%����Ƿ��Թ�
                    %�ҵ�û��ռ�õ�Ŀ�ĵ�
                    %for j = 1:8
                    try_step = 0;
                    while sum(position_tried) < 8 && try_step < 30
                        result = A(randperm(100,1));
                        position_tried(result) = 1;
                        if result == 1 && obj.people_position(i,1)-1>0 && obj.people_position(i,2)-1>0
                            next_cell = obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)-1};
                        end
                        if result == 2 && obj.people_position(i,1)-1>0 && obj.people_position(i,2)<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)};
                        end
                        if result == 3 && obj.people_position(i,1)-1>0 && obj.people_position(i,2)+1<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)-1,obj.people_position(i,2)+1};
                        end
                        if result == 4 && obj.people_position(i,1)>0 && obj.people_position(i,2)+1<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)+1};
                        end
                        if result == 5 && obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)+1<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)+1};
                        end
                        if result == 6 && obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)<=obj.N
                            next_cell = obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)};
                        end
                        if result == 7 && obj.people_position(i,1)+1<=obj.M && obj.people_position(i,2)-1>0
                            next_cell = obj.cellmap{obj.people_position(i,1)+1,obj.people_position(i,2)-1};
                        end
                        if result == 8 && obj.people_position(i,1)>0 && obj.people_position(i,2)-1>0
                            next_cell = obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)-1};
                        end

                        if next_cell.category == 0 || next_cell.category == 3
                            change_flag = 1;
                            change_position = result;
                            break;
                        end
                        try_step = try_step + 1;
                    end
                    
                end
            
                if change_flag == 1
                    present_cell.category = 0;
                    out_flag = 0;%�Ƿ����
                    for k=1:size(obj.door_position,1)
                        if next_cell.x == obj.door_position(k,1) && next_cell.y == obj.door_position(k,2)
                            obj.people_position(i,1) = -1;
                            obj.people_position(i,2) = -1;
                            obj.peoplenum_now = obj.peoplenum_now - 1;
                            out_flag = 1;
                            obj.path{i} = [obj.path{i};[next_cell.x,next_cell.y]];
                            obj.count(k,present_cell.x,present_cell.y,change_position) = obj.count(k,present_cell.x,present_cell.y,change_position) + 1;
                            %obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) = obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) + 1;
                            break;
                        end
                    end
                    if out_flag == 0
                        next_cell.category = 1;
                        obj.people_position(i,1) = next_cell.x;
                        obj.people_position(i,2) = next_cell.y;
                        obj.path{i} = [obj.path{i};[next_cell.x,next_cell.y]];
                        %obj.count = [obj.count;[]]
                        obj.count(k,present_cell.x,present_cell.y,change_position) = obj.count(k,present_cell.x,present_cell.y,change_position) + 1;
                        %obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) = obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) + 1;
                    end            
                end                                  
            end            
        end
        
        function one_iteration(obj,time)
            %ÿ��Ԫ������һ�֣���ֱ������Ԫ�������յ㣩
            %����һ��/������Ϣ��
            step = 0;
            %����һ��
            max_step = 150;
            while step < max_step %һ������
                %�ӳٸ���info
                %if mod(step,1) == 0
                    %for i=1:size(obj.cellmap)
                        %for j=1:8
                            %obj.cellmap{i}.info_using(j) = obj.cellmap{i}.info(j);
                        %end
                    %end
                %end
                
                if obj.peoplenum_now == 0
                   step
                   break;
                end
                drawmap(obj)
                obj.one_step(time,step);
                step = step + 1;
                %step
            end    
            %�ӷ���Ϣ��
            for i=1:size(obj.cellmap,1)
                for j=1:8
                    obj.cellmap{i}.info(j)=(1-obj.ro) * obj.cellmap{i}.info(j);
                end
            end
            %�޸�·���ϵ���Ϣ��
            %change = 0;
            visited = zeros(obj.M,obj.N,obj.M,obj.N);
            for i=1:size(obj.people_position,1)
                for j=1:size(obj.path{i},1)-1
                    if obj.path{i}(j,1) == obj.path{i}(j+1,1) && obj.path{i}(j,2) == obj.path{i}(j+1,2)
                        continue;
                    end
                    if visited(obj.path{i}(j,1),obj.path{i}(j,2),obj.path{i}(j+1,1),obj.path{i}(j+1,2)) == 1 
                        continue;
                    end
                    num = 0;
                    if obj.path{i}(j,1)-1 == obj.path{i}(j+1,1)
                        if obj.path{i}(j,2)-1 == obj.path{i}(j+1,2)
                            num = 1;
                        end
                        if obj.path{i}(j,2) == obj.path{i}(j+1,2)
                            num = 2;
                        end
                        if obj.path{i}(j,2)+1 == obj.path{i}(j+1,2)
                            num = 3;
                        end                     
                    end
                    if obj.path{i}(j,1) == obj.path{i}(j+1,1)
                        if obj.path{i}(j,2)-1 == obj.path{i}(j+1,2)
                            num = 8;
                        end
                        if obj.path{i}(j,2) == obj.path{i}(j+1,2)
                            num = 0;
                        end
                        if obj.path{i}(j,2)+1 == obj.path{i}(j+1,2)
                            num = 4;
                        end                     
                    end
                    if obj.path{i}(j,1)+1 == obj.path{i}(j+1,1)
                        if obj.path{i}(j,2)-1 == obj.path{i}(j+1,2)
                            num = 7;
                        end
                        if obj.path{i}(j,2) == obj.path{i}(j+1,2)
                            num = 6;
                        end
                        if obj.path{i}(j,2)+1 == obj.path{i}(j+1,2)
                            num = 5;
                        end                     
                    end
                    
                    %����ͬ,�ͷ�
                    if obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category == 1 && obj.count(i,obj.path{i}(j,1),obj.path{i}(j,2),num) >= 5
                        %obj.cellmap{obj.path{i}(max_step+1,1),obj.path{i}(max_step+1,2)}.category = 0;
                        %obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category = 0;
                        obj.cellmap{obj.path{i}(j,1),obj.path{i}(j,2)}.info(num) = obj.cellmap{obj.path{i}(j,1),obj.path{i}(j,2)}.info(num) * (1-obj.ro)^5;
                        continue;
                    end
                    
                    
                    
                    delta_info = 0;
                    for k=1:size(obj.people_position,1)
                       %change = change + 1
                        %n=0;%nΪ��·����k����˵�·���г��ֵĴ���
                        %for m=2:size(obj.path{k},1)-1
                           % if obj.path{k}(m,1) == obj.path{i}(j,1) && obj.path{k}(m,2) == obj.path{i}(j,2)
                                %if (obj.path{k}(m-1,1) == obj.path{i}(j+1,1) && obj.path{k}(m-1,2) == obj.path{i}(j+1,2)) || (obj.path{k}(m+1,1) == obj.path{i}(j+1,1) && obj.path{k}(m+1,2) == obj.path{i}(j+1,2))
                                   % n = n + 1;
                                %end
                            %end
                        %end
                        %n = obj.count(k,obj.path{i}(j,1),obj.path{i}(j,2),obj.path{i}(j+1,1),obj.path{i}(j+1,2)) + obj.count(k,obj.path{i}(j+1,1),obj.path{i}(j+1,2),obj.path{i}(j,1),obj.path{i}(j,2));
                        num_reverse = mod(num+4,8);
                        if num_reverse == 0
                            num_reverse = 8;
                        end
                        n = obj.count(k,obj.path{i}(j,1),obj.path{i}(j,2),num) + obj.count(k,obj.path{i}(j+1,1),obj.path{i}(j+1,2),num_reverse);
                        
                        if n ~= 0
                            delta_info = delta_info + 1/size(obj.path{k},1)*0.5^(n-1);
                        end
                    end
                    visited(obj.path{i}(j,1),obj.path{i}(j,2),obj.path{i}(j+1,1),obj.path{i}(j+1,2)) = 1;
                    visited(obj.path{i}(j+1,1),obj.path{i}(j+1,2),obj.path{i}(j,1),obj.path{i}(j,2)) = 1;
                    present_cell = obj.cellmap{obj.path{i}(j,1),obj.path{i}(j,2)};
                    present_cell.info(num) = present_cell.info(num) + delta_info;
                end
                
                if obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category == 1
                        %obj.cellmap{obj.path{i}(max_step+1,1),obj.path{i}(max_step+1,2)}.category = 0;
                obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category = 0;
                end
                
            end
            
      
        end
        
        function run(obj)
            %Ԫ���Զ���������
            %
            for i = 1:obj.epoch
                i
                obj.one_iteration(i);
                obj.path = {};
                for j=1:size(obj.people_position,1)
                    obj.path{j} = [obj.start_position(j,1),obj.start_position(j,2)];
                end
                obj.people_position = obj.start_position;
                obj.peoplenum_now = obj.peoplenum_total;
                obj.count = false(obj.peoplenum_total,obj.M,obj.N,8);
                %obj.count = [];
            end
        end
        
    end
end

