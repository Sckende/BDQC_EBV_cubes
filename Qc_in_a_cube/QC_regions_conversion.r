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
