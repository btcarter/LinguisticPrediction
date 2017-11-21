#!/bin/sh

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "ppRead"   # job name

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
LOG=/fslhome/ben88/logfiles
SCRIPT_DIR=${HOME_DIR}/Scripts
subj_DIR=${HOME_DIR}/SubjData/${1}


##########
#COMMANDS#
##########

#  Created by Benjamin Carter on 01/09/2017.
#  This script performs all preprocessing necessary for AFNI analysis of subject data and overlaying it on t1 data.


cd $subj_DIR

#Rename raw data file and create raw data and preproc data files

if [ -d ${subj_DIR}/Research_Luke* ]
    then
        mv ${subj_DIR}/Research_Luke* ${subj_DIR}/raw_data/
fi

if [ ! -d ${subj_DIR}/afni_data ]
    then
        mkdir ${subj_DIR}/afni_data
fi

PPROC=${subj_DIR}/afni_data
RAW_DIR=${subj_DIR}/raw_data

cd $PPROC

#####################
#PREP FILES FOR AFNI#
#####################

#Import functional from DICOM to AFNI
#figure out how many TRs there were in the run

if [ ! -f $PPROC/epi1+orig.BRIK ]
    then
        epi1TRs=`ls -1 ${RAW_DIR}/EPI_Run1*/*.dcm | wc -l`
        ${AFNI_BIN}/to3d -time:zt 43 $epi1TRs 2500 alt+z -prefix epi1 ${RAW_DIR}/EPI_Run1*/*.dcm
        epi2TRs=`ls -1 ${RAW_DIR}/EPI_Run2*/*.dcm | wc -l`
        ${AFNI_BIN}/to3d -time:zt 43 $epi2TRs 2500 alt+z -prefix epi2 ${RAW_DIR}/EPI_Run2*/*.dcm
        epi3TRs=`ls -1 ${RAW_DIR}/EPI_Run3*/*.dcm | wc -l`
        ${AFNI_BIN}/to3d -time:zt 43 $epi3TRs 2500 alt+z -prefix epi3 ${RAW_DIR}/EPI_Run3*/*.dcm
fi

#import structural

if [ ! -f $PPROC/struct+orig.BRIK ]
    then
        ${AFNI_BIN}/to3d -prefix struct ${RAW_DIR}/t1_mpr_sag_iso_*/*.dcm
fi

###########################################
#CO-REGISTRATION AND SLICE-TIME CORRECTION#
###########################################


#Co-register structural to functional:

if [ ! -f $PPROC/struct_rotated+orig.BRIK ]
    then
        ${AFNI_BIN}/3dWarp -oblique_parent epi3+orig -prefix struct_rotated struct+orig
fi

#Slice-time correction

if [ ! -f $PPROC/epi1_shift+orig.BRIK ]
    then
        ${AFNI_BIN}/3dTshift -verbose -prefix epi1_shift epi1+orig
        ${AFNI_BIN}/3dTshift -verbose -prefix epi2_shift epi2+orig
        ${AFNI_BIN}/3dTshift -verbose -prefix epi3_shift epi3+orig
fi

###################
#MOTION CORRECTION#
###################


#motion correction within each run

if [ ! -d ${subj_DIR}/motion ]
    then
        mkdir ${subj_DIR}/motion
fi

MOVE=${subj_DIR}/motion

if [ ! -f $PPROC/epi1_volreg+orig.BRIK ]
    then
        ${AFNI_BIN}/3dvolreg -base 'epi1_shift+orig[69]' -prefix epi1_volreg -1Dfile ${MOVE}/motion_1 epi1_shift+orig
        ${AFNI_BIN}/3dvolreg -base 'epi2_shift+orig[69]' -prefix epi2_volreg -1Dfile ${MOVE}/motion_2 epi2_shift+orig
        ${AFNI_BIN}/3dvolreg -base 'epi3_shift+orig[69]' -prefix epi3_volreg -1Dfile ${MOVE}/motion_3 epi3_shift+orig
fi

#concatenate the two motion regressor text files into a single motion.txt file

if [ ! -f ${subjDIR}/afni_data/motion.txt ]
    then
        cat ${MOVE}/motion_1 >> ${MOVE}/motion.txt
        cat ${MOVE}/motion_2 >> ${MOVE}/motion.txt
        cat ${MOVE}/motion_3 >> ${MOVE}/motion.txt
        mv ${MOVE}/motion.txt ${subjDir}/afni_data/motion.txt
fi

#motion correction between runs

if [ ! -f $PPROC/epi2_aligned+org.BRIK ]
    then
        ${AFNI_BIN}/3dvolreg -base 'epi3_volreg+orig[69]' -prefix epi2_aligned epi2_volreg+orig
        ${AFNI_BIN}/3dvolreg -base 'epi3_volreg+orig[69]' -prefix epi1_aligned epi1_volreg+orig
fi

#create the censor file. Requires the following file:
#move_censor.pl

if [ ! -f ${subjDIR}/afni_data/motion_censor_vector.txt ]
    then
        cd ${MOVE}
        $SCRIPT_DIR/move_censor.pl
        mv ${MOVE}/motion_censor_vector.txt ${subjDIR}/afni_data/motion_censor_vector.txt
        cd ${PPROC}
fi


##########################
#BRAIN & GM MASK CREATION#
##########################
# If 3dSkullStrip doesn't work, try running the 'fix_afni.txt' script found in the main study directory.


#Skull stripping
if [ ! -f $PPROC/struct_brain.ply ]
    then
        ${AFNI_BIN}/3dSkullStrip -input struct_rotated+orig -o_ply struct_brain
fi

#Resample Brain image to EPI resolution
if [ ! -f $PPROC/struct_resamp+orig.BRIK ]
    then
        ${AFNI_BIN}/3dfractionize -template epi3_volreg+orig. -input struct_brain+orig. -prefix struct_resamp
fi

#Create a brain mask
if [ ! -f $PPROC/struct_mask+orig.BRIK ]
    then
        ${AFNI_BIN}/3dcalc -a struct_resamp+orig. -prefix struct_mask -expr "step(a)"
fi


#########
#THE END#
#########
