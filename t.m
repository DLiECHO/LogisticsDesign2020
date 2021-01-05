%%
%三维矩阵
position = zeros(46,2);
for i = 1 : 46
   position(i,1) = ans{i,1};
   position(i,2) = ans{i,2}; 
end
Tmatrix = zeros(46,46,8);
%索引解释：起点 终点 出发时刻
    %时刻表：0 6 8 9 10 15 16 17
    %距离单位：千米
    
%%
%二维距离矩阵计算（经纬度换算）
temp = zeros(46,46);
for i = 1 : 46
    for j = 1 : 46
        temp(i,j) = distance(position(i,1),position(i,2),position(j,1),position(j,2))/180*pi*6371;
    end
end
temp = temp * 1.5;  %认为实际基本距离大约为直接距离的1.5倍

%%
%设定0点时的实际距离等于基本距离，而6、8、9、10、15、16、17的实际距离分别为0点时的1.2、1.6、1.6、1.4、1.4、1.4、1.6倍
for i = 1 : 46
    for j = 1 : 46
        Tmatrix(i,j,1) = temp(i,j);
        Tmatrix(i,j,2) = temp(i,j)*1.2;
        Tmatrix(i,j,3) = temp(i,j)*1.6;
        Tmatrix(i,j,4) = temp(i,j)*1.6;
        Tmatrix(i,j,5) = temp(i,j)*1.4;
        Tmatrix(i,j,6) = temp(i,j)*1.4;
        Tmatrix(i,j,7) = temp(i,j)*1.4;
        Tmatrix(i,j,8) = temp(i,j)*1.6;
    end
end
%%
%46个客户点至提货点的距离，提货点经纬度：116.577534,39.759874；
origin = [116.577534,39.759874];
to_origin = zeros(46,8);    %记录46个客户点在8个时间点至提货点的距离，
for i = 1 : 46
    to_origin(i,1) = distance(position(i,1),position(i,2),origin(1),origin(2))/180*pi*6371;
    %认为实际基本距离大约为直接距离的1.5倍
    to_origin(i) = to_origin(i)*1.5;
end
for i = 1 : 46
    to_origin(i,2) = to_origin(i,1)*1.2;
    to_origin(i,3) = to_origin(i,1)*1.6;
    to_origin(i,4) = to_origin(i,1)*1.6;
    to_origin(i,5) = to_origin(i,1)*1.4;
    to_origin(i,6) = to_origin(i,1)*1.4;
    to_origin(i,7) = to_origin(i,1)*1.4;
    to_origin(i,8) = to_origin(i,1)*1.6;
end