#!/bin/sh

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "decon3"  # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

###############
#ENVIRONMENTAL#
###############


AFNI_BIN=/fslhome/ben88/abin
HOME_DIR=/fslhome/ben88/compute/Reading/Compute_data
	SCRIPT_DIR=${HOME_DIR}/Scripts
		antifyFunk=$SCRIPT_DIR/ANTifyFunctional
	subj_DIR=${HOME_DIR}/SubjData/${1}
	TEMPLATE=${HOME_DIR}/templates/
	TIMING=${HOME_DIR}/TimingFiles/predictability
        TIMING_ORTHO=$TIMING/ortho_noDM/${1}.txt
        TIMING_POS=$TIMING/pos_noDM/${1}.txt
        TIMING_LSA=$TIMING/lsa_noDM/${1}.txt
LOG=/fslhome/ben88/logfiles

##########
#COMMANDS#
##########

#  Created by Benjamin Carter on 03/20/2017.
#  This script performs Ordinary Least Square Regression of subject data using 3dDeconvolve from the AFNI software package.


cd $subj_DIR
cd afni_data

if [ ! -d predictability3 ]
    then
        mkdir predictability3
fi

cd predictability3

#####################
#REGRESSION ANALYSIS#
#####################



if [ -f $TIMING_POS ] && [ ! -f predictability_deconv+orig.BRIK ]
    then
        #3dDeconvolve
        ${AFNI_BIN}/3dDeconvolve \
            -input $subj_DIR/afni_data/epi1_volreg+orig $subj_DIR/afni_data/epi2_volreg+orig $subj_DIR/afni_data/epi3_volreg+orig \
            -mask $subj_DIR/afni_data/struct_mask+orig \
            -polort A \
            -num_stimts 9 \
            -stim_file 1 "$subj_DIR/motion/motion.txt[0]" -stim_label 1 "Roll"  -stim_base   1 \
            -stim_file 2 "$subj_DIR/motion/motion.txt[1]" -stim_label 2 "Pitch" -stim_base   2 \
            -stim_file 3 "$subj_DIR/motion/motion.txt[2]" -stim_label 3 "Yaw"   -stim_base   3 \
            -stim_file 4 "$subj_DIR/motion/motion.txt[3]" -stim_label 4 "dS"    -stim_base   4 \
            -stim_file 5 "$subj_DIR/motion/motion.txt[4]" -stim_label 5 "dL"    -stim_base   5 \
            -stim_file 6 "$subj_DIR/motion/motion.txt[5]" -stim_label 6 "dP"    -stim_base   6 \
            -stim_times_AM2 7 ${TIMING_POS} 'dmBLOCK' -stim_label 7 "POS" \
            -stim_times_AM2 8 ${TIMING_LSA} 'dmBLOCK' -stim_label 8 "LSA" \
            -stim_times_AM2 9 ${TIMING_ORTHO} 'dmBLOCK' -stim_label 9 "ORTHO" \
            -num_glt 3 \
            -gltsym 'SYM: POS' \
            -glt_label 1 POS \
            -gltsym 'SYM: LSA' \
            -glt_label 2 LSA \
            -gltsym 'SYM: ORTHO' \
            -glt_label 3 ORTHO \
            -censor "$subj_DIR/motion/motion_censor_vector.txt[0]" \
            -nocout -tout \
            -bucket predictability_deconv \
            -xjpeg predictability_design.jpg \
            -jobs 2 \
            -GOFORIT 12
fi



#blur the output of the regression analysis
if [ -f predictability_deconv+orig.BRIK ] && [ ! -f predictability_deconv_blur5+orig.BRIK ]
    then
        ${AFNI_BIN}/3dmerge -prefix predictability_deconv_blur5 -1blur_fwhm 5.0 -doall predictability_deconv+orig
fi
