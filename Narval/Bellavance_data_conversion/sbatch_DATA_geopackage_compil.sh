#!/bin/bash
#SBATCH --account=def-dgravel
#SBATCH -t 03:00:00
#SBATCH --mem=100000
#SBATCH --job-name=data_gpkg_compil
#SBATCH --mail-user=juhc3201@usherbrooke.ca
#SBATCH --mail-type=ALL


module load StdEnv/2020 gcc/9.3.0 gdal/3.5.1 r/4.3.1
Rscript DATA_geopackage_compil.r
