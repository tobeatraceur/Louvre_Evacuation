classdef cellmachine < handle
    %CELLMACHINE 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        cellmap;%mycell构成的元胞
        M;
        N;%地图大小
        
        peoplenum_total;%总人数
        peoplenum_now;%现在的人数
        
        people_position;%人的当前坐标
        start_position;%人的初始坐标
        disable_position;%残疾人初始坐标
        door_position;%门的初始坐标
        wall_position;%墙的初始坐标
        target=[20,80;21,80;19,80;20,81;20,79;19,79;19,81;21,79;21,81];%应急人员目的地
        start_door=[30,165];%应急人员进入的门
        security_position;%应急人员当前坐标
        
        path;%记录每一个人的路径
        Lk;%记录步数
        count;%记录路径经过的次数
        
        ro=0.1;%挥发系数
        epoch=1;%迭代轮数
        
        arrived_flag = 0;%应急人员是否到达
        
    end
    
    methods
        function obj = cellmachine(varargin)
            %构建一个元胞自动机
            %进行了人的分布、墙的分布、门的分布
            if nargin==1
                map=varargin{1};
                obj.start_position=[];%人的初始坐标
                obj.people_position=[];
                obj.door_position=[];%门的初始坐标
                obj.wall_position=[];
                obj.disable_position=[];
                for i=1:size(map,1)
                    for j=1:size(map,2)
                        if(map(i,j)==3)%门
                            obj.door_position=[obj.door_position;[i,j]];
                        end
                        if(map(i,j)==0)%墙
                            obj.wall_position=[obj.wall_position;[i,j]];
                        end
                    end
                end
                
                obj.M=size(map,1);
                obj.N=size(map,2);
                
<<<<<<< HEAD
                peoplenum=4;%一层人数为容纳量（3600）的多少分之一
=======
                peoplenum=2;%一层人数为容纳量（3600）的多少分之一
