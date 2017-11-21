#!/bin/bash
#AUTHORSHIP: Benjamin Carter, 2017-09-21
#PURPOSE: This uses the conjunction maps made by make_conjunction_mask.sh to do 3dROIstats and produce some numbers to describe the conjunction maps for all the numerophiles that might read your paper.

###########
#VARIABLES#
###########
START_DIR=$(pwd)
WORK_DIR=/Users/ben88/Documents/Research/fMRI_data/Reading/Compute_data/Group_Analysis/predictability/content3

##########
#COMMANDS#
##########

cd $WORK_DIR

#Find and printout the center of mass for all ROI's

touch $WORK_DIR/Clustsim_output/conjunction_predictability_regions.txt
echo "This contains geometric information about the conjunction analysis" > $WORK_DIR/conjunction_predictability_regions.txt

for i in $(cat $WORK_DIR/conjunction_list.txt); do
    3dclust -1Dformat -orient LPI -1dindex 0 -1tindex 0 -1thresh 3 -dxyz=1 1.75 0 /Users/ben88/Documents/Research/fMRI_data/Reading/Compute_data/Group_Analysis/predictability/content3/$i.HEAD >> $WORK_DIR/conjunction_predictability_regions.txt
done


cd $START_DIR
#End
