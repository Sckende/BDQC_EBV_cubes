#### ---- Package loading ---- ####
# ------------------------------- #
library(ratlas)
library(sf)
library(terra)
library(gifski)

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

# Gifs creation for data exploration
for (i in 1:length(unique(obs_sf_utm$name))) {
    # species selection
    species <- unique(obs_sf_utm$name)[i]
    print(species)
    obs <- obs_sf_utm[obs_sf_utm$name == species, ]

    # time range selection
    obs2 <- obs[obs$year > 1989, ] # data from 1990 to 2019 (cf Vincent Bellavance methodo)

    # Grid creation
    g <- st_make_grid(obs2, cellsize = c(10000, 10000))
    grid <- st_cast(g, "MULTIPOLYGON") # conversion from polygon feature to multipolygon
    grid

    # function for plot creation
    makeplot <- function() {
        datalist <- split(obs2, obs2$year)
        seq <- 1

        for (j in 1:length(datalist)) {
            print(names(datalist)[j])

            all_obs <- do.call("rbind", datalist[1:seq])
            pix <- unlist(st_intersects(all_obs, grid))

            plot(grid, border = "grey", main = paste("year", names(datalist)[j], sep = " "))
            plot(st_geometry(grid)[pix], add = TRUE, col = "darkgreen")

            seq <- seq + 1
        }
    }

    # gif creation
    save_gif(makeplot(),
        paste("/home/claire/BDQC-GEOBON/data/EBVs/gifs/",
            species,
            ".gif",
            sep = ""
        ),
        delay = 0.8
    )
}
