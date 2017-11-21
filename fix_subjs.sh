#!/bin/bash

#This script fixes timing files so the subject names are all uniform

work_dir=/Users/ben88/Documents/Research/fMRI_data/Reading/Compute_data/TimingFiles/source_csvs
base_csv=MRIDataFileSyntax.csv
output=prediction

cd $work_dir

sed 's/sub/s/g' $base_csv > test.csv
sed 's/s0/s/g' test.csv > test2.csv
sed 's/s9t/s9/g' test2.csv > test3.csv
sed -E 's/s(\d*)/Luke_Reading_S\1/g' test3.csv > test4.csv

mv test4.csv predictions.csv
rm test*.csv
