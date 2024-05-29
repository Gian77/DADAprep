```bash
  _____          _____                               
 |  __ \   /\   |  __ \   /\                         
 | |  | | /  \  | |  | | /  \   _ __  _ __ ___ _ __  
 | |  | |/ /\ \ | |  | |/ /\ \ | '_ \| '__/ _ \ '_ \ 
 | |__| / ____ \| |__| / ____ \| |_) | | |  __/ |_) |
 |_____/_/    \_\_____/_/    \_\ .__/|_|  \___| .__/ 
                               | |            | |    
                               |_|            |_|    
```
**Prep**are your illumina reads before **DADA**2 pipeline<br>

written by Gian M N Benucci, PhD<br>
email: *benucci@msu.edu*<br>
May 29, 2024<br>

*This pipeline is based upon work supported by the Great Lakes Bioenergy Research Center, U.S. Department of Energy, Office of Science, Office of Biological and Environmental Research under award DE-SC0018409*

__Warning__<br>
### **This pipeline was born for running on the `HPCC` at Michigan State University which run the SLURM (Simple Linux Utility for Resource Management) job scheduler system. If you want to run this piepline in any other systems it will require modification of the main, as well as, the accessory scripts.**

### **Installation**

To use **DADAprep** just clone the directory usign SSH 
```
git clone git@github.com:Gian77/DADAprep.git
```

__Note__ <br> 
* This pipeline run using SLURM (please see bove). **Resourches of each individual job scripts present in the `/mnt/home/benucci/DADAprep/code/` directory MUST be adjusted to the amount of data you want to run for each pipeline run.** In particular the parameters below.

```
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
```

* Data MUST be demultiplexed and all *R1* and *R2* read files copied in the `$project_dir/rawdata/` directory, alongside a `md5sum` checksum file names `md5.txt`.
* The individual scripts in the `code` directory include the buy-in node priority `#SBATCH -A shade-cole-bonito`. If you do not have access to those priority nodes please remove that line in the individual scripts.
* Subdirectories such as `outputs` and `slurms` are part of the workflow, and should be left as they are.
* Please check the config file for options. A few script are additional and are can be avoided to save time.<br>
* The directory called `condaenvs` contain all the `yml` files you can use to recreate the exat conda environments used to develop **DADAprep**. To create a conda environment based on a recipe you can do: `conda env create -f environment-name.yml`.
* Find a good PATH for your Phix genome database, mine is `phix_db="/mnt/research/ShadeLab/Benucci/databases/phix_index/my_phix"`.
* marked if you want your filtered readse to be paried or not using the `paired="yes"` option in the `config.yaml` file.
* set your primers. For example: `fwd_primer="CCTACGGGAGGCAGCAG"` and `rev_primer="GGACTACHVGGGTWTCTAAT"`, again, in your config file.

Run **DADAprep** using `sh DADAprep.sh` 

**DADAprep** output will be a `tar.gz` file in the main directory named e.g. `out_DADAprep_29-05-2024.tar.gz`