>>>>>>> 8e82f95bd5f4e75b3cfaa4532fbd10931cf87f69
                N=randperm(obj.M*obj.N,ceil(obj.M*obj.N/peoplenum));
            end
            
            
            
            
            
            %设置初始坐标
            if  nargin==0
                obj.start_position=[3,3;5,5;4,4;6,6;7,7;8,8;3,4;4,5;5,6;6,7;7,8;8,9;3,9;4,8;5,7;7,5;8,4;9,3;9,6;2,9];%人的初始坐标
                obj.people_position=[3,3;5,5;4,4;6,6;7,7;8,8;3,4;4,5;5,6;6,7;7,8;8,9;3,9;4,8;5,7;7,5;8,4;9,3;9,6;2,9];
                obj.door_position=[10,8;1,2];%门的初始坐标
                obj.wall_position=[2,2;3,2;4,2;5,2];%墙的初始坐标
                obj.M=10;
                obj.N=10;%高和宽
            end
            
            
            %空地初始化
            for i=1:obj.M
                for j=1:obj.N
                    obj.cellmap{i,j}=mycell(i,j,0,3*obj.M+3*obj.N,0.5,0.5);%两个影响因子都初始化为0.5
                    %                    for k=1:size(obj.door_position,1)
                    %                        distance=abs(i-obj.door_position(k,1))+abs(j-obj.door_position(k,2));
                    %                        if distance<obj.cellmap{i,j}.cost
                    %                            obj.cellmap{i,j}.cost=distance;
                    %                        end
                    %                    end
                end
            end
            
            %初始化人、门、墙
            for i=1:size(obj.people_position,1)
                obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)}.category=1;
            end
            for i=1:size(obj.door_position,1)
                obj.cellmap{obj.door_position(i,1),obj.door_position(i,2)}.category=3;
            end
            for i=1:size(obj.wall_position,1)
                obj.cellmap{obj.wall_position(i,1),obj.wall_position(i,2)}.category=2;
            end
            
            for i=1:size(obj.target,1)
                obj.cellmap{obj.target(i,1),obj.target(i,2)}.category=4;
            end
            obj.cellmap{obj.start_door(1),obj.start_door(2)}.category=5;
            
            obj.security_position = obj.start_door;
            %}
            for k=1:obj.M*obj.N/peoplenum
                temp_n=mod(N(k),obj.N);
                if temp_n==0
                    temp_n=obj.N;
                end
                if obj.cellmap{ceil(N(k)/obj.N),temp_n}.category==0
                    obj.people_position=[obj.people_position;[ceil(N(k)/obj.N),temp_n]];
                    obj.start_position=[obj.start_position;[ceil(N(k)/obj.N),temp_n]];
                    
                    if mod(k,20) == 0
                        obj.cellmap{ceil(N(k)/obj.N),temp_n}.category=6;
                        obj.disable_position=[obj.disable_position;[ceil(N(k)/obj.N),temp_n]];
                    else
                        obj.cellmap{ceil(N(k)/obj.N),temp_n}.category=1;
                    end
                end
                
            end
            
            
            %路径初始化
            for i=1:size(obj.people_position,1)
                obj.Lk(i)=1;
                obj.path{i} = [obj.people_position(i,1),obj.people_position(i,2)];
            end
            obj.peoplenum_total=size(obj.people_position,1);
            obj.peoplenum_now=size(obj.people_position,1);
            obj.count = zeros(obj.peoplenum_total,obj.M,obj.N,8);
            %obj.count = false(obj.peoplenum_total,obj.M,obj.N,obj.M,obj.N);
            
            calculate(obj);
            
        end
        
        function one_step(obj,first_flag,step_flag)%first_flag为轮次，step_flag为步数
            for i=1:size(obj.people_position,1)
                if obj.people_position(i,1)~=-1
                    obj.Lk(i)=obj.Lk(i)+1;
                end
            end
            %每个元胞计算下一步
            %对每一个元胞调用计算函数/冲突处理/更新人的位置/记录路径
            
            
            %应急人员
            if first_flag == obj.epoch && obj.arrived_flag == 0
            %if true
                %cost = 500;%r认为500很大
                present_cell = obj.cellmap{obj.security_position(1),obj.security_position(2)};
                next_cell = present_cell;
                
                if present_cell.parent(1) ~= 0
                    if obj.cellmap{present_cell.parent(1),present_cell.parent(2)}.category == 0 || obj.cellmap{present_cell.parent(1),present_cell.parent(2)}.category == 4
                        next_cell = obj.cellmap{present_cell.parent(1),present_cell.parent(2)};
                    else
                        distance = [];
                        for i=-1:1
                            for j=-1:1
                                new_distance = abs(obj.security_position(1)+i-obj.target(1,1))+abs(obj.security_position(2)+j-obj.target(1,2));
                                distance=[distance,new_distance];
                            end
                        end
                        [~,num] = sort(distance);

                        for j = 1:9
                            if num(j) == 1 && obj.security_position(1)-1>0 && obj.security_position(2)-1>0
                                next_cell = obj.cellmap{obj.security_position(1)-1,obj.security_position(2)-1};
                            end
                            if num(j) == 2 && obj.security_position(1)-1>0 && obj.security_position(2)<=obj.N
                                next_cell = obj.cellmap{obj.security_position(1)-1,obj.security_position(2)};
                            end
                            if num(j) == 3 && obj.security_position(1)-1>0 && obj.security_position(2)+1<=obj.N
                                next_cell = obj.cellmap{obj.security_position(1)-1,obj.security_position(2)+1};
                            end
                            if num(j) == 4 && obj.security_position(1)>0 && obj.security_position(2)-1>=obj.N
                                next_cell = obj.cellmap{obj.security_position(1),obj.security_position(2)-1};
                            end

                            if num(j) == 6 && obj.security_position(1)<=obj.M && obj.security_position(2)+1<=obj.N
                                next_cell = obj.cellmap{obj.security_position(1),obj.security_position(2)+1};
                            end
                            if num(j) == 7 && obj.security_position(1)+1<=obj.M && obj.security_position(2)-1>0
                                next_cell = obj.cellmap{obj.security_position(1)+1,obj.security_position(2)-1};
                            end
                            if num(j) == 8 && obj.security_position(1)+1<=obj.M && obj.security_position(2)>0
                                next_cell = obj.cellmap{obj.security_position(1)+1,obj.security_position(2)};
                            end
                            if num(j) == 9 && obj.security_position(1)+1<=obj.M && obj.security_position(2)+1<=obj.N
                                next_cell = obj.cellmap{obj.security_position(1)+1,obj.security_position(2)+1};
                            end

                            if next_cell.category == 0 || next_cell.category == 4
                                %change_flag = 1;
                                %change_position = num(j);
                                break;
                            end
                        end
                    end
                    
                else
                    distance = [];
                    for i=-1:1
                        for j=-1:1
                            new_distance = abs(obj.security_position(1)+i-obj.target(1,1))+abs(obj.security_position(2)+j-obj.target(1,2));
                            distance=[distance,new_distance];
                        end
                    end
                    [~,num] = sort(distance);

                    for j = 1:9
                        if num(j) == 1 && obj.security_position(1)-1>0 && obj.security_position(2)-1>0
                            next_cell = obj.cellmap{obj.security_position(1)-1,obj.security_position(2)-1};
                        end
                        if num(j) == 2 && obj.security_position(1)-1>0 && obj.security_position(2)<=obj.N
                            next_cell = obj.cellmap{obj.security_position(1)-1,obj.security_position(2)};
                        end
                        if num(j) == 3 && obj.security_position(1)-1>0 && obj.security_position(2)+1<=obj.N
                            next_cell = obj.cellmap{obj.security_position(1)-1,obj.security_position(2)+1};
                        end
                        if num(j) == 4 && obj.security_position(1)>0 && obj.security_position(2)-1>=obj.N
                            next_cell = obj.cellmap{obj.security_position(1),obj.security_position(2)-1};
                        end

                        if num(j) == 6 && obj.security_position(1)<=obj.M && obj.security_position(2)+1<=obj.N
                            next_cell = obj.cellmap{obj.security_position(1),obj.security_position(2)+1};
                        end
                        if num(j) == 7 && obj.security_position(1)+1<=obj.M && obj.security_position(2)-1>0
                            next_cell = obj.cellmap{obj.security_position(1)+1,obj.security_position(2)-1};
                        end
                        if num(j) == 8 && obj.security_position(1)+1<=obj.M && obj.security_position(2)>0
                            next_cell = obj.cellmap{obj.security_position(1)+1,obj.security_position(2)};
                        end
                        if num(j) == 9 && obj.security_position(1)+1<=obj.M && obj.security_position(2)+1<=obj.N
                            next_cell = obj.cellmap{obj.security_position(1)+1,obj.security_position(2)+1};
                        end

                        if next_cell.category == 0 || next_cell.category == 4
                            %change_flag = 1;
                            %change_position = num(j);
                            break;
                        end
                    end
                end
                
                if next_cell.category == 4
                    step_flag
                    obj.arrived_flag = 1;
                else
                    next_cell.category = 5;
                    obj.cellmap{obj.security_position(1),obj.security_position(2)}.category = 5;
                    obj.security_position(1) = next_cell.x;
                    obj.security_position(2) = next_cell.y;
                end
                %if distance<cost
                    %cost=distance;
                %end
            end
            %应急人员部分结束
            
            %}
            for i = 1:size(obj.people_position,1)
                %已经出去的人
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
                
                if obj.people_position(i,1)==-1
                    continue;
                end
                
                
                present_cell = obj.cellmap{obj.people_position(i,1),obj.people_position(i,2)};
                next_cell = present_cell;
                change_flag = 0;%是否改变位置
                change_position = 0;%8个数表示改变的方向
