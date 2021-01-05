import requests
import xlrd
import xlwt
import json
def coords(city):
    url = 'https://restapi.amap.com/v3/geocode/geo'   # 输入API问号前固定不变的部分
    params = { 'key': '69ad2f340c0090d2d89ef6842918e160',                 
               'address': city   }                    # 将两个参数放入字典
    res = requests.get(url, params)
    jd =  json.loads(res.text)
    return jd['geocodes'][0]['location']

data1 = xlrd.open_workbook('address.xlsx')
table1 = data1.sheet_by_name('Sheet1')

data2 = xlwt.Workbook(encoding='utf-8')
table2 = data2.add_sheet('sheet1')

point = table1.col_values(0)
for i in point:
    ans = coords(i)
    print(ans)