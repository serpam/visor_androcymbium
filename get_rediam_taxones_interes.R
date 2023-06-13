## Explore the dataset Localización de táxones botánicos de interés para la identificación de hábitats 
# de la REDIAM (Secretaría General de Medio Ambiente, Agua y Cambio Climático)


# install.packages("finch")
library(tidyverse)
library(finch)

# Use finch pkg to download the DarwinCoreArchive of 
# "Localización de táxones botánicos de interés para la identificación de hábitats 
# de la REDIAM (Secretaría General de Medio Ambiente, Agua y Cambio Climático)"
f <- finch::dwca_read("https://ipt.gbif.es/archive.do?r=rediam-flora&v=1.3")

# Access to ocurrence data 
occ <- read_delim(f$data[1], delim = "\t") 

# Search all records of genus "Androcymbium" 
occ |> filter(genus == "Androcymbium") 

# No results 

# Check "Colchicum" 
occ |> filter(genus == "Colchicum") 

# No results 

# Do the search works? 
# occ |> filter(genus == "Quercus")