<<<<<<< HEAD
=======
                
>>>>>>> 8e82f95bd5f4e75b3cfaa4532fbd10931cf87f69
                %{
                %残疾人不进行迭代
                if present_cell.category == 6 && present_cell.stay_time ~= 4
                    present_cell.stay_time = present_cell.stay_time + 1;
                    continue;
                end
                %}
                %if present_cell.category == 1 && present_cell.stay_time ~= 2
                %present_cell.stay_time = present_cell.stay_time + 1;
                %continue;
                %end
                
                
                out_flag = 0;%是否出门
                for k=1:size(obj.door_position,1)
                    if present_cell.x == obj.door_position(k,1) && present_cell.y == obj.door_position(k,2)
                        obj.people_position(i,1) = -1;
                        obj.people_position(i,2) = -1;
                        obj.peoplenum_now = obj.peoplenum_now - 1;
                        present_cell.category = 3;
                        out_flag = 1;
                        %obj.path{i} = [obj.path{i};[next_cell.x,next_cell.y]];
                        %obj.count(k,present_cell.x,present_cell.y,change_position) = obj.count(k,present_cell.x,present_cell.y,change_position) + 1;
                        %obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) = obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) + 1;
                        break;
                    end
                end
                %跳过已经出去的人
                if obj.people_position(i,1) == -1 || out_flag == 1
                    continue;
                end
                
                
                %第一步迭代取最优次优
                [~,num] = sort(present_cell.next_step,'descend');%num为在其中的序号，即下一步的方向
<<<<<<< HEAD
                %if first_flag == 1 || first_flag == obj.epoch || true
                if first_flag == 1 || first_flag == obj.epoch || mod(first_flag,2) ~= 0 || mod(step_flag,4) ~= 0
=======
                if first_flag == 1 || first_flag == obj.epoch || mod(step_flag,5) ~= 0
                %if  first_flag == obj.epoch || mod(step_flag,4) == 0||mod(step_flag,4) == 1
                    %if first_flag == 1 || first_flag == obj.epoch || mod(first_flag,4) == 0
>>>>>>> 8e82f95bd5f4e75b3cfaa4532fbd10931cf87f69
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
                    
                    
                    %非第一步迭代
                else
                    
                    A=ones(1,100);%A为掷骰子
                    x=rand(1,100);
                    A(x<present_cell.next_step(1))=1;
                    sum_posibility = 0;
                    for j=1:7
                        sum_posibility = sum_posibility + present_cell.next_step(j);
                        A(x>=sum_posibility)=j+1;
                    end
                    
                    
                    position_tried = zeros(8,1);%标记是否尝试过
                    %找到没被占用的目的地
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
                    
                    
                    %if out_flag == 0
                    if present_cell.category == 1
                        next_cell.category = 1;
                    end
                    if present_cell.category == 6
                        next_cell.category = 6;
                    end
                    present_cell.category = 0;
                    present_cell.stay_time = 0;
                    obj.people_position(i,1) = next_cell.x;
                    obj.people_position(i,2) = next_cell.y;
                    obj.path{i} = [obj.path{i};[next_cell.x,next_cell.y]];
                    %obj.count = [obj.count;[]]
                    obj.count(k,present_cell.x,present_cell.y,change_position) = obj.count(k,present_cell.x,present_cell.y,change_position) + 1;
                    %obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) = obj.count(k,present_cell.x,present_cell.y,next_cell.x,next_cell.y) + 1;
                    %end
                end
            end
        end
        
        function [time_05,time_075]=one_iteration(obj,time)
            %每个元胞迭代一轮，（直到所有元胞到达终点）
            %迭代一步/更新信息素
            step = 0;
            %迭代一轮
            max_step = 450;
            time_05=0;
            time_075=0;
            while step < max_step %一轮上限
                %while true
                %延迟更新info
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
                drawmap(obj,1,1)
                obj.one_step(time,step);
                step = step + 1;
                %step
                if obj.peoplenum_now<(0.5*obj.peoplenum_total)
                    if time_05==0
                        time_05=step;
                    end
                end
                if obj.peoplenum_now<(0.25*obj.peoplenum_total)
                    if time_075==0
                        time_075=step;
                    end
                end
            end
            
            
            
            %挥发信息素
            for i=1:size(obj.cellmap,1)
                for k=1:size(obj.cellmap,2)
                    for j=1:8
                        obj.cellmap{i,k}.info(j)=(1-obj.ro) * obj.cellmap{i,k}.info(j);
                        %obj.cellmap{i,k}.alfa = obj.cellmap{i,k}.alfa * 1.1;
                    end
                end
            end
            %修改路径上的信息素
            %change = 0;
            visited = zeros(obj.M,obj.N,obj.M,obj.N);
            for i=1:size(obj.people_position,1)
                %for j=1:size(obj.path{i},1)-1
                punish_flag = 0;%是否惩罚
                for j=size(obj.path{i},1)-1:-1:1
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
                    
                    %死胡同,惩罚
                    if  obj.count(i,obj.path{i}(j,1),obj.path{i}(j,2),num) >= 5 || punish_flag == 1
                        %obj.cellmap{obj.path{i}(max_step+1,1),obj.path{i}(max_step+1,2)}.category = 0;
                        %obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category = 0;
                        
                            obj.cellmap{obj.path{i}(j,1),obj.path{i}(j,2)}.info(num) = obj.cellmap{obj.path{i}(j,1),obj.path{i}(j,2)}.info(num) * (1-obj.ro)^2;
                        punish_flag = 1;
                        continue;
                    end
                    
                    
                    
                    delta_info = 0;
                    for k=1:size(obj.people_position,1)
                        %change = change + 1
                        %n=0;%n为该路径在k这个人的路径中出现的次数
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
                            delta_info = delta_info + 1/obj.Lk(k)/obj.Lk(k)*0.5^(n-1);
                        end
                    end
                    visited(obj.path{i}(j,1),obj.path{i}(j,2),obj.path{i}(j+1,1),obj.path{i}(j+1,2)) = 1;
                    visited(obj.path{i}(j+1,1),obj.path{i}(j+1,2),obj.path{i}(j,1),obj.path{i}(j,2)) = 1;
                    present_cell = obj.cellmap{obj.path{i}(j,1),obj.path{i}(j,2)};
                    present_cell.info(num) = present_cell.info(num) + delta_info;
                end
                
                if obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category == 1 || obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category == 6
                    %obj.cellmap{obj.path{i}(max_step+1,1),obj.path{i}(max_step+1,2)}.category = 0;
                    obj.cellmap{obj.path{i}(end,1),obj.path{i}(end,2)}.category = 0;
                end
                
            end
            
            
        end
        
        function run(obj)
            %元胞自动机的运行
            %
            time_05=[];
            time_075=[];
            for i = 1:obj.epoch
                
                i
                for j=1:size(obj.people_position,1)
                    obj.Lk(j)=1;
                end
                
                if i == obj.epoch 
                    obj.cellmap{obj.start_door(1),obj.start_door(2)}.category = 5;
                    obj.security_position = obj.start_door;
                    [~,~]=Astar(obj.cellmap)
                end
                
                [t05,t075]=obj.one_iteration(i);
                time_05=[time_05,t05];
                time_075=[time_075,t075];
                obj.path = {};
                for j=1:size(obj.people_position,1)
                    obj.path{j} = [obj.start_position(j,1),obj.start_position(j,2)];
                    for k=1:size(obj.disable_position,1)
                        if obj.start_position(j,1) == obj.disable_position(k,1) && obj.start_position(j,2) == obj.disable_position(k,2)
                            obj.cellmap{obj.start_position(j,1),obj.start_position(j,2)}.category = 6;
                        else
                            obj.cellmap{obj.start_position(j,1),obj.start_position(j,2)}.category = 1;
                        end
                    end
                    
                end
                obj.people_position = obj.start_position;
                obj.peoplenum_now = obj.peoplenum_total;
                obj.count = zeros(obj.peoplenum_total,obj.M,obj.N,8);
                
                
                %}
                %obj.count = [];
            end
            %保存信息素
            for i=1:obj.M
                for j=1:obj.N
                    cellinfo(i,j)=sum(obj.cellmap{i,j}.info(:));
                end
            end
            save('info','cellinfo');
            x=1:obj.epoch;
            figure(2);plot(x,time_05,'-*b',x,time_075,'-or');
        end
    end
end

