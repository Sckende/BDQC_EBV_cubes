# == > finalement remplacé par une boucle dans le script R et envoyé sur Narval

# Slurm returns an error for array above 10k
# loop over simulations so each batch is limited to 10k arrays
sim_pars <- 19780 # number of pixels

i_max <- floor(sim_pars / 100) # Doit correspondre au fichier R envoyé avec SBATCH
batch_max <- rep(100, i_max)
batch_max[i_max + 1] <- sim_pars - sum(batch_max)

# write slurm bash file
for (i in 0:i_max)
{
  bash_file <- paste0("#!/bin/bash
#SBATCH --account=def-dgravel
#SBATCH -t 00:10:00
#SBATCH --mem=3200
#SBATCH --job-name=RS_10x10_pix_", i, "
#SBATCH --mail-user=juhc3201@usherbrooke.ca
#SBATCH --mail-type=ALL
#SBATCH --array=1-", batch_max[i + 1], "

module load StdEnv/2020 gcc/9.3.0 gdal/3.5.1 r/4.3.1

BATCH=", i, " Rscript QC_CUBE_Richesse_spe_10x10_bash.r
")

  # save bash file
  writeLines(bash_file, paste0("RS_10x10_pix_", i, ".sh"))
}

for (i in 0:i_max)
{
  Sys.sleep(2)
  # run slurm
  system(paste0("sbatch RS_10x10_pix_", i, ".sh"))
}



#### Dans le second script r ####
# Env variables
batch_id <- as.numeric(Sys.getenv("BATCH"))
array_id <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID")) + (100 * batch_id)
# csv variables
# pars <- read_csv('simulation_pars.csv')[array_id, ]
