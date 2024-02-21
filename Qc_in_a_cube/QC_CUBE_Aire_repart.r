# Creation du cube EBV - aire de distribution
# Une couche par type de modèle
# couche 1 -> Modèles SDM type auto-corrélation spatiale de V. Bellavance avec INLA
# couche 2 -> Modèles SDM type environnemental avec Maxent (cf pipeline GEOBON) ?
# couche 3 -> Modèles SDM type environnemental avec MapSpecies ?

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

    if (length(list.files(list_spe_long[i])) != 0) {
        raster <- terra::rast(paste(list_spe_long[i], "maps_range.tif", sep = "/"))
        species <- list_spe_short[i]

        areas <- lapply(raster, function(x) {
            sum(values(x), na.rm = T) * 10 * 10 # en km2
        })
    } else {
        areas <- rep(NA, length(years))
    }

    final_areas <- rbind(final_areas, as.numeric(areas))
}

class(final_areas)
head(final_areas)

df <- as.data.frame(final_areas)
df <- cbind(list_spe_short, df)

summary(df)
dim(df)

names(df) <- c("species", as.character(years))


head(df)
class(df)
summary(df$"2008")

x11()
matplot(t(df), type = "l")

### ===> register the result !
# write.table(df, "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Species_distribution/QC_spe_distr_first_layer.txt", sep = "\t")

# df <- read.table("/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Species_distribution/QC_CUBE_Spe_distr_first_layer.txt")


#### Visualisation pour travail sur incertitude ####
# ----------#

files <- list.files(list_spe_long[127], full.names = TRUE)

maps_025 <- rast(files[1])
maps_975 <- rast(files[2])
maps_occ <- rast(files[3])
maps_pocc <- rast(files[4])
maps_range <- rast(files[5])

x11()
par(mfrow = c(2, 3))

plot(maps_range[[1]], main = "map_range")
plot(maps_occ[[1]], main = "map_occ")
plot(maps_pocc[[1]], main = "map_pocc")
plot(maps_025[[1]], main = "map_025")
plot(maps_975[[1]], main = "map_975")

x11()
par(mfrow = c(1, 3))
plot(maps_pocc[[1]])
plot(maps_range[[1]])
plot(mask(resample(maps_pocc[[1]], maps_range[[1]]), maps_range[[1]]))
