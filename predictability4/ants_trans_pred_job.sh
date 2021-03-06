#!/bin/sh

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "ANTS4"  # job name

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

export ANTSPATH=/fslhome/ben88/apps/ants/bin
PATH=${ANTSPATH}:${PATH}

AFNI_BIN=/fslhome/ben88/abin
HOME_DIR=/fslhome/ben88/compute/Reading/Compute_data
    SCRIPT_DIR=${HOME_DIR}/Scripts
        antifyFunk=$SCRIPT_DIR/ANTifyFunctional
    subj_DIR=${HOME_DIR}/SubjData/${1}
TEMPLATE=~/templates/Cthulhu/cthulhu_mni_template.nii.gz
LOG=/fslhome/ben88/logfiles

##########
#COMMANDS#
##########

#  Created by Benjamin Carter on 03/20/2017.
#  This script performs an ants transformation of the structural and functional files generated by regression_job.sh and regression_batch.sh scripts.


cd $subj_DIR
cd afni_data

#####################
#REGRESSION ANALYSIS#
#####################


#Convert struc file from dicom to nifti
if [ ! -f struct_rotated.nii.gz ]
then
${AFNI_BIN}/3dcopy struct_rotated+orig struct_rotated.nii.gz
fi

#Put the structural dataset through the ANTs pipeline
if [ -f struct_rotated.nii.gz ] && [ ! -f struct_rotatedWarp.nii ]
    then
        dim=3
        template=${TEMPLATE}
        scan=struct_rotated.nii.gz
        ~/apps/ants/bin/ants.sh ${dim} ${template} ${scan}
fi

#apply the ANTs transformation to the functional data. Requires the following files:
#struct_rotatedWarp.nii & struct_rotatedAffine.txt in the subject directory
#modeltemplate.nii.gz & ANTifyFunctional in the main study directory
#Also assumes that ANTs is installed on your system.

cd $subj_DIR/afni_data/predictability4/

${antifyFunk} $subj_DIR/afni_data/struct_rotated ${TEMPLATE} $subj_DIR/afni_data/predictability4/predictability_deconv_blur5+orig


#cd back to the main study directory
cd ${HOME_DIR}
