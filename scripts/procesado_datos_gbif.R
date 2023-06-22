library('readxl')
library('here')

#Leemos el archivo csv y creamos dataset

dataset <- read.csv("data/RAW/GBIF/records-2023-06-22.csv")


#Limpiamos las columnas enteramente vacías
dataset_sin_vacios <- dataset[, !apply(dataset, 2, function(x) all(is.na(x)))]

#Falta seleccionar que columnas nos queremos quedar para la base datos