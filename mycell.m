classdef mycell < handle
    %MYCELL �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        x;
        y;%Ԫ������
        
        category;%���0��ʾ�յأ�1��ʾ�ˣ�2��ʾ�ϰ��3��ʾ��,4��ʾ�·��أ�5��ʾӦ����Ա
        
        %Lk;%���۾���Ŀ���Զ��
        
        next_step;%8*1�����飬���˳��
        
        info;%8*1�����飬��Ϣ��
        info_using;%����ʹ�õ���Ϣ�أ��ӳٸ���
        
        cost;%��������ŵĴ���
        
        alfa;%��Ϣ��Ӱ������
        beta;%��������Ӱ������
    end
    
    methods
        function obj = mycell(startx,starty,category_input,cost_input,a,b)
            %����һ��Ԫ��������Ϊ[����x,����y,���]
            %���:0��ʾ�յأ�1��ʾ�ˣ�2��ʾ�ϰ��3��ʾ��
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
            %ÿ��Ԫ�������Լ���һ���Ľ��˳��
            %�õ����˳��next_step,8*1������,˳��Ϊ�����Ͻǿ�ʼ��˳ʱ��
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

