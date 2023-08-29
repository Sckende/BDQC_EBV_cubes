# Envoi de fichiers dans narval
# dans le terminal
# scp /home/claire/BDQC-GEOBON/GITHUB/BDQC_EBV_cubes/DATA_Bellavance_conversion_occs.r ccjuhasz@narval.alliancecan.ca:projects/def-dgravel/ccjuhasz/

# Chargement de R

#### For Narval

install.packages('sp', repos='https://cloud.r-project.org/')
install.packages('sf', repos='https://cloud.r-project.org/')
install.packages('stringr', repos='https://cloud.r-project.org/')

library(sp)
library(sf)
library(stringr)


file_path <- list.files(paste(getwd(), "/original_occ", sep = ""), full.names = TRUE)

total_occ <- list()

for (i in 1:length(file_path)) {
#for (i in 1:2) {
    path <- file_path[i]
    new_path <- stringr::str_replace(path, "original_", "sf_converted_")
    final_path <- substring(new_path, 1, nchar(new_path) - 4)
    sp_name <- strsplit(final_path, "/")[[1]][7]

    print(paste(sp_name, " --> start", sep = ""))

    file <- readRDS(path)
    file_sf <- sf::st_as_sf(file)
    file_sf$species <- sp_name

    total_occ[[i]] <- file_sf

}

total_occ_df <- do.call("rbind", total_occ)
st_write(total_occ_df, file.path(paste(getwd(), "complete_occs.gpkg", sep = "/")))

print("Job is over")
