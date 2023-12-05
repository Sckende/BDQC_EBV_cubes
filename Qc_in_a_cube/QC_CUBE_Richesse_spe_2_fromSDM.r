# OBJ.: Calcul de la richesse spe a partir des aires de repartition produites par V. Bellavance #
# DATA: cartes distribution V. Bellavance - /home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps

library(terra)
library(sf)
library(ratlas)


#### Calcul de la richesse specifique au pixel 10km x 10km ####
# ---------------------------------------------------------- #

species <- list.files("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps")
species2 <- vector()

# Only keep species with a range map
for (i in seq_along(species)) {
    path <- paste0("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps/", species[i])

    if (length(list.files(path)) != 0) {
        species2 <- c(species2, species[i])
    }
}

species2 # 5 species with no map - ammodramus_nelsoni, lagopus_lagopus, lagopus_muta, strix_nebulosa, surnia_ulula

# Raster stack
total_rast_ls <- list()

for (i in seq_along(species2)) {
    path <- paste0("/home/claire/BDQC-GEOBON/data/Bellavance_data/terra_converted_maps/", species2[i], "/maps_range.tif")

    maps <- rast(path)
    m <- maps[[nlyr(maps)]]
    names(m) <- species2[i]

    total_rast_ls[[i]] <- m

    print(i)
}


length(total_rast_ls)

m_stack <- rast(total_rast_ls) # STACK
names(m_stack)

# Species richness computation

spe_rich <- sum(m_stack)
x11()
plot(spe_rich)

#### Calcul de la richesse specifique a l'echelle des hexagones de Atlas ####
# ------------------------------------------------------------------------ #
# **** NON TERMINE ****
hex_tot <- get_regions(type = "hex")
unique(hex_tot$scale_desc)
hex <- get_regions(type = "hex", scale = 100) # erreur "OpenSSL" aleatoire avec linux - si apparait juste relancer la commande - scale = 100 pour le Qc only
st_crs(hex)

# 50 km
hex2 <- get_regions(type = "hex", scale = 50)
x11()
plot(st_geometry(hex2))

# 20 km
# hex3 <- get_regions(type = "hex", scale = 20)
# x11(); plot(st_geometry(hex3))

# crs conversion
hex_trans <- st_transform(hex2,
    crs = st_crs(spe_rich)
)

x11()
plot(spe_rich)
plot(st_geometry(hex_trans), add = T)
plot(st_geometry(hex_trans[60, ]), col = "green", add = T)

nrow(hex2)
for (i in seq_along(nrow(hex2))) {
    poly <- hex2[i, ]
}

test_poly <- hex_trans[60, ]

extr <- max(terra::extract(spe_rich, vect(test_poly))) # richesse spe dans l'hexagone #60
