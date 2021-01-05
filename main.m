%%
%������ز�����ʼ����
%�����ͺţ��𱭡�ȫ˳��4.2��5.2��6.8��7.7��9.6�������ţ�
C1 = [0.5,0.8,1,1.5,1.5,2,2.5];   %�ĵ硢ȼ�ͷ��ã���λ��Ԫ/�����
C2 = [0.1,0.2,0.3,0.4,0.4,0.5,0.6];   %ά�����ã���λ��Ԫ/�����
C3 = [1,1,2,2.5,2.5,2.5,3];    %���շ��ã���λ��Ԫ/���ʹ�����;
C4 = [10,10,15,20,20,20,30];    %˾�����ã���λ��Ԫ/���ʹ�����;
C5 = [10,10,15,20,20,25,35];    %ж�����ã���λ��Ԫ/���ʹ�����;
%����λ��Ԫ/��һ���ͻ��㡢�����ͻ��㣩
C6 = [350,350,450,550,650,650,850;50,50,100,110,140,140,180];
C7 = 90;   %�Զ�λ�Ƽ۵Ļ���ɱ�
C8 = 30;    %������Ƽ۵Ļ���ɱ�

M1 = [2,3,6,10,13,15,25];  %������������֣�
V1 = [4,6,15,17,30,40,50];  %������ݻ���������

%�������ޣ�������Ϊÿ��������ʱ���С��9Сʱ
Timax = 9;

speed = 35; %ƽ�����٣���λ������/Сʱ��
%%
%�������2000���������
p2000 = zeros(2000,7,1000);
c2000 = zeros(2000,1);
for i = 1 : 2000
    [plan,cost] = randomPlan(M1,V1,Dorder,to_origin,speed,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8);
    p2000(i,:,:) = plan;
    c2000(i) = cost;
end
%%
%����ͽ���4000��
tp2 = zeros(2000,7,1000);    %�ݴ�
tc2 = zeros(2000,1);
tp = zeros(7,1000);

minc = zeros(1,4000);
meanc = zeros(1,4000);

for i = 1 : 4000
    %ÿ�ֱ���ǰ200�����ɱ���͵�200������
    [tc2, index] = sort(c2000);
    for j = 1 : 200
        tp2(j,:,:) = p2000(index(j),:,:);
    end
    %���ɽ������1600������
    %������ÿ��������ÿ������ֵ������Ψһ�ԣ�������ͬ�ķ����޷�����ͳ�Ľ���
    %�������ǽ���������������ϵõ��µĲ������������£�
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
        %���ڶ������϶࣬��������ѡ��20����
        for k = 1 : 20
            tonum = unidrnd(366);   %��������㣨������
            toindex1 = find(p1 == tonum);   %��p1�����У��ҵ��ö�����λ��
            tonum2 = p2(toindex1);  %��p2�����У���������λ�á����룬�õ��¶���
            
            while tonum2 == -1 || tonum2 == 0  %�����¶���������
                tonum = unidrnd(366);
                toindex1 = find(p1 == tonum);   %��p1�����У��ҵ��ö�����λ��
                tonum2 = p2(toindex1);  %��p2�����У���������λ�á����룬�õ��¶���
            end
            [toindex21,toindex22] = find(p2 == tonum);   %����p2�����У��ҵ����������λ��
            [toindex31,toindex32] = find(p2 == tonum2);   %����p2�����У��ҵ��¶�����λ��
            
            %��p2��������������λ�û���
            p2(toindex21,toindex22) = tonum2;
            p2(toindex31,toindex32) = tonum;
            %���������·����Ƿ�Ϸ�
            flagp = 1;
            while flagp
                m2 = 0; v2 = 0; t2 = 0;  %toindex2���ڵ�ĳ������������
                m3 = 0; v3 = 0; t3 = 0;  %toindex3���ڵ�ĳ������������
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
                    flagp = 1;  %���Ϸ������»���
                    
                    tonum = unidrnd(366);   %��������㣨������
                    toindex1 = find(p1 == tonum);   %��p1�����У��ҵ��ö�����λ��
                    tonum2 = p2(toindex1);  %��p2�����У���������λ�á����룬�õ��¶���
                    while tonum2 == -1 || tonum2 == 0 %�����¶���������
                        tonum = unidrnd(366);
                        toindex1 = find(p1 == tonum);   %��p1�����У��ҵ��ö�����λ��
                        tonum2 = p2(toindex1);  %��p2�����У���������λ�á����룬�õ��¶���
                    end
                    [toindex21,toindex22] = find(p2 == tonum);   %����p2�����У��ҵ����������λ��
                    [toindex31,toindex32] = find(p2 == tonum2);   %����p2�����У��ҵ��¶�����λ��

                    %��p2��������������λ�û���
                    p2(toindex21,toindex22) = tonum2;
                    p2(toindex31,toindex32) = tonum;
                    
                end                
            end
        end
        
        tp2(j,:,:) = p2;
        tc2(j) = charge(p2,M1,V1,Dorder,to_origin,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8);
    end
    
    for j = 1801 : 2000  %������������200������
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