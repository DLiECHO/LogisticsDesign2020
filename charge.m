function c = charge(p,M,V,Dor,to_origin,Tmatrix,C1,C2,C3,C4,C5,C6,C7,C8)
c = 0;  %�÷�������
arrMV = [M;V];
arrMV = arrMV'; %��������
for i = 1 : 7   %������
    for j = 2 : 1000    %�ӵڶ����ͻ��㿪ʼ����һ��Ϊ��ʼ�㣩
        if p(i,j) == 0 || p(i,j) == -1    %ĳ�����ͽ���
            dt = distance(p(i,j-1),0,Dor,to_origin,Tmatrix);
            c = c + C3(i) + C4(i) + C5(i) + ...
                arrMV(i,1)*C7 + arrMV(i,2)*C8 + ...
                dt*C1(i) + dt*C2(i);
            
            arrMV(:,1) = M; %��ز�������
            arrMV(:,2) = V;
            if p(i,j) == -1
                break;
            end
        else
            arrMV(i,1) = arrMV(i,1) - Dor(p(i,j),2); %��ز�������
            arrMV(i,2) = arrMV(i,2) - Dor(p(i,j),3);
            
            %�Ʒ�
            if p(i,j-1)~=0 && Dor(p(i,j),1) ~= Dor(p(i,j-1),1)
                %�¶�������һ����������һ���ͻ���Ż����µĵ�λ�ѵȷ���
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