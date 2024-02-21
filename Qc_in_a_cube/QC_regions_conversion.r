library(sf)
library(sp)
library(stringr)

#### Provinces naturelles du Québec - CR_N01 ####
# ==> unités territoriales de très grande superficie (10^5 km2) issue d'événements géologiques d'envergure continentale reliés à la tectonique des plaques.

#### Régions naturelles - CR_N02 ####
# ==> unités territoriales de grande superficie (10^4 km2) située à l'intérieur d'une province naturelle, révélée par une configuration particulière du relief, issue de structures géologiques régionales ou d'événements quaternaires majeurs.

#### Ensembles physiographiques - CR_N03 ####
# ==> unités territoriales de 10^3 km2 située à l'intérieur d'une région naturelle, révélée par une configuration particulière du relief, correspondant généralement à une structure géologique ou à un événement quaternaire particulier.

#### Districts écologiquues - CR_N04 ####
# ==> unités territoriales de l'ordre de 10^2 km2 située à l'intérieur d'un ensemble physiographique, révélée par une configuration particulière du relief, correspondant généralement à une structure géologique ou à un événement quaternaire particulier.

#### Ensembles topoghraphiques - CR_N05 ####
# ==> unités territoriales de l'ordre de 10^1 km2 située à l'intérieur d'un district écologique, correspondant à un ensemble (patron d’organisation) de formes simples de relief.


files_short <- list.files("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/CERQ_SHP")

subs <- substring(files_short, 1, 9)
layers <- unique(subs[str_detect(subs, "CR_NIV_")])

# x11(); par(mfrow = c(2, 3))

for (i in seq_len(length(layers))) {
    name_lay <- layers[i]
    print(name_lay)

    lay_sp <- rgdal::readOGR("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/CERQ_SHP", layer = paste(name_lay, "S", sep = "_"))
    # lay_sp <- sp::spTransform(lay_sp, sp::CRS("+proj=longlat +datum=WGS84 +no_defs"))
    lay_sf <- sf::st_as_sf(lay_sp)

    # plot(st_geometry(lay_sf), border = "grey", main = name_lay)

    sf::st_write(lay_sf, paste("/home/claire/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_", name_lay, ".gpkg", sep = ""))
}
