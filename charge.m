function c = charge(p,M,V,Dor,to_origin,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8)
c = 0;  %该方案花费
arrMV = [M;V];
arrMV = arrMV'; %车的容量
for i = 1 : 7   %七辆车
    for j = 2 : 1000    %从第二个客户点开始（第一个为起始点）
        if p(i,j) == 0 || p(i,j) == -1    %某次配送结束
            dt = distance(p(i,j-1),0,Dor,to_origin,Tmatrix);
            c = c + C3(i) + C4(i) + C5(i) + ...
                arrMV(i,1)*C7 + arrMV(i,2)*C8 + ...
                dt*C1(i) + dt*C2(i);
            
            arrMV(:,1) = M; %相关参数重置
            arrMV(:,2) = V;
            if p(i,j) == -1
                break;
            end
        else
            arrMV(i,1) = arrMV(i,1) - Dor(p(i,j),2); %相关参数设置
            arrMV(i,2) = arrMV(i,2) - Dor(p(i,j),3);
            
            %计费
            if p(i,j-1)~=0 && Dor(p(i,j),1) ~= Dor(p(i,j-1),1)
                %新订单和上一个订单不在一个客户点才会有新的点位费等费用
                dt = distance(p(i,j),p(i,j-1),Dor,to_origin,Tmatrix);
                c = c + dt*C1(i) + dt*C2(i);
                if p(i,j-1) == 0
                    c = c + C6(1,i);
                else
                    c = c + C6(2,i);
                end
            end
        end
    end
end
end