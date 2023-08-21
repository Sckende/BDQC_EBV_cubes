#### ---- Package loading ---- ####
# ------------------------------- #
library(ratlas)
library(sf)
library(terra)

#### ---- data extraction ---- ####
# ------------------------------- #

emv <- c(
    "Aquila chrysaetos",
    "Catharus bicknelli",
    "Setophaga cerulea",
    "Ixobrychus exilis",
    "Coturnicops noveboracensis"
)

taxa <- get_taxa(scientific_name = emv)
taxa$id_taxa_obs

obs <- get_observations(
    id_taxa = taxa$id_taxa_obs
)
dim(obs)
head(obs)
class(obs)
names(obs)
summary(obs$within_quebec)

# spatial object
obs_sf <- cbind(
    obs$id,
    obs$year_obs,
    obs$taxa_valid_scientific_name,
    obs$geom
)

#### ---- projection conversion - from latlon to UTM ---- ####
# ---------------------------------------------------------- #


obs_sf_utm <- st_transform(
    obs_sf,
    crs = st_crs(2031)
)
names(obs_sf_utm) <- c("id", "year", "name", "geometry")

x11()
plot(
    st_geometry(obs_sf_utm),
    type = "p",
    pch = 20
)
#### ---- Grid creation ---- ####
# ---------------------------- #
cell_size <- c(10000, 10000)
grid10 <- st_make_grid(
    obs_sf_utm,
    cellsize = cell_size,
    square = TRUE
)
# plot(
#     grid10,
#     add = TRUE
# )

#### ---- flow develop for one species ---- ####
# -------------------------------------------- #
# data selection

unique(obs_sf_utm$name)
spe <- obs_sf_utm[obs_sf_utm$name == "Catharus bicknelli", ]
dim(spe)

plot(spe, col = "red", add = T)

# data from 1990 to 2019 (cf Vincent Bellavance methodo)
table(spe$year)
spe <- spe[spe$year > 1989, ]
length(unique(spe$year))

# grid creation
grid10_grive <- st_make_grid(spe, cellsize = c(10000, 10000))
g <- st_cast(grid10_grive, "MULTIPOLYGON") # conversion from polygon feature to multipolygon

# polygon selection containing obs
pix <- unlist(st_intersects(spe, g))

# vizualisation of pixels with obs
plot(st_geometry(g)[pix])
plot(st_geometry(spe), add = T, col = "red")
# gif creation - 1 map per year
spe_ls <- split(spe, spe$year)
names(spe_ls)

seq <- 1
for (i in 1:length(spe_ls)) {
    png(
        paste("/home/claire/BDQC-GEOBON/data/EBVs/maps/test_grive/gif/gif_grive-",
            names(spe_ls)[i],
            ".png",
            sep = ""
        ),
        res = 300,
        width = 50,
        height = 40,
        pointsize = 20,
        unit = "cm",
        bg = "white"
    )

    print(names(spe_ls)[i])

    g2 <- do.call("rbind", spe_ls[1:seq])

    pix <- unlist(st_intersects(spe_ls[[i]], g))


    # print(
    plot(st_geometry(g), main = paste("year", names(spe_ls)[i], sep = " "))
    plot(st_geometry(g2)[pix], add = TRUE, col = "darkgreen")


    # )
    dev.off()

    seq <- seq + 1
}
# ==> à continuer
