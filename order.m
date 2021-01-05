%处理两日订单的数据

Dorder = zeros(366,4);  %所有订单的地理位置编号、货物重量、体积、本身编号

for j = 1 : 366
    Dorder(j,4) = j;
for i = 1 : 46
    if strcmp(cellstr(orderdata{j,5}), address{i,1})
        Dorder(j,1) = i;
        Dorder(j,2) = orderdata{j,3};
        Dorder(j,3) = orderdata{j,4};
        break;
    end
end
end