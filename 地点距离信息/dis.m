%��ά���������㣨��γ�Ȼ��㣩
temp = zeros(46,46);
for i = 1 : 46
    for j = 1 : 46
        temp(i,j) = distance(position(i,1),position(i,2),position(j,1),position(j,2))/180*pi*6371;
    end
end
temp = temp * 1.5;  %��Ϊʵ�ʻ��������ԼΪֱ�Ӿ����1.5��

toOrigin = zeros(46,1);
for i = 1 : 46
    toOrigin(i) = distance(position(i,1),position(i,2),origin(1),origin(2))/180*pi*6371;
end
toOrigin = toOrigin * 1.5;