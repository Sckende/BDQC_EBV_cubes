# library(divraster)
library(terra)
library(sf)
# ??divraster

# Rasters for testing code
acan <- terra::rast("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps/acanthis_flammea/maps_range.tif")
acan <- acan[[nlyr(acan)]]

ammo <- terra::rast("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps/ammodramus_savannarum/maps_range.tif")
ammo <- ammo[[nlyr(ammo)]]

cali <- terra::rast("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps/calidris_minutilla/maps_range.tif")
cali <- cali[[nlyr(cali)]]

cyano <- terra::rast("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps/cyanocitta_cristata/maps_range.tif")
cyano <- cyano[[nlyr(cyano)]]

# convertion from numerical rasters to categorical rasters
rasters <- list(acan, ammo, cali, cyano)
names(rasters) <- c("acan", "ammo", "cali", "cyano")

for (i in seq_along(rasters)) {
    spe <- data.frame(id = 0:1, spe = c("none", names(rasters)[i]))
    levels(rasters[[i]]) <- spe
}

global <- rast(rasters)
x11()
plot(global[[1]])

qc <- st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/QUEBEC_regions_nat.gpkg")
qc <- st_transform(qc, crs = st_crs(global))
st_crs(qc) == st_crs(global)

plot(global[[1]])
plot(st_geometry(qc[10, ]), add = T, col = "red")
laurent_crop <- crop(global, st_geometry(qc[10, ]))
laurent_mask <- mask(laurent_crop, st_geometry(qc[10, ]))

### => to follow crop and extract unique name of species to obtain the richness
