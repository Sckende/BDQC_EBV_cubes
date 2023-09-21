library(sf)

# Get array number 2-+++
i <- as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))

# Get the polygon
pol <- st_read("./data/QUEBEC_grid_10x10.gpkg",
    query = paste("SELECT * FROM QUEBEC_GRID_10x10 WHERE ID=", i, sep = "")
)

# spatial filter
pix_number <- i
wkt <- st_as_text(st_geometry(pol))

# Species richness computation
rich_spe <- NULL

for (j in 1990:2019) {
    year <- j

    occ <- st_read("./data/total_occ_pres_only_versionR_UTM.gpkg",
        query = paste("SELECT * FROM total_occ_pres_only_versionR WHERE year_obs=", year, sep = ""),
        wkt_filter = wkt,
        quiet = T
    )

    rich <- length(unique(occ$species))

    print(paste("------------------------> Richesse spe dans polygone ", i, " est de ", rich, " pour l'année ", year, ".", sep = ""))

    rich_spe <- c(rich_spe, rich)
}

row_df <- c(pix_number, rich_spe)
df <- data.frame(row_df)
names(df) <- c("pix_number", 1990:2019)

# save the file
Sys.sleep(runif(1))
sf::st_write(df, paste(getwd(), "QC_CUBE_Richesse_10x10.gpkg", sep = "/"), append = T)
