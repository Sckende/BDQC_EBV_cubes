library(sf)
library(terra)
library(geodata)
library(maptiles)

#### obtention carte du QC ####
# ---------- #
country_codes()[42, ] # Canada -> 42

can <- geodata::gadm("CAN", level = 1, path = "/home/claire/BDQC-GEOBON/data/")
qc <- can[can$NAME_1 == "Québec", ]
plot(qc)

#### Conversion from sp to sf ####
# ---------- #

qc_sf <- st_as_sf(qc)

#### conversion from lat/lon to utm ####
# ---------- #

qc_utm <- st_transform(
    qc_sf,
    crs = st_crs(2031)
)
plot(st_geometry(qc_utm))

#### creation of the grid ####
# ---------- #

# cell_size <- c(10000, 10000)
# grid10 <- st_make_grid(qc_utm,
#     cellsize = cell_size,
#     square = TRUE
# )
# plot(grid10)

# inters <- st_intersection(grid10, qc_utm)

# st_write(inters, "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/QUEBEC_grid_100x100.gpkg")

#### Quebec grid ####
# ---------- #

qc_grid <- st_read("/home/claire/BDQC-GEOBON/data/QC_in_a_cube/QUEBEC_grid_100x100.gpkg")
plot(qc_grid)


#### Scratch part ####
# ----------- #
m <- matrix(1:20, nrow = 5, ncol = 4)
dim(m) <- c(x = 5, y = 4)
dim(m)
s <- st_as_stars(m)
s
m
image(s, text_values = TRUE, axes = TRUE)

test <- st_as_stars(qc_grid)
plot(st_geometry(test))

pts <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/sf_converted_occurrences/acanthis_flammea.gpkg")
pts_small <- st_geometry(pts)[1:1000000]

pts_small_utm <- st_transform(
    pts_small,
    crs = st_crs(2031)
)

x11()
plot(qc_grid)
x11()
plot(pts_small_utm)

test <- st_intersects(pts_small, qc_grid)
st_crs(qc_grid)
st_crs(pts_small)


#### Explo régions naturelles NIVEAU 1 ####
# ---------- #


reg1 <- sf::st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/QUEBEC_regions_nat.gpkg")
names(reg1)
reg1$ID_NIV_01
reg1$ID_2 <- 1:length(reg1$ID_NIV_01)
x11()
plot(st_geometry(reg1), border = "grey")
reg1$FID01

# labeled polygons
centre1 <- sf::st_centroid(reg1)
graphics::text(st_coordinates(centre1), labels = centre1$ID_2)




#### Explo régions naturelles NIVEAU 2 ####
# ---------- #
reg2 <- sf::st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/QUEBEC_SOUSregions_nat.gpkg")
reg2
reg2$ID_2 <- 1:length(reg2$ID_NIV_02)
centre2 <- sf::st_centroid(reg2)

x11()
plot(st_geometry(reg2))
graphics::text(st_coordinates(centre2), labels = centre2$ID_2, cex = 0.8)
