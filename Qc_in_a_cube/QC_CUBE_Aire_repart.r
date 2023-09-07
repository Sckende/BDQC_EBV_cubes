library(sf)
library(terra)

#### First layer - Spatial SDM method ####
# ---------- #
list_spe_long <- list.files("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps", full.names = T)
list_spe_short <- list.files("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps")


years <- 1992:2017
final_areas <- NULL
for (i in seq_len(length(list_spe_long))) {

    print(list_spe_short[i])

    if(length(list.files(list_spe_long[i])) != 0) {
        raster <- terra::rast(paste(list_spe[i], "maps_range.tif", sep = "/"))
        species <- list_spe_short[i]

        areas <- lapply(raster, function(x) {
            sum(values(x), na.rm = T)*10*10 # en km2
        })
    } else {
        areas <- rep(NA, length(years))
    }

    final_areas <- rbind(final_areas, areas)
}

class(final_areas)
df <- as.data.frame(final_areas)
df <- cbind(list_spe_short, df)
names(df) <- c("species", years)
head(df)
class(df)
summary(df$2008)

matplot(t(df), type = "l")

### ===> register the result !
write.table(df, "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Species_distribution/QC_spe_distr_first_layer.txt")
