function [p,c] = randomPlan(M,V,Dor,to_origin,speed,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8)
tdor = Dor;
%这里我们姑且认为所有订单的时间窗都是9小时
%即每辆车工作时间小于9小时
Timax = 9;
%我们以订单为单位随机分配，生成解决方案

%M,V分别为8辆车最大额定载重与容积,Dor为366个订单的基本信息

p = zeros(7,1000);   %8辆车的路径规划（以客户点为节点），即解决方案；
for i = 1 : 7
    for j = 1 : 1000
        p(i,j)  = -1;
    end
end
p(:,1) = 0; %所有车第一个客户都是配送中心，即起点
pn = zeros(7,1);    %记8辆车录路径节点的动态数组
pn = pn + 2;
c = 0;  %方案成本
%首先设置一个动态数组，存8辆车的剩余载重、容积、工作时间
T = zeros(7,1);
arrMV = [M;V];
arrMV = arrMV';

%路径方案
f = 1;  %flag
for i = 366 : -1 : 1
    while(f)    %订单选择车辆成功则跳出
        onum = unidrnd(i);  %随机选择一个订单
        cnum = unidrnd(7);  %随机选择一辆车

        if arrMV(cnum,1)-Dor(onum,2)<0 ||...
                arrMV(cnum,2)-Dor(onum,3)<0 ||...
                T(cnum)+distance(p(cnum,pn(cnum)-1),onum,tdor,to_origin,Tmatrix)/speed>Timax
            %即车如果加不上这个订单了
            %这个时候我们直接认为他满了，让他送出去，即下一个客户点直接回到起点
            if p(cnum,pn(cnum)-1) ~= 0  %避免记录这个订单这辆车虽然在起点是空的，也装不下的情况
                p(cnum,pn(cnum)) = 0;
                pn(cnum) = pn(cnum) + 1;
                              
                arrMV(:,1) = M; %相关参数重置
                arrMV(:,2) = V;
                T(cnum) = 0;
            end
        else    %即车目前正常状态，还可以送这个订单（因为有可能这个车装不下这个订单，所以这里还需要else）
            p(cnum,pn(cnum)) = Dor(onum,4);    %送该订单
            pn(cnum) = pn(cnum) + 1;
            arrMV(cnum,1) = arrMV(cnum,1) - Dor(onum,2); %相关参数设置
            arrMV(cnum,2) = arrMV(cnum,2) - Dor(onum,3);
            T(cnum) = T(cnum) + distance(p(cnum,pn(cnum)-1),onum,tdor,to_origin,Tmatrix)/speed;
            
            Dor(onum,:) = [];   %订单已装载，删除
            f = 0;
            
        end
    end
    f = 1;
end
c = charge(p,M,V,tdor,to_origin,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8);
end