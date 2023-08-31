# Envoi de fichiers dans narval
# dans le terminal
# scp /home/claire/BDQC-GEOBON/GITHUB/BDQC_EBV_cubes/DATA_Bellavance_conversion_occs.r ccjuhasz@narval.alliancecan.ca:projects/def-dgravel/ccjuhasz/

# Chargement de R

#### For Narval

install.packages("sp", repos = "https://cloud.r-project.org/")
install.packages("sf", repos = "https://cloud.r-project.org/")
install.packages("stringr", repos = "https://cloud.r-project.org/")

library(sp)
library(sf)
library(stringr)


file_path <- list.files(paste(getwd(), "/original_occ", sep = ""), full.names = TRUE)

total_occ <- list()

for (i in 1:length(file_path)) {
    # for (i in 1:2) {
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


#### For Narval

install.packages("sp", repos = "https://cloud.r-project.org/")
install.packages("sf", repos = "https://cloud.r-project.org/")
install.packages("stringr", repos = "https://cloud.r-project.org/")

library(sp)
library(sf)
library(stringr)


file_path <- list.files(paste(getwd(), "/original_occ", sep = ""), full.names = TRUE)

total_occ <- list()

for (i in 1:length(file_path)) {
    # for (i in 1:2) {
    path <- file_path[i]
    final_path <- substring(path, 1, nchar(path) - 4)
    sp_name <- strsplit(final_path, "/")[[1]][7]

    print(paste(sp_name, " --> start", sep = ""))

    file <- readRDS(path)
    file$species <- sp_name

    total_occ[[i]] <- file
}

total_occ_df <- do.call("rbind", total_occ)
# st_write(total_occ_df, file.path(paste(getwd(), "complete_occs.gpkg", sep = "/")))

print("Job is over")

# For total dim of data ==> DONE

file_path <- list.files(paste(getwd(), "/original_occ", sep = ""), full.names = TRUE)

total_dim <- list()

for (i in 1:length(file_path)) {
    # for (i in 1:2) {
    path <- file_path[i]

    final_path <- substring(path, 1, nchar(path) - 4)
    sp_name <- strsplit(final_path, "/")[[1]][7]
    print(paste(sp_name, " --> start", sep = ""))

    file <- readRDS(path)
    dim <- dim(file)[1]

    df <- data.frame(species = sp_name, row = dim)

    total_dim[[i]] <- df
}

total_dim_df <- do.call("rbind", total_dim)
total_dim_df


# test read geopackage

jeu <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/empidonax_alnorum.gpkg")
head(jeu)

# test for compiling files in single geopackage

files <- list.files("/home/claire/BDQC-GEOBON/data/Bellavance_data", pattern = ".gpkg", full.names = TRUE)

first <- sf::st_read(files[1])

total <- sf::st_write(first, "/home/claire/BDQC-GEOBON/data/Bellavance_data/total.gpkg")

for (i in 2:3) {
    other <- sf::st_read(files[i])
    sf::st_write(other, "/home/claire/BDQC-GEOBON/data/Bellavance_data/total.gpkg", append = TRUE)

    print(paste(files[i], " --> DONE", sep = ""))
}
class(total)
total
