library(sf)
library(sp)

# Regions naturelles
reg <- rgdal::readOGR("/home/claire/BDQC-GEOBON/data/QUEBEC_regions", layer = "CR_NIV_01_S")
reg <- sp::spTransform(reg, sp::CRS("+proj=longlat +datum=WGS84 +no_defs"))
reg_sf <- sf::st_as_sf(reg)

# Sous-régions naturelles
sreg <- rgdal::readOGR("/home/claire/BDQC-GEOBON/data/QUEBEC_regions", layer = "CR_NIV_02_S")
sreg <- sp::spTransform(sreg, sp::CRS("+proj=longlat +datum=WGS84 +no_defs"))
sreg_sf <- sf::st_as_sf(sreg)

# Visualisation
x11()
plot(st_geometry(sreg_sf), border = "grey")
plot(st_geometry(reg_sf), add = T)

# sf::st_write(reg_sf, "/home/claire/BDQC-GEOBON/data/QUEBEC_regions/QUEBEC_regions_nat.gpkg")
sf::st_write(sreg_sf, "/home/claire/BDQC-GEOBON/data/QUEBEC_regions/QUEBEC_SOUSregions_nat.gpkg")

rm(list = ls())
reg <- sf::st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/QUEBEC_regions_nat.gpkg")
plot(st_geometry(reg))

sousReg <- sf::st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/QUEBEC_SOUSregions_nat.gpkg")
plot(st_geometry(sousReg))
