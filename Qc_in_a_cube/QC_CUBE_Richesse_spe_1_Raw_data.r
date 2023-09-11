# Etablir la richesse specifique à partir de donnees brutes
# cad les donnees utilisees par V. Bellavance pour ses modèles SDM
# 6 niveaux spatiales possiblement en production
# 1 - niveau provinces naturelles
# 2 - niveau regions naturelles
# 3 - niveau ensembles physiographiques
# 4 - niveau districts ecologiques
# 5 - niveau pixels 10 x 10 km
# 6 - niveau adaptable selon requête utilisateur (creation fonction)

library(sf)
library(terra)

#### Niveau xxxx ####
# ---------- #

reg <- st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_CR_NIV_02.gpkg")
reg
ssreg <- reg[45, ]
x11()
plot(st_geometry(reg))
plot(st_geometry(ssreg), add = TRUE, border = "red")

# using a bbox as a filter in st_read
# crs total_occ.gpkg ==> +proj=lcc +lat_0=47 +lon_0=-75 +lat_1=49 +lat_2=62 +x_0=0 +y_0=0 +datum=NAD83 +units=km +no_defs
# projection doivent etre les meme !

ssreg2 <- st_transform(ssreg, crs = st_crs("+proj=lcc +lat_0=47 +lon_0=-75 +lat_1=49 +lat_2=62 +x_0=0 +y_0=0 +datum=NAD83 +units=km +no_defs"))

wkt <- st_as_text(st_geometry(ssreg2))

test <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/sf_converted_occurrences/acanthis_flammea.gpkg",
    wkt_filter = wkt
)
st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ.gpkg",
    query = "SELECT * FROM total_occ LIMIT 100"
)

plot(st_geometry(reg))
reg2 <- st_transform(reg, crs = st_crs("+proj=lcc +lat_0=47 +lon_0=-75 +lat_1=49 +lat_2=62 +x_0=0 +y_0=0 +datum=NAD83 +units=km +no_defs"))
st_crs(ssreg2)

library(sf)
wkt <- "POLYGON ((-73.3 45.6, -73.3 46.6, -72.3 46.6, -72.3 45.6, -73.3 45.6))"
species_name <- "accipiter_cooperii"
year <- 2012

occs <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/oiseaux_nicheurs/oiseaux_nicheurs_occurrences.gpkg",
    query = paste0("SELECT geom, year_obs, species FROM total_occ WHERE species='", species_name, "' AND year_obs=", year, " LIMIT 1000")
)

occs <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ.gpkg",
    query = "SELECT * FROM total_occ LIMIT 100000"
)

occs_cloud <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/oiseaux_nicheurs/oiseaux_nicheurs_occurrences.gpkg",
    query = "SELECT * FROM total_occ LIMIT 100000"
)


#### MYSTERYYYYYYYYYY ####
x11()
par(mfrow = c(1, 2))
plot(st_geometry(occs))
plot(st_geometry(occs_cloud), col = "grey")

st_crs(occs) == st_crs(occs_cloud)
st_crs(occs) == st_crs(reg2)

plot(st_geometry(reg2))
plot(st_geometry(occs), add = TRUE)


reg3 <- st_transform(reg, crs = st_crs(occs))
plot(st_geometry(reg3))
plot(st_geometry(occs), add = TRUE)

testt <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/oiseaux_nicheurs/oiseaux_nicheurs_occurrences.gpkg",
    query = paste0("SELECT DISTINCT species FROM total_occ WHERE year_obs=", year)
)
