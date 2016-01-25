# 加载数据包
library('xlsx')
library('dplyr')
source('util.R')

# 读取数据
load(file = "../final.RData")

# 结果调整
names(result)
new_result = result

# 读取数据
wb = loadWorkbook("../scenario.xlsx")
ws = getSheets(wb)
sheet = ws$scenario1

# 读取能源消费数据
total = read_two_columns(sheet, 46)
# 指数化数据
total = exponent_interpolation(total, 6)
predict_index=16:21
# 修改总量
new_result$energy_consumption$total[predict_index] = total




total = approx(total, n =6)$y

coal = read_two_columns(sheet, 52)
oil = read_two_columns(sheet, 53)
gas = read_two_columns(sheet, 54)
primary_electricity = read_two_columns(sheet, 55)




