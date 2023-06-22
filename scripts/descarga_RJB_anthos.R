## Explore the dataset "CSIC-Real Jardín Botánico-Anthos. 
# Sistema de Información de las Plantas de España (https://doi.org/10.15468/4wnutv)"

#install.packages("finch")
#install.packages("tidyverse")
library(tidyverse)
library(finch)

library(here)


# Use finch pkg to download the DarwinCoreArchive of 
# " CSIC-Real Jardín Botánico-Anthos. 
# Sistema de Información de las Plantas de España (https://doi.org/10.15468/4wnutv)"
f <- finch::dwca_read("https://ipt.gbif.es/archive.do?r=rjb-anthos", read=TRUE)

# no me deja descargarme el archivo por un fallo en la descarga (Timeoutof 60 seconds was reached)

# me descargo las ocurrencias directamente desde GBIF, haciendo un filtro de la colección 
# de Anthos por nombre científico (Androcymbium europaeum, Androcymbium gramíneum)
# en total son: 19 ocurrencias 

a <- read.table("data/RAW/anthos/occurrence.txt", header=TRUE, fill=TRUE)
colnames <- colnames(a)

b <- read.table("data/RAW/anthos/occurrence.txt", header=TRUE, col.names=colnames)
# no sale bien esto, preguntar a Antonio 
# como no puedo leer el txt de ocurrencias directamente, lo abro con excel y lo guardo como xlsx

library(readxl)
occurrence_anthos <- read_excel("data/RAW/anthos/occurrence_Anthos.xlsx")

occurrence_anthos <- occurrence_anthos[, !apply(occurrence_anthos, 2, function(x) all(is.na(x)))]
# de esta forma borro todas las columnas con NA y me quedo solo con las que tienen información 
# (ya veremos con qué info nos quedamos)


