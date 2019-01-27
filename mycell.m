classdef mycell < handle
    %MYCELL 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        x;
        y;%元胞坐标
        
        category;%类别，0表示空地，1表示人，2表示障碍物，3表示门,4表示事发地，5表示应急人员
        
        %Lk;%评价距离目标的远近
        
        next_step;%8*1的数组，解的顺序
        
        info;%8*1的数组，信息素
        info_using;%正在使用的信息素，延迟更新
        
        cost;%到最近的门的代价
        
        alfa;%信息素影响因子
        beta;%启发函数影响因子
    end
    
    methods
        function obj = mycell(startx,starty,category_input,cost_input,a,b)
            %定义一个元胞，参数为[坐标x,坐标y,类别]
            %类别:0表示空地，1表示人，2表示障碍物，3表示门
            obj.x = startx;
            obj.y = starty;
            obj.category = category_input;
            obj.cost = cost_input;
            obj.alfa = a;
            obj.beta = b;
            obj.info=ones(8,1);
            obj.info_using = obj.info;
            %obj.Lk = 0;
        end
        
        function walk_a_step(obj,cost_input)
            %每个元胞计算自己下一步的解的顺序
            %得到解的顺序：next_step,8*1的数组,顺序为从左上角开始，顺时针
            sum_cost = 0;
            for i=1:8
                sum_cost = sum_cost + obj.info(i)^obj.alfa * (1/(cost_input(i)+0.1))^obj.beta;
            end
            
            for i=1:8
                obj.next_step(i) = (obj.info(i)^obj.alfa * (1/(cost_input(i)+0.1))^obj.beta) / sum_cost;
            end
            
        end
    end
end

