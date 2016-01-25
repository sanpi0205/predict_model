# 加载数据包
library('xlsx')
library(reshape2)
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

