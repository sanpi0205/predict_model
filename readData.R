# 加载数据包

library('xlsx')
library('dplyr')
source('util.R')

# 读取数据
load(file = "final.RData")

# 结果调整
names(result)

# 读取数据
wb = loadWorkbook("../scenario.xlsx")
ws = getSheets(wb)
sheet = ws$scenario1

# 读取数据
total = read_two_columns(sheet, 46)
coal = read_two_columns(sheet, 52)
oil= c(7.5, 7.9)
gas = c()
primary_electricity = c()
wind = c()

