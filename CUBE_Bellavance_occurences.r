library(sf)
library(sp)

file_sf <- readRDS("/home/claire/BDQC-GEOBON/data/Bellavance_data/sf_converted_occurrences/aquila_chrysaetos.rds")
file_sp <- readRDS("/home/claire/BDQC-GEOBON/data/Bellavance_data/original_occurrences/aquila_chrysaetos.rds")

file <- file_sp

head(file)
class(file)
range(file$year_obs)
mapview::mapview(file)
# split data - mobile window for 5 years

step5 <- list()
niv_list <- 1
for (i in 1992:2017) {
    print(niv_list)
    print(i)

    data <- file[file$year_obs %in% (i - 2):(i + 2), ]

    step5[[niv_list]] <- data
    names(step5)[niv_list] <- i

    niv_list <- niv_list + 1
}

length(step5)
class(step5)
names(step5)
class(step5[[1]])

plot(step5[[20]])


# test for k95
library(adehabitatHR)

str(step5, max.level = 2)

details_ls <- list()

for (i in 1:length(step5)) {
    print(names(step5)[i])

    data <- step5[[i]]
    data_utm <- spTransform(
        data,
        CRS("+init=epsg:2031")
    )
    KUD <- kernelUD(data_utm,
        h = "href"
    )
    KUDvol <- getvolumeUD(KUD)

    ver95 <- getverticeshr(KUDvol, 95)

    details_ls[[i]] <- ver95
    names(details_ls)[i] <- names(step5)[i]
}

plot(details_ls)

lapply(details_ls, plot)
x11()
par(mfrow = c(4, 4))

for (i in 1:length(details_ls)) {
    plot(details_ls[[i]], main = names(details_ls)[i])
}

areas <- as.data.frame(unlist(lapply(details_ls, function(x) {
    x$area
})))

areas$year <- 1992:2006
names(areas)[1] <- "area"

plot(
    x = areas$year,
    y = areas$area
)
mapview::mapview(details_ls)
