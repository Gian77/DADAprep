#!/bin/bash

cat << "EOF"
  _____          _____                               
 |  __ \   /\   |  __ \   /\                         
 | |  | | /  \  | |  | | /  \   _ __  _ __ ___ _ __  
 | |  | |/ /\ \ | |  | |/ /\ \ | '_ \| '__/ _ \ '_ \ 
 | |__| / ____ \| |__| / ____ \| |_) | | |  __/ |_) |
 |_____/_/    \_\_____/_/    \_\ .__/|_|  \___| .__/ 
                               | |            | |    
                               |_|            |_|    

EOF

echo -e "
Hello there, this is DADAprep, a pipeline to prepare your illumina reads to run DADA2\n
DADAprep v.1.0 by Gian M. N. Benucci, P.hD.
email: benucci[at]msu[dot]edu
May 24, 2024
\n"

echo -e "This pipeline is based upon work supported by the Great Lakes Bioenergy Research
Center, U.S. Department of Energy, Office of Science, Office of Biological and Environmental
Research under award DE-SC0018409\n"

source ./config.yaml

cd $project_dir/rawdata/

echo -e "\n========== Comparing md5sum codes... ==========\n"

md5=$project_dir/rawdata/md5.txt

if [[ -f "$md5" ]]; then
		echo -e "\nAn md5 file exist. Now checking for matching codes.\n"
		md5sum md5* --check > tested_md5.results
		cat tested_md5.results
		resmd5=$(cat tested_md5.results | cut -f 2 -d" " | uniq)

		if [[ "$resmd5" = "OK" ]]; then
				echo -e "\n Good news! Files are identical. \n"
		else
				echo -e "\n Oh oh! You are in trouble. Your files are different from those at the source! \n"
				echo -e "\nSomething went wrong during files download. Try again, please.\n"
				exit
		fi
else
	echo "No md5 file was found. You should look for it, and start over again!"
fi

cd $project_dir/code/

echo -e "\n========== What I will do for you? Please see below... ==========\n"

echo -e "\n========== Prefiltering ==========\n" 

jid1=`sbatch 01_decompress-bash.sb | cut -d" " -f 4`
echo "$jid1: For starting, I will decompress your raw reads files."

jid2=`sbatch --dependency=afterok:$jid1 02_qualityCheck.sb | cut -d" " -f 4`
echo "$jid2: I will check the quality and generate statistics."

jid3=`sbatch --dependency=afterok:$jid1:$jid2 03_removePhix-bowtie2.sb | cut -d" " -f 4`
echo "$jid3: I will remove Phix reads with bowtie2."

if [[ "$paired" = "no" ]]; then
	jid4=`sbatch --dependency=afterok:$jid3 04_primerStrip-cutadapt.sb  | cut -d" " -f 4`
	echo "$jid4: I will run cutadapt on R1 and R2 separaetly. Stats are generated as well..."

	jid6=`sbatch --dependency=afterok:$jid4 06_getResults-bash.sb | cut -d" " -f 4`
	echo "$jid6: I will organize and .gz all the results."

elif [[ "$paired" = "yes" ]]; then
	jid5=`sbatch --dependency=afterok:$jid3 05_primerStrip-cutadapt.sb  | cut -d" " -f 4`
	echo "$jid5: I will run cutadapt on R1 and R2 together. Stats are generated as well..."

	jid6=`sbatch --dependency=afterok:$jid5 06_getResults-bash.sb | cut -d" " -f 4`
	echo "$jid6: I will organize and .gz all the results."

fi


echo -e "\n========== 'This is the end, my friend'... Now, be patient, you have to wait a bit... ==========\n"
