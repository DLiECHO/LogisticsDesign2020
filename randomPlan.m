function [p,c] = randomPlan(M,V,Dor,to_origin,speed,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8)
tdor = Dor;
%�������ǹ�����Ϊ���ж�����ʱ�䴰����9Сʱ
%��ÿ��������ʱ��С��9Сʱ
Timax = 9;
%�����Զ���Ϊ��λ������䣬���ɽ������

%M,V�ֱ�Ϊ8��������������ݻ�,DorΪ366�������Ļ�����Ϣ

p = zeros(7,1000);   %8������·���滮���Կͻ���Ϊ�ڵ㣩�������������
for i = 1 : 7
    for j = 1 : 1000
        p(i,j)  = -1;
    end
end
p(:,1) = 0; %���г���һ���ͻ������������ģ������
pn = zeros(7,1);    %��8����¼·���ڵ�Ķ�̬����
pn = pn + 2;
c = 0;  %�����ɱ�
%��������һ����̬���飬��8������ʣ�����ء��ݻ�������ʱ��
T = zeros(7,1);
arrMV = [M;V];
arrMV = arrMV';

%·������
f = 1;  %flag
for i = 366 : -1 : 1
    while(f)    %����ѡ�����ɹ�������
        onum = unidrnd(i);  %���ѡ��һ������
        cnum = unidrnd(7);  %���ѡ��һ����

        if arrMV(cnum,1)-Dor(onum,2)<0 ||...
                arrMV(cnum,2)-Dor(onum,3)<0 ||...
                T(cnum)+distance(p(cnum,pn(cnum)-1),onum,tdor,to_origin,Tmatrix)/speed>Timax
            %��������Ӳ������������
            %���ʱ������ֱ����Ϊ�����ˣ������ͳ�ȥ������һ���ͻ���ֱ�ӻص����
            if p(cnum,pn(cnum)-1) ~= 0  %�����¼���������������Ȼ������ǿյģ�Ҳװ���µ����
                p(cnum,pn(cnum)) = 0;
                pn(cnum) = pn(cnum) + 1;
                              
                arrMV(:,1) = M; %��ز�������
                arrMV(:,2) = V;
                T(cnum) = 0;
            end
        else    %����Ŀǰ����״̬���������������������Ϊ�п��������װ��������������������ﻹ��Ҫelse��
            p(cnum,pn(cnum)) = Dor(onum,4);    %�͸ö���
            pn(cnum) = pn(cnum) + 1;
            arrMV(cnum,1) = arrMV(cnum,1) - Dor(onum,2); %��ز�������
            arrMV(cnum,2) = arrMV(cnum,2) - Dor(onum,3);
            T(cnum) = T(cnum) + distance(p(cnum,pn(cnum)-1),onum,tdor,to_origin,Tmatrix)/speed;
            
            Dor(onum,:) = [];   %������װ�أ�ɾ��
            f = 0;
            
        end
    end
    f = 1;
end
c = charge(p,M,V,tdor,to_origin,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8);
end