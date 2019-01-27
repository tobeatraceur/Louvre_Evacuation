classdef multistairs < handle
    
    properties
        cellmachines;%���¥��  n*1
        elevator_position%¥��λ��
        waiting_list;%n-1���Ⱥ����(���󹹳ɵ�Ԫ��)
        
        epoch=10;%��������
    end
    
    methods
        function obj = multistairs(num)%����¥����
            %��һ��
            map=draw();
            obj.cellmachines{1}=cellmachine(map);
            
            %Ĭ�ϳ����ڵ�һ��
            obj.elevator_position=[[63,71];[36,71];[31,165];[70,165]];
            
            
            %�����ţ����ݣ�
            %û��Ӧ����Ա��Ӧ������
            for i=2:num
                for j=1:size(obj.cellmachines{1}.door_position,1)
                    map(obj.cellmachines{1}.door_position(j,1),obj.cellmachines{1}.door_position(j,2))=0;
                end
                obj.cellmachines{i}.door_position=obj.elevator_position;
                for j=1:size(obj.elevator_position,1)
                    map(obj.elevator_position(j,1),obj.elevator_position(j,2))=3;
                end
                obj.cellmachines{i}=cellmachine(map);
                obj.cellmachines{i}.target=[];
                obj.cellmachines{i}.cellmap{obj.cellmachines{i}.start_door(1),obj.cellmachines{i}.start_door(2)}.category=0;
                obj.cellmachines{i}.start_door=[];
                obj.cellmachines{i}.security_position=[];
                obj.cellmachines{i}.arrived_flag=1;
            end
            %��ʼ���Ⱥ����
            for i=1:num-1
                obj.waiting_list{i}=[];
            end
        end
        
        
        
        function one_iteration(obj,time)
            %ÿ��Ԫ������һ�֣���ֱ������Ԫ�������յ㣩
            %����һ��/������Ϣ��
            step = 0;
            %����һ��
            max_step = 150;
            while step < max_step %һ������
                for k=size(obj.cellmachines,2):-1:1
                    if obj.cellmachines{k}.peoplenum_now == 0
                        step
                        break;
                    end
                    if k~=size(obj.cellmachines,2)%��waitinglist���������
                        if size(obj.waiting_list{k},1)~=0
                            for j=1:size(obj.waiting_list{k},1)
                                if obj.cellmachines{k}.cellmap{obj.waiting_list{k}(j,1),obj.waiting_list{k}(j,2)}.category==0
                                    obj.cellmachines{k}.cellmap{obj.waiting_list{k}(j,1),obj.waiting_list{k}(j,2)}.category=1;
                                    obj.cellmachines{k}.people_position=[obj.cellmachines{k}.people_position;obj.waiting_list{k}(j,1),obj.waiting_list{k}(j,2)];
                                    obj.cellmachines{k}.peoplenum_total=obj.cellmachines{k}.peoplenum_total+1;
                                    obj.cellmachines{k}.peoplenum_now=obj.cellmachines{k}.peoplenum_now+1;
                                    s=size(obj.cellmachines{k}.people_position,1);
                                    obj.cellmachines{k}.path{s}=[obj.waiting_list{k}(j,1),obj.waiting_list{k}(j,2)];
                                    
                                    %obj.cellmachines{k}.count=[obj.cellmachines{k}.count;zeros(1,obj.cellmachines{k}.M,obj.cellmachines{k}.N,8)];
                                end
                            end
                        end
                    end
                    last_num=obj.cellmachines{k}.peoplenum_now;
                    drawmap(obj.cellmachines{k},k,size(obj.cellmachines,2));
                    obj.cellmachines{k}.one_step(time,step);
                    step = step + 1;
                    num_change=last_num-obj.cellmachines{k}.peoplenum_now;%����һ���߳�ȥ������
                    if num_change>0&&k~=1%���waitinglist
                        [~,find_person]=sort(double(obj.cellmachines{k}.people_position(:,2) == -1),'descend');
                        for j=1:num_change
                            obj.waiting_list{k-1}=[obj.waiting_list{k-1};[obj.cellmachines{k}.path{find_person(j)}(end,1),obj.cellmachines{k}.path{find_person(j)}(end,2)]];
                        end
                    end
                end
            end
            for k=1:size(obj.cellmachines,2)
                %step
                %�ӷ���Ϣ��
                for i=1:size(obj.cellmachines{k}.cellmap,1)
                    for kk=1:size(obj.cellmachines{k}.cellmap,2)
                        for j=1:8
                            obj.cellmachines{k}.cellmap{i,kk}.info(j)=(1-obj.cellmachines{k}.ro) * obj.cellmachines{k}.cellmap{i,kk}.info(j);
                        end
                    end
                end
                
                
                %�޸�·���ϵ���Ϣ��
                %change = 0;
                visited = zeros(obj.cellmachines{k}.M,obj.cellmachines{k}.N,obj.cellmachines{k}.M,obj.cellmachines{k}.N);
                for i=1:size(obj.cellmachines{k}.people_position,1)
                    for j=1:size(obj.cellmachines{k}.path{i},1)-1
                        if obj.cellmachines{k}.path{i}(j,1) == obj.cellmachines{k}.path{i}(j+1,1) && obj.cellmachines{k}.path{i}(j,2) == obj.cellmachines{k}.path{i}(j+1,2)
                            continue;
                        end
                        if visited(obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2),obj.cellmachines{k}.path{i}(j+1,1),obj.cellmachines{k}.path{i}(j+1,2)) == 1
                            continue;
                        end
                        num = 0;
                        if obj.cellmachines{k}.path{i}(j,1)-1 == obj.cellmachines{k}.path{i}(j+1,1)
                            if obj.cellmachines{k}.path{i}(j,2)-1 == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 1;
                            end
                            if obj.cellmachines{k}.path{i}(j,2) == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 2;
                            end
                            if obj.cellmachines{k}.path{i}(j,2)+1 == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 3;
                            end
                        end
                        if obj.cellmachines{k}.path{i}(j,1) == obj.cellmachines{k}.path{i}(j+1,1)
                            if obj.cellmachines{k}.path{i}(j,2)-1 == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 8;
                            end
                            if obj.cellmachines{k}.path{i}(j,2) == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 0;
                            end
                            if obj.cellmachines{k}.path{i}(j,2)+1 == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 4;
                            end
                        end
                        if obj.cellmachines{k}.path{i}(j,1)+1 == obj.cellmachines{k}.path{i}(j+1,1)
                            if obj.cellmachines{k}.path{i}(j,2)-1 == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 7;
                            end
                            if obj.cellmachines{k}.path{i}(j,2) == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 6;
                            end
                            if obj.cellmachines{k}.path{i}(j,2)+1 == obj.cellmachines{k}.path{i}(j+1,2)
                                num = 5;
                            end
                        end
                        
                        %����ͬ,�ͷ�
                        if  obj.cellmachines{k}.count(i,obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2),num) >= 10
                            %obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(max_step+1,1),obj.cellmachines{k}.path{i}(max_step+1,2)}.category = 0;
                            %obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(end,1),obj.cellmachines{k}.path{i}(end,2)}.category = 0;
                            obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2)}.info(num) = obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2)}.info(num) * (1-obj.cellmachines{k}.ro);
                            continue;
                        end
                        
                        
                        
                        delta_info = 0;
                        for kk=1:size(obj.cellmachines{k}.people_position,1)
                            %change = change + 1
                            %n=0;%nΪ��·����k����˵�·���г��ֵĴ���
                            %for m=2:size(obj.cellmachines{k}.path{k},1)-1
                            % if obj.cellmachines{k}.path{k}(m,1) == obj.cellmachines{k}.path{i}(j,1) && obj.cellmachines{k}.path{k}(m,2) == obj.cellmachines{k}.path{i}(j,2)
                            %if (obj.cellmachines{k}.path{k}(m-1,1) == obj.cellmachines{k}.path{i}(j+1,1) && obj.cellmachines{k}.path{k}(m-1,2) == obj.cellmachines{k}.path{i}(j+1,2)) || (obj.cellmachines{k}.path{k}(m+1,1) == obj.cellmachines{k}.path{i}(j+1,1) && obj.cellmachines{k}.path{k}(m+1,2) == obj.cellmachines{k}.path{i}(j+1,2))
                            % n = n + 1;
                            %end
                            %end
                            %end
                            %n = obj.cellmachines{k}.count(k,obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2),obj.cellmachines{k}.path{i}(j+1,1),obj.cellmachines{k}.path{i}(j+1,2)) + obj.cellmachines{k}.count(k,obj.cellmachines{k}.path{i}(j+1,1),obj.cellmachines{k}.path{i}(j+1,2),obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2));
                            num_reverse = mod(num+4,8);
                            if num_reverse == 0
                                num_reverse = 8;
                            end
                            %aa=obj.cellmachines{k}.path{i}(j,1);
                            %bb=obj.cellmachines{k}.path{i}(j,2);
                            %cc=obj.cellmachines{k}.path{i}(j+1,1);
                            %dd=obj.cellmachines{k}.path{i}(j+1,2);
                            %n = obj.cellmachines{k}.count(kk,aa,bb,num) + obj.cellmachines{k}.count(kk,cc,dd,num_reverse);
                            n = obj.cellmachines{k}.count(kk,obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2),num) + obj.cellmachines{k}.count(kk,obj.cellmachines{k}.path{i}(j+1,1),obj.cellmachines{k}.path{i}(j+1,2),num_reverse);
                            
                            if n ~= 0
                                delta_info = delta_info + 1/size(obj.cellmachines{k}.path{kk},1)*0.5^(n-1);
                            end
                        end
                        visited(obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2),obj.cellmachines{k}.path{i}(j+1,1),obj.cellmachines{k}.path{i}(j+1,2)) = 1;
                        visited(obj.cellmachines{k}.path{i}(j+1,1),obj.cellmachines{k}.path{i}(j+1,2),obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2)) = 1;
                        present_cell = obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(j,1),obj.cellmachines{k}.path{i}(j,2)};
                        present_cell.info(num) = present_cell.info(num) + delta_info;
                    end
                    
                    if obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(end,1),obj.cellmachines{k}.path{i}(end,2)}.category == 1
                        %obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(max_step+1,1),obj.cellmachines{k}.path{i}(max_step+1,2)}.category = 0;
                        obj.cellmachines{k}.cellmap{obj.cellmachines{k}.path{i}(end,1),obj.cellmachines{k}.path{i}(end,2)}.category = 0;
                    end
                    
                end
            end
        end
        
        function run(obj)
            total_num=0;
            for k=1:size(obj.cellmachines,2)
                total_num=total_num+obj.cellmachines{k}.peoplenum_total;
            end
            %Ԫ���Զ���������
            %
            for i = 1:obj.epoch
                i
                for k=size(obj.cellmachines,2):-1:1
                    obj.cellmachines{k}.count = zeros(total_num,obj.cellmachines{k}.M,obj.cellmachines{k}.N,8);
                end
                obj.one_iteration(i);
                for k=size(obj.cellmachines,2):-1:1
                    obj.cellmachines{k}.path = {};
                    for j=1:size(obj.cellmachines{k}.start_position,1)
                        obj.cellmachines{k}.path{j} = [obj.cellmachines{k}.start_position(j,1),obj.cellmachines{k}.start_position(j,2)];
                    end
                    obj.cellmachines{k}.people_position = obj.cellmachines{k}.start_position;
                    obj.cellmachines{k}.peoplenum_now = obj.cellmachines{k}.peoplenum_total;
                    obj.cellmachines{k}.count = zeros(obj.cellmachines{k}.peoplenum_total,obj.cellmachines{k}.M,obj.cellmachines{k}.N,8);
                    %obj.count = [];
                end
            end
            
        end
    end
end

