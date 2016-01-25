source('readData.R')
# 重构数据

predict_index=16:21
n = 6 #预测步长

new_result$energy_consumption = new_result$final - new_result$transformation + new_result$loss
result$energy_consumption = result$final - result$transformation + result$loss

# 总量
## 读取能源消费数据
total = read_two_columns(sheet, 46)
## 指数化数据
total = exponent_interpolation(total, 6)
## 修改总量
new_result$energy_consumption$total[predict_index] = total

# 煤炭
coal_ratio = read_two_columns(sheet, 47)
coal_ratio = approx(coal_ratio, n=6)$y / 100
new_result$energy_consumption$coal[predict_index] = total * coal_ratio

# 石油
ratio = read_two_columns(sheet, 48)
ratio = approx(ratio, n= n)$y / 100
new_result$energy_consumption$oil[predict_index] = total * ratio

# 天然气
ratio = read_two_columns(sheet, 49)
ratio = approx(ratio, n= n)$y / 100
new_result$energy_consumption$gas[predict_index] = total * ratio

# 调整energy consumption
energy_names = names(new_result$energy_consumption)
for(name in energy_names){
  if(!name %in% c('year','total','coal','oil','gas')){
    new_result$energy_consumption[name] = new_result$energy_consumption$total * 
      result$energy_consumption[name]  / result$energy_consumption$total
  }
}

# 调整 final transformation loss
# new_final = new_energy_c * old_final / old_energy_c
for(name in energy_names){
  if(!name %in% c('year')){
    new_result$final[name] = new_result$energy_consumption[name] * 
      result$final[name]  / result$energy_consumption[name]
  }
}


for(name in energy_names){
  if(!name %in% c('year')){
    new_result$transformation[name] = new_result$energy_consumption[name] * 
      result$transformation[name]  / result$energy_consumption[name]
  }
}

for(name in energy_names){
  if(!name %in% c('year')){
    new_result$loss[name] = new_result$energy_consumption[name] * 
      result$loss[name]  / result$energy_consumption[name]
  }
}

new_result$final$total - result$final$total





result_database = NULL
for(i in names(new_result)){
  zz = melt(new_result[[i]], id.vars = 'year')
  zz = data.frame(zz, sector=i)
  result_database = rbind(result_database, zz)
} 


# 新命名
sector_name_code = hash(final='终端消费量', agriculture='农业', industry='工业', building='建筑业',
                        transport='交通',retail='商业', others='其他',residential='生活消费', urban='城镇',rural='乡村', 
                        total_consumption='消费量合计', loss='损失量', transformation='加工转换', 
                        thermal_power='火力发电', heating='供热', total_supply='能源供应总量', 
                        primary_energy='一次能源生产量', hydro='水电', nuclear='核电', wind='风电', 
                        import='进口量', export='出口量', stock='库存', energy_consumption='能源消费总量',
                        energy_production='能源生产总量')

energy_hash = hash(coal='煤合计',coke='焦炭',oil='油品合计',gas='天然气',heat='热力',
                   electricity='电力',final='电热当量', total='发电煤耗', crude_oil='原油', gaseline='汽油',
                   kerosene='煤油', diesel='柴油')

# 修改 sector 
result_database=data.frame(result_database, 
                           sector_c=values(sector_name_code)[match(result_database$sector, 
                                                                   keys(sector_name_code))] 
)
result_database=data.frame(result_database, energy_c=values(energy_hash)[match(result_database$variable, 
                                                                               keys(energy_hash))] 
)


# 输出数据
write.xlsx2(result_database, file = '../scenario1_out.xlsx', sheetName = "alldata",append = F)
