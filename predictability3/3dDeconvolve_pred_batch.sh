#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 01/10/2017

#############
#ENVIRONMENT#
#############

HOME_DIR=/fslhome/ben88/compute/Reading/Compute_data
SCRIPT_DIR=${HOME_DIR}/Scripts
SUBJ_DIR=${HOME_DIR}/SubjData

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
for subj in $(ls ${SUBJ_DIR})
    do
    sbatch \
        -o ~/logfiles/${var}/output_${subj}.txt \
        -e ~/logfiles/${var}/error_${subj}.txt \
        ${SCRIPT_DIR}/predictability/predictability3/3dDeconvolve_pred_job.sh \
        ${subj}
        sleep 1
done
