library(xlsx)
read_two_columns = function(sheet, row_num){
  data = readColumns(sheet, startColumn = 13, endColumn = 14, 
                     startRow = row_num, endRow = row_num, header = F, colClasses = rep('numeric',2))
  names(data) = c(2015, 2020)
  data = as.numeric(data)
  return(data)
}

exponent_interpolation = function(data, number){
  # 将数据点进行指数差值
  # data长度为2，number为差值后的数据长度
  # 指数公式为 y = a * exp(x) + b
  # 函数根据数值求解参数 a 和 b
  
  n = length(data)
  if(n > 2){
    print( "数据有错误")
    return
  }
  if(n == 2){
    a = (data[2]-data[1]) / (exp(1)-1)
    b = data[1] - a
    x  = approx(data, n=number)$x
    x = (x - min(x)) / (max(x) -min(x) )
    y = a * exp(x) + b
    y = as.vector(y)
    y = as.numeric(y)
    return(y)
  }

}