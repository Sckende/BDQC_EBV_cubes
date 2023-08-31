library(sp)
library(sf)
library(stringr)

# Get array number
array_id <- as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))

file_path <- list.files(paste(getwd(), "/original_occ", sep = ""), full.names = TRUE)


path <- file_path[array_id]
new_path <- stringr::str_replace(path, "original_", "sf_converted_")
final_path <- substring(new_path, 1, nchar(new_path) - 4)
sp_name <- strsplit(final_path, "/")[[1]][7]

print(paste(sp_name, " --> start", sep = ""))

file <- readRDS(path)
file_sf <- sf::st_as_sf(file)
file_sf$species <- sp_name

st_write(file_sf, file.path(paste(final_path, "gpkg", sep = ".")))
