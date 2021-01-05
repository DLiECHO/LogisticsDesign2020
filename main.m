%%
%车辆相关参数初始化；
%车辆型号：金杯、全顺、4.2、5.2、6.8、7.7、9.6，按序编号；
C1 = [0.5,0.8,1,1.5,1.5,2,2.5];   %耗电、燃油费用（单位：元/公里）；
C2 = [0.1,0.2,0.3,0.4,0.4,0.5,0.6];   %维护费用（单位：元/公里）；
C3 = [1,1,2,2.5,2.5,2.5,3];    %保险费用（单位：元/配送次数）;
C4 = [10,10,15,20,20,20,30];    %司机费用（单位：元/配送次数）;
C5 = [10,10,15,20,20,25,35];    %卸货费用（单位：元/配送次数）;
%（单位：元/第一个送货点、其他送货点）
C6 = [350,350,450,550,650,650,850;50,50,100,110,140,140,180];
C7 = 90;   %以吨位计价的机会成本
C8 = 30;    %以体积计价的机会成本

M1 = [2,3,6,10,13,15,25];  %车辆额定重量（吨）
V1 = [4,6,15,17,30,40,50];  %车辆额定容积（立方）

%算力有限，姑且认为每辆车工作时间均小于9小时
Timax = 9;

speed = 35; %平均车速（单位：公里/小时）
%%
%随机生成2000个解决方案
p2000 = zeros(2000,7,1000);
c2000 = zeros(2000,1);
for i = 1 : 2000
    [plan,cost] = randomPlan(M1,V1,Dorder,to_origin,speed,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8);
    p2000(i,:,:) = plan;
    c2000(i) = cost;
end
%%
%变异和交叉4000轮
tp2 = zeros(2000,7,1000);    %暂存
tc2 = zeros(2000,1);
tp = zeros(7,1000);

minc = zeros(1,4000);
meanc = zeros(1,4000);

for i = 1 : 4000
    %每轮保留前200名（成本最低的200名）；
    [tc2, index] = sort(c2000);
    for j = 1 : 200
        tp2(j,:,:) = p2000(index(j),:,:);
    end
    %自由交叉产生1600个方案
    %又由于每个方案中每个“码值”具有唯一性，两个不同的方案无法做传统的交叉
    %所以我们将交叉与变异操作结合得到新的操作，具体如下：
    for j = 201 : 1800
        p1 = unidrnd(2000);
        p2 = unidrnd(2000);
        while p1 == p2
            p2 = unidrnd(2000);
        end
        p1 = p2000(p1,:,:);
        p1 = reshape(p1,7,1000);
        p2 = p2000(p2,:,:);
        p2 = reshape(p2,7,1000);
        %由于订单数较多，我们首先选择20个点
        for k = 1 : 20
            tonum = unidrnd(366);   %生成随机点（订单）
            toindex1 = find(p1 == tonum);   %在p1方案中，找到该订单的位置
            tonum2 = p2(toindex1);  %在p2方案中，将上述“位置”代入，得到新订单
            
            while tonum2 == -1 || tonum2 == 0  %避免新订单不存在
                tonum = unidrnd(366);
                toindex1 = find(p1 == tonum);   %在p1方案中，找到该订单的位置
                tonum2 = p2(toindex1);  %在p2方案中，将上述“位置”代入，得到新订单
            end
            [toindex21,toindex22] = find(p2 == tonum);   %再在p2方案中，找到随机订单的位置
            [toindex31,toindex32] = find(p2 == tonum2);   %再在p2方案中，找到新订单的位置
            
            %将p2方案中两个订单位置互换
            p2(toindex21,toindex22) = tonum2;
            p2(toindex31,toindex32) = tonum;
            %互换后检查新方案是否合法
            flagp = 1;
            while flagp
                m2 = 0; v2 = 0; t2 = 0;  %toindex2所在的某次配送所消耗
                m3 = 0; v3 = 0; t3 = 0;  %toindex3所在的某次配送所消耗
                for m = toindex22 : -1 : 1
                    if p2(toindex21,m) == 0
                        break;
                    end
                    m2 = m2 + Dorder(p2(toindex21,m),2);
                    v2 = v2 + Dorder(p2(toindex21,m),3);
                    t2 = t2 + distance(p2(toindex21,m),p2(toindex21,m-1),Dorder,to_origin,Tmatrix)/speed;
                end
                for m = toindex22 : 1 : 1000
                    if p2(toindex21,m) == 0 || p2(toindex21,m) == -1
                        break;
                    end
                    m2 = m2 + Dorder(p2(toindex21,m),2);
                    v2 = v2 + Dorder(p2(toindex21,m),3);
                    t2 = t2 + distance(p2(toindex21,m),p2(toindex21,m+1),Dorder,to_origin,Tmatrix)/speed;
                end
                
                for m = toindex32 : -1 : 1
                    if p2(toindex31,m) == 0
                        break;
                    end
                    m3 = m3 + Dorder(p2(toindex31,m),2);
                    v3 = v3 + Dorder(p2(toindex31,m),3);
                    
                    t3 = t3 + distance(p2(toindex31,m),p2(toindex31,m-1),Dorder,to_origin,Tmatrix)/speed;
                end
                for m = toindex32 : 1 : 1000
                    if p2(toindex31,m) == 0 || p2(toindex31,m) == -1
                        break;
                    end
                    m3 = m3 + Dorder(p2(toindex31,m),2);
                    v3 = v3 + Dorder(p2(toindex31,m),3);
                    t3 = t3 + distance(p2(toindex31,m),p2(toindex31,m+1),Dorder,to_origin,Tmatrix)/speed;
                end
                flagp = 0;
                if m2 > M1(toindex21) || m3 > M1(toindex31) || v2 > V1(toindex21) || v3 > V1(toindex31) ...
                        || t2 > Timax || t3 > Timax
                    flagp = 1;  %不合法，重新互换
                    
                    tonum = unidrnd(366);   %生成随机点（订单）
                    toindex1 = find(p1 == tonum);   %在p1方案中，找到该订单的位置
                    tonum2 = p2(toindex1);  %在p2方案中，将上述“位置”代入，得到新订单
                    while tonum2 == -1 || tonum2 == 0 %避免新订单不存在
                        tonum = unidrnd(366);
                        toindex1 = find(p1 == tonum);   %在p1方案中，找到该订单的位置
                        tonum2 = p2(toindex1);  %在p2方案中，将上述“位置”代入，得到新订单
                    end
                    [toindex21,toindex22] = find(p2 == tonum);   %再在p2方案中，找到随机订单的位置
                    [toindex31,toindex32] = find(p2 == tonum2);   %再在p2方案中，找到新订单的位置

                    %将p2方案中两个订单位置互换
                    p2(toindex21,toindex22) = tonum2;
                    p2(toindex31,toindex32) = tonum;
                    
                end                
            end
        end
        
        tp2(j,:,:) = p2;
        tc2(j) = charge(p2,M1,V1,Dorder,to_origin,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8);
    end
    
    for j = 1801 : 2000  %最后再随机生成200个方案
        [tplan,tc] = randomPlan(M1,V1,Dorder,to_origin,speed,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8);
        tp2(j,:,:) = tplan;
        tc2(j) = tc;
    end
    
    p2000 = tp2;
    c2000 = tc2;
    
    disp(i);
    minc(i) = min(c2000);
    meanc(i) = mean(c2000);
end