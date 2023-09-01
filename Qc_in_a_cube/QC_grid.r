library(sf)
library(terra)
library(geodata)
library(maptiles)

# obtention carte du QC
country_codes()[42, ] # Canada -> 42

can <- geodata::gadm("CAN", level = 1, path = "/home/claire/BDQC-GEOBON/data/")
qc <- can[can$NAME_1 == "Québec", ]
plot(qc)

# Conversion from sp to sf
qc_sf <- st_as_sf(qc)

# conversion from lat/lon to utm
qc_utm <- st_transform(
    qc_sf,
    crs = st_crs(2031)
)
plot(st_geometry(qc_utm))

# creation of the grid
cell_size <- c(10000, 10000)
grid10 <- st_make_grid(qc_utm,
    cellsize = cell_size,
    square = TRUE
)
plot(grid10)

plot(st_intersection(grid10, qc_utm))
