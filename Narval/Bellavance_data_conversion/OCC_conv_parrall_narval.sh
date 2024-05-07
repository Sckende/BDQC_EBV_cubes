#!/bin/bash
#SBATCH --array=1-195
#SBATCH --account=def-dgravel
#SBATCH -t 00:20:00
#SBATCH --mem=10000
#SBATCH --job-name=data_conversion
#SBATCH --mail-user=juhc3201@usherbrooke.ca
#SBATCH --mail-type=ALL

echo $SLURM_ARRAY_TASK_ID

module load StdEnv/2020 gcc/9.3.0 gdal/3.5.1 r/4.3.1
Rscript test_script_slurm.r
