library(sf)

files <- list.files(paste(getwd(), "/sf_converted_occ", sep = ""), full.names = TRUE)

first <- sf::st_read(files[1])

total <- sf::st_write(first, paste(getwd(), "total_occ.gpkg", sep = "/"))

for (i in 2:195) {
    other <- sf::st_read(files[i])
    sf::st_write(other, paste(getwd(), "total_occ.gpkg", sep = "/"), append = TRUE)

    print(paste("-------------------> DONE - ", print(i), "/195"))
}
