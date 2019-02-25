#!/bin/bash

#This script will make a conjunction mask using the three different regressions as part of the supplementary analysis on the prediction data set.
#By Ben Carter, 2018-04-16

#VARIABLES
START_DIR=$(pwd)
WORK_DIR=/Users/ben88/Documents/Research/fMRI_data/Reading/Compute_data/Group_Analysis2/
RESULTS_DIR=supplementaryConjunction

#datasets
#   predictability1 = first analysis
SYNTAX1=$WORK_DIR/predictability1/clust_pos+tlrc'[3]'
SEMANTICS1=$WORK_DIR/predictability1/clust_lsa+tlrc'[3]'
LEXICAL1=$WORK_DIR/predictability1/clust_ortho+tlrc'[5]'

#   predictability2 = predictability1 + word length and frequency
SYNTAX2=$WORK_DIR/predictability2/clust_pos+tlrc'[3]'
SEMANTICS2=$WORK_DIR/predictability2/clust_lsa+tlrc'[3]'
LEXICAL2=$WORK_DIR/predictability2/clust_ortho+tlrc'[5]'

#   predictability3 = predictability1 - first pass reading time
SYNTAX3=$WORK_DIR/predictability3/clust_pos+tlrc'[3]'
SEMANTICS3=$WORK_DIR/predictability3/clust_lsa+tlrc'[3]'
LEXICAL3=$WORK_DIR/predictability3/clust_ortho+tlrc'[5]'

# predictability5 = predictability1 + function word lexical predictability to baseline
SYNTAX5=$WORK_DIR/predictability5/clust_pos+tlrc'[3]'
SEMANTICS5=$WORK_DIR/predictability5/clust_lsa+tlrc'[3]'
LEXICAL5=$WORK_DIR/predictability5/clust_ortho+tlrc'[5]'


#COMMANDS
cd $WORK_DIR

if [ ! -d $RESULTS_DIR ]
    then mkdir $RESULTS_DIR
fi

cd $WORK_DIR/$RESULTS_DIR

#1 vs 2
    #syntax conjunctions
    3dcalc -prefix posSyntaxConj1v2 -a $SYNTAX1 -b $SYNTAX2 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negSyntaxConj1v2 -a $SYNTAX1 -b $SYNTAX2 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'
    #semantics conjuntions
    3dcalc -prefix posSemanticConj1v2 -a $SEMANTICS1 -b $SEMANTICS2 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negSemanticConj1v2 -a $SEMANTICS1 -b $SEMANTICS2 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'
    #lexical conjunctions
    3dcalc -prefix posLexicalConj1v2 -a $LEXICAL1 -b $LEXICAL2 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negLexicalConj1v2 -a $LEXICAL1 -b $LEXICAL2 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'

#1 vs 3
    #syntax conjunctions
    3dcalc -prefix posSyntaxConj1v3 -a $SYNTAX1 -b $SYNTAX3 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negSyntaxConj1v3 -a $SYNTAX1 -b $SYNTAX3 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'
    #semantics conjuntions
    3dcalc -prefix posSemanticConj1v3 -a $SEMANTICS1 -b $SEMANTICS3 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negSemanticConj1v3 -a $SEMANTICS1 -b $SEMANTICS3 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'
    #lexical conjunctions
    3dcalc -prefix posLexicalConj1v3 -a $LEXICAL1 -b $LEXICAL3 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negLexicalConj1v3 -a $LEXICAL1 -b $LEXICAL3 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'

#1 vs 5
    #syntax conjunctions
    3dcalc -prefix posSyntaxConj1v5 -a $SYNTAX1 -b $SYNTAX5 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negSyntaxConj1v5 -a $SYNTAX1 -b $SYNTAX5 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'
    #semantics conjuntions
    3dcalc -prefix posSemanticConj1v5 -a $SEMANTICS1 -b $SEMANTICS5 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negSemanticConj1v5 -a $SEMANTICS1 -b $SEMANTICS5 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'
    #lexical conjunctions
    3dcalc -prefix posLexicalConj1v5 -a $LEXICAL1 -b $LEXICAL5 -expr 'step(a-3.291) + 2*step(b-3.291)'
    3dcalc -prefix negLexicalConj1v5 -a $LEXICAL1 -b $LEXICAL5 -expr 'isnegative(a+3.291) + 2*isnegative(b+3.291)'

cd $START_DIR
#END#

