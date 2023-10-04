library(xml2)
library(XML)
library(tidyverse)
library(methods)

files <- list.files("data/raw/SIVIM", pattern = "*.xml", full.names = TRUE)

# f <- files[1]

get_releves <- function(f) { 
  x <- read_xml(f)
  
  x |> xml_ns_strip()
  
  id_releve <- xml_find_all(x, "//Releve") |> map(xml_attrs) |> map_df(~as.list(.)) |> dplyr::select(name) |> pull()
  
  # Table Releve 
  releve_table <- x |> 
    xml_find_all("//ReleveEntry") |> 
    map(xml_attrs) |> 
    map_df(~as.list(.)) |> 
    mutate(id_releve = id_releve)
  
  return(releve_table)

}

get_md_releves <- function(f) { 
  x <- read_xml(f)
  
  x |> xml_ns_strip()
  
  id_releve <- xml_find_all(x, "//Releve") |> map(xml_attrs) |> map_df(~as.list(.)) |> dplyr::select(name) |> pull()
  
  survey_data <- xml_find_all(x, "//SurveyDate") |> 
    map(xml_attrs) |> 
    map_df(~as.list(.)) 
  
  geo <- xml_find_all(x, "//CitationCoordinate") |> 
    map(xml_attrs) |> 
    map_df(~as.list(.))
  
  extract_info <- function(node) {
    name <- xml_name(node)
    value <- xml_text(node)
    return(data.frame(Name = name, Value = value, stringsAsFactors = FALSE))
  }
  
  md <- bind_rows(
    xml_find_all(x, "//PlotArea") |> list() |> map_dfr(extract_info),
    xml_find_all(x, "//PlotForm") |> list() |> map_dfr(extract_info),
    xml_find_all(x, "//OriginalSyntaxonName") |> list() |> map_dfr(extract_info),
    xml_find_all(x, "//CurrentSyntaxonName") |> list() |> map_dfr(extract_info)
  ) |> 
    pivot_wider(names_from = Name, values_from = Value) 
  
  
  refs <- xml_find_all(x, "//BibliographicReference") |> 
    map(xml_contents) |> 
    map(extract_info) |> 
    as.data.frame() |> 
    pivot_wider(names_from = Name, values_from = Value)
  
  
  results <- bind_cols(
    survey_data, geo, md, refs
  ) |> 
    mutate(id_releve = id_releve) |> 
    relocate(id_releve)

  return(results)
  
}



md_releves <- files |> map(get_md_releves) |> bind_rows()
releves <- files |> map(get_releves) |> bind_rows() |> 
  dplyr::select(-sureness, -layer) |> 
  relocate(id_releve, original_name)

write_csv(releves, "data/raw/SIVIM/sivim_inventarios_especies.csv")
write_csv(md_releves, "data/raw/SIVIM/sivim_inventarios_metadatos.csv")


