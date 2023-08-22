library(terra)
library(raster)

ras <- terra::stack("/home/claire/BDQC-GEOBON/data/EBVs/Bellavance_data/maps/quebec/agelaius_phoeniceus/maps_occ.gri")


ras <- raster::stack("/home/claire/BDQC-GEOBON/data/EBVs/Bellavance_data/maps/quebec/agelaius_phoeniceus/maps_occ.gri")
x11();plot(ras)

names(ras)
