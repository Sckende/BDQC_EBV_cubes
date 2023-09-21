# Etablir la richesse specifique à partir de donnees brutes
# cad les donnees utilisees par V. Bellavance pour ses modèles SDM
# 6 niveaux spatiales possiblement en production
# 1 - niveau provinces naturelles
# 2 - niveau regions naturelles
# 3 - niveau ensembles physiographiques
# 4 - niveau districts ecologiques
# 5 - niveau pixels 10 x 10 km
# 6 - niveau adaptable selon requête utilisateur (creation fonction)
# au pas de temps annuel entre 1990 & 2019

# *** Construction du cube ****
# valeur de x => temps (annuel)
# valeur de y => spatial

rm(list = ls())

library(sf)
library(terra)

# loading data part 1
mini_occ <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR.gpkg", query = "SELECT * FROM total_occ_pres_only_versionR LIMIT 100000")

species <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR.gpkg", query = "SELECT DISTINCT species FROM total_occ_pres_only_versionR")
spe <- as.vector(species$species)

#### Niveau 1 - niveau provinces naturelles ####
# ---------- #
# 20 polygones

# Data loading part 2
reg <- st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_CR_NIV_01.gpkg")
reg
x11()
plot(st_geometry(reg))

# Projection conversion
st_crs(reg) == st_crs(mini_occ)
reg_conv <- st_transform(reg,
    crs = st_crs(mini_occ)
)

# ----- #
rs_N01_year <- data.frame()


for (i in seq_len(dim(reg_conv)[1])) {
    # for (i in 1:4) { # for testing

    reg <- reg_conv$NOM_PROV_N[i]
    wkt <- st_as_text(st_geometry(reg_conv[i, ]))

    rich_spe <- NULL

    for (j in 1990:2019) {
        year <- j

        occ <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR.gpkg",
            query = paste("SELECT * FROM total_occ_pres_only_versionR WHERE year_obs=", year, sep = ""),
            wkt_filter = wkt,
            quiet = T
        )

        rich <- length(unique(occ$species))

        print(paste("------------------------> Richesse spe dans polygone ", reg, " (", i, "/", dim(reg_conv)[1], ") est de ", rich, " pour l'année ", year, ".", sep = ""))

        rich_spe <- c(rich_spe, rich)
    }

    row_df <- c(reg, rich_spe)

    rs_N01_year <- rbind(rs_N01_year, row_df)
}
names(rs_N01_year) <- c("reg_name", as.character(1990:2019))

# Visualisation
list_rs <- split(rs_N01_year, rs_N01_year$reg_name)
x11()
par(mfrow = c(4, 5))

lapply(list_rs, function(x) {
    nx <- t(x[, -1])
    plot(as.numeric(nx),
        ylim = c(0, 195),
        xlab = "Année",
        ylab = "Richesse spécifique",
        axes = F,
        main = x$reg_name,
        bty = "n",
        type = "h"
    )
    axis(1,
        at = seq_len(length(nx)),
        labels = 1990:2019
    )
    axis(2, at = seq(0, 200, 50), labels = seq(0, 200, 50))
})

# write.table(rs_N01_year,
#             "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_N01.txt", sep = "\t")

#### Niveau 2 - niveau régions naturelles ####
# ---------- #
# 93 polygones

# Data loading
reg <- st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_CR_NIV_02.gpkg")
reg
x11()
plot(st_geometry(reg))

# Projection conversion
st_crs(reg) == st_crs(mini_occ)
reg_conv <- st_transform(reg,
    crs = st_crs(mini_occ)
)

# ----- #
rs_N02_year <- data.frame()


for (i in seq_len(dim(reg_conv)[1])) {
    # for (i in 1:4) { # for testing

    reg <- reg_conv$NOM_REG_NA[i]
    wkt <- st_as_text(st_geometry(reg_conv[i, ]))

    rich_spe <- NULL

    for (j in 1990:2019) {
        year <- j

        occ <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR.gpkg",
            query = paste("SELECT * FROM total_occ_pres_only_versionR WHERE year_obs=", year, sep = ""),
            wkt_filter = wkt,
            quiet = T
        )

        rich <- length(unique(occ$species))

        print(paste("------------------------> Richesse spe dans polygone ", reg, " (", i, "/", dim(reg_conv)[1], ") est de ", rich, " pour l'année ", year, ".", sep = ""))

        rich_spe <- c(rich_spe, rich)
    }

    row_df <- c(reg, rich_spe)

    rs_N02_year <- rbind(rs_N02_year, row_df)
}
names(rs_N02_year) <- c("reg_name", as.character(1990:2019))

# Visualization
list_rs <- split(rs_N02_year, rs_N02_year$reg_name)
x11()
par(mfrow = c(5, 5))

# lapply(list_rs[1:25], function(x) {
# lapply(list_rs[26:50], function(x) {
# lapply(list_rs[51:75], function(x) {
lapply(list_rs[76:93], function(x) {
    nx <- t(x[, -1])
    plot(as.numeric(nx),
        ylim = c(0, 195),
        xlab = "Année",
        ylab = "Richesse spécifique",
        axes = F,
        main = x$reg_name,
        bty = "n",
        type = "h"
    )
    axis(1,
        at = seq_len(length(nx)),
        labels = 1990:2019
    )
    axis(2, at = seq(0, 200, 50), labels = seq(0, 200, 50))
})

# write.table(rs_N02_year,
#             "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_N02.txt", sep = "\t")


#### Niveau 3 - niveau physiographiques ####
# ---------- #
# 402 polygones

