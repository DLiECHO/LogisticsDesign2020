import xlrd
import pandas

filename = 'order.xlsx'
pos = []
start = []
end = []
with xlrd.open_workbook(filename) as fl:
    table = fl.sheets()[0]
    pos = table.col_values(0)
    start = table.col_values(1)
    end = table.col_values(2)
    num = table.col_values(3)
    weight = table.col_values(4)
    volum = table.col_values(5)

pos1 = []
start1 = []
end1 = []
num1 = []
weight1 = []
volum1 = []

pos2 = []
start2 = []
end2 = []
num2 = []
weight2 = []
volum2 = []

for i in range(160):
    if pos[i] not in pos1:
        pos1.append(pos[i])
        start1.append(start[i])
        end1.append(end[i])
        num1.append(num[i])
        weight1.append(weight[i])
        volum1.append(volum[i])
    else:
        num1[len(num1)-1] += num[i]
        weight1[len(weight1)-1] += weight[i]
        volum1[len(volum1)-1] += volum[i]

for i in range(161,366):
    if pos[i] not in pos2:
        pos2.append(pos[i])
        start2.append(start[i])
        end2.append(end[i])
        num2.append(num[i])
        weight2.append(weight[i])
        volum2.append(volum[i])
    else:
        num2[len(num2)-1] += num[i]
        weight2[len(weight2)-1] += weight[i]
        volum2[len(volum2)-1] += volum[i]

anfl1 = pandas.DataFrame()
anfl2 = pandas.DataFrame()
anfl1['位置'] = pos1
anfl1['最早'] = start1
anfl1['最晚'] = end1
anfl1['数量'] = num1
anfl1['吨位'] = weight1
anfl1['体积'] = volum1
anfl1.to_csv('6_6.csv', index=False, header=None)
anfl2['位置'] = pos2
anfl2['最早'] = start2
anfl2['最晚'] = end2
anfl2['数量'] = num2
anfl2['吨位'] = weight2
anfl2['体积'] = volum2
anfl2.to_csv('6_23.csv', index=False, header=None)