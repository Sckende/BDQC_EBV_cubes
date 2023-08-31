library(terra)
library(sf)
library(raster)

#### ---- Conversion des fichiers raster range & occ en .tif ---- ####
# ----------------------------------------------------------- #
# Pour utilisation du package terra

folder_path <- list.files("/home/claire/BDQC-GEOBON/data/Bellavance_data/original_maps", full.names = TRUE)

for (i in 1:length(folder_path)) {
    print(paste("valeur de i - ", i))
    new_folder_path <- stringr::str_replace(folder_path[i], "original_", "terra_converted_")

    dir.create(file.path(new_folder_path))


    file_path_long <- list.files(folder_path[i],
        pattern = ".gri",
        full.names = T
    )
    file_path_short <- list.files(folder_path[i],
        pattern = ".gri"
    )

    # for(j in 1:length(file_path_long)) {
    if (length(file_path_long != 0)) {
        for (j in c(3, 5)) {
            print(paste("valeur de j - ", j))

            file_name <- substr(file_path_short[j], 1, nchar(file_path_short[j]) - 3)

            file <- raster::stack(file_path_long[j])
            file_terra <- terra::rast(file)


            terra::writeRaster(
                file_terra,
                paste(new_folder_path, "/", file_name, "tif", sep = "")
            )
        }
    }
}


#### ---- Conversion des fichiers occurences ---- ####
# -------------------------------------------------- #
# Pour utilisation du package sf

file_path <- list.files("/home/claire/BDQC-GEOBON/data/Bellavance_data/original_occurrences", full.names = TRUE)

for (i in 1:length(file_path)) {
    # for (i in 1:2) {
    path <- file_path[i]
    new_path <- stringr::str_replace(path, "original_", "sf_converted_")
    final_path <- substring(new_path, 1, nchar(new_path) - 4)
    sp_name <- strsplit(final_path, "/")[[1]][8]

    print(paste(sp_name, " --> start", sep = ""))

    file <- readRDS(path)
    file_sf <- sf::st_as_sf(file)
    file_sf$species <- sp_name

    st_write(file_sf, file.path(paste(final_path, "gpkg", sep = ".")))
}

file <- file_sf[1:1000000, ]
x11()
plot(st_geometry(file))

mapview::mapview(file)



#### TESTS FOR NARVAL ####
# ---------------------- #
# File conversion

file_path <- list.files(paste(getwd(), "/original_occ", sep = ""), full.names = TRUE)


# for (i in 1:length(file_path)) {
for (i in 1:2) {
    path <- file_path[i]
    new_path <- stringr::str_replace(path, "original_", "sf_converted_")
    final_path <- substring(new_path, 1, nchar(new_path) - 4)
    sp_name <- strsplit(final_path, "/")[[1]][7]

    print(paste(sp_name, " --> start", sep = ""))

    file <- readRDS(path)
    file_sf <- sf::st_as_sf(file)

    st_write(file_sf, file.path(paste(final_path, "gpkg", sep = ".")))
}

# summary of total row number for occ data

file_path <- list.files(paste(getwd(), "/original_occ", sep = ""), full.names = TRUE)

dim_occ <- list()

# for (i in 1:length(file_path)) {
for (i in 1:2) {
    path <- file_path[i]
    new_path <- stringr::str_replace(path, "original_", "sf_converted_")
    final_path <- substring(new_path, 1, nchar(new_path) - 4)
    sp_name <- strsplit(final_path, "/")[[1]][7]

    print(paste(sp_name, " --> start", sep = ""))

    file <- readRDS(path)
    file_sf <- sf::st_as_sf(file)

    st_write(file_sf, file.path(paste(final_path, "gpkg", sep = ".")))
}