# Data loading
reg <- st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_CR_NIV_03.gpkg")
reg
x11()
plot(st_geometry(reg))

# Projection conversion
st_crs(reg) == st_crs(mini_occ)
reg_conv <- st_transform(reg,
    crs = st_crs(mini_occ)
)

# ----- #
rs_N03_year <- data.frame()


for (i in seq_len(dim(reg_conv)[1])) {
    # for (i in 1:4) { # for testing

    reg <- reg_conv$NOM_ENS_PH[i]
    wkt <- st_as_text(st_geometry(reg_conv[i, ]))

    rich_spe <- NULL

    for (j in 1990:2019) {
        year <- j

        occ <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR.gpkg",
            query = paste("SELECT * FROM total_occ_pres_only_versionR WHERE year_obs=", year, sep = ""),
            wkt_filter = wkt,
            quiet = T
        )

        rich <- length(unique(occ$species))

        print(paste("------------------------> Richesse spe dans polygone ", reg, " (", i, "/", dim(reg_conv)[1], ") est de ", rich, " pour l'année ", year, ".", sep = ""))

        rich_spe <- c(rich_spe, rich)
    }

    row_df <- c(reg, rich_spe)

    rs_N03_year <- rbind(rs_N03_year, row_df)
}
names(rs_N03_year) <- c("reg_name", as.character(1990:2019))

# Visualization

# ----> need to a waffle plot here or color on map

# write.table(rs_N03_year,
#             "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_N03.txt", sep = "\t")


#### Niveau 4 - niveau districts écologiques ####
# ---------- #
# 2533 polygones

# Data loading
reg <- st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_CR_NIV_04.gpkg")
reg
x11()
plot(st_geometry(reg))

# Projection conversion
st_crs(reg) == st_crs(mini_occ)
reg_conv <- st_transform(reg,
    crs = st_crs(mini_occ)
)

# ----- #
rs_N04_year <- data.frame()


for (i in seq_len(dim(reg_conv)[1])) {
    # for (i in 1:4) { # for testing

    reg <- reg_conv$NOM_DIST_E[i]
    wkt <- st_as_text(st_geometry(reg_conv[i, ]))

    rich_spe <- NULL

    for (j in 1990:2019) {
        year <- j

        occ <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR.gpkg",
            query = paste("SELECT * FROM total_occ_pres_only_versionR WHERE year_obs=", year, sep = ""),
            wkt_filter = wkt,
            quiet = T
        )

        rich <- length(unique(occ$species))

        print(paste("------------------------> Richesse spe dans polygone ", reg, " (", i, "/", dim(reg_conv)[1], ") est de ", rich, " pour l'année ", year, ".", sep = ""))

        rich_spe <- c(rich_spe, rich)
    }

    row_df <- c(reg, rich_spe)

    rs_N04_year <- rbind(rs_N04_year, row_df)
}
names(rs_N04_year) <- c("reg_name", as.character(1990:2019))
head(rs_N04_year)

# Visualization

# ----> need to a waffle plot here or color on map

# write.table(rs_N04_year,
#             "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_N04.txt", sep = "\t")

#### Niveau 5 & 6 - niveau pixels ####
# ---------- #
# xxxxxx polygones

# Data loading part 2
reg <- st_read("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_CR_NIV_01.gpkg")
reg
x11()
plot(st_geometry(reg))

# Projection conversion - **** passer les occurrences et le fond de carte en UTM ****
# conversion des occurrences via ogr dans terminal
# ogr2ogr -t_srs EPSG:2031 /home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR_UTM.gpkg /home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR.gpkg

reg_UTM <- st_transform(reg,
    crs = st_crs(2031)
)

occs <- st_read("/home/claire/BDQC-GEOBON/data/Bellavance_data/total_occ_pres_only_versionR_UTM.gpkg",
    query = "SELECT * FROM total_occ_pres_only_versionR LIMIT 1000"
)
st_crs(reg_UTM) == st_crs(occs)

# grid creation
x11()
plot(st_geometry(reg_UTM))

cell_size <- c(25000, 25000) # en m

grid <- st_make_grid(reg_UTM,
    cellsize = cell_size,
    square = TRUE
)

# qc_grid <- st_intersection(grid, reg_UTM)

# st_write(qc_grid,
#         "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/QUEBEC_grid_10x10.gpkg")

grid10 <- st_read("/home/claire/BDQC-GEOBON/data/QC_in_a_cube/QUEBEC_grid_10x10.gpkg")
grid10$ID <- 1:dim(grid10)[1]
# st_write(grid10,
#         "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/QUEBEC_grid_10x10.gpkg")

# ==> utilisation de Narval pour obtenir une liste, un niveau de richesse spe par pixel


#### SCRATCH ####
rich <- readRDS("/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_10x10_LIST.rds")


test <- data.frame(
    reg = 1:10,
    an1 = 1:10,
    an2 = 1:10
)
test
sf::st_write(test, "/home/claire/test.gpkg")

test2 <- data.frame(reg = 11, an1 = 11, an2 = 11)

sf::st_write(test2, "/home/claire/test.gpkg", append = T)


as.data.frame(c(11, 11, 11))
data.frame(11, 11, 11)


library(sf)
d <- st_read("/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_10x10.gpkg")
d
d$pix_number
class(d)

write.table(d, paste("./data/QC_CUBE_couche_", i, ".txt", sep = ""), sep="\t")


#Concatenate 2nd lines in several files with bash
sed -s '2!d' *.txt > test_cat2.txt