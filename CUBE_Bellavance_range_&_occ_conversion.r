library(terra)
library(sf)
library(raster)

#### ---- Conversion des fichiers range & occ en .tif ---- ####
# ----------------------------------------------------------- #
# Pour utilisation du package terra

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
