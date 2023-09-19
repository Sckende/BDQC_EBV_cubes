library(sf)

# Creation of an empty LIST
rs_10x10_year <- list()
# saveRDS(rs_10x10_year, "/home/claire/BDQC-GEOBON/data/QC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_10x10_LIST.rds")


# Get array number
i <- as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))

# Get the polygon
pol <- st_read("./data/QUEBEC_GRID_10x10.gpkg",
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

row_df <- c(pol, rich_spe)

ll <- readRDS("./data/QC_CUBE_Richesse_spe_10x10_LIST.rds")
ll[[i]] <- row_df

saveRDS(
    ll,
    "./data/QC_CUBE_Richesse_spe_10x10_LIST.rds"
)
