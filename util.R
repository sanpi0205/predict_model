library(xlsx)
read_two_columns = function(sheet, row_num){
  data = readColumns(sheet, startColumn = 13, endColumn = 14, 
                     startRow = row_num, endRow = row_num, header = F, colClasses = rep('numeric',2))
  names(data) = c(2015, 2020)
  return(data)
}
