#!/bin/bash

#This script will perform a conjunction analysis on the prediction data set.
#By Ben Carter, 2017-09-14.

#VARIABLES
START_DIR=$(pwd)
WORK_DIR=/Users/ben88/Documents/Research/fMRI_data/Reading/Compute_data/Group_Analysis/predictability/content3
SYNTAX=$WORK_DIR/pred_pos+tlrc'[3]'
SEMANTICS=$WORK_DIR/pred_lsa+tlrc'[3]'
LEXICAL=$WORK_DIR/pred_lsa+tlrc'[5]'

#COMMANDS
cd $WORK_DIR
3dcalc -prefix predPosSyn+SemConj_map -a $SYNTAX -b $SEMANTICS -expr 'step(a-3.291) + 2*step(b-3.291)'

3dcalc -prefix predNegSyn+SemConj_map -a $SYNTAX -b $SEMANTICS -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'

3dcalc -prefix predPosSem+LexConj_map -a $SEMANTICS -b $LEXICAL -expr 'step(a-3.291) + 2*step(b-3.291)'

3dcalc -prefix predNegSem+LexConj_map -a $SEMANTICS -b $LEXICAL -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'

3dcalc -prefix predPosSyn+LexConj_map -a $SYNTAX -b $LEXICAL -expr 'step(a-3.291) + 2*step(b-3.291)'

3dcalc -prefix predNegSyn+LexConj_map -a $SYNTAX -b $LEXICAL -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'

cd $START_DIR
#END#
