## Summary
This is the repository for the code for the paper entitled [Linguistic networks associated with lexical, semantic and syntactic predictability in reading: a fixation-related fMRI study](https://doi.org/10.1016/j.neuroimage.2019.01.018) and an associated Data in Brief currently under review.

## What to do with this repository and its contents

### Sample data
Data to test these scripts are provided in *sampleData*. Eye tracking data are found in *eyetracking/source*. These were generated using SR Research Software (Data Viewer). Individual timing files were constructed from these using various scripts (see below) and are found in *eyetracking/timing*. MRI data for each participant can be found in *sampleData/mri/* with a directory for each participant (*Luke_Reading_S*). Participant DICOMS are found in *raw_data* and output are found in *afni_data*. Motion censor files are contained in *motion*. *structuralTemplate* contains the structural templates used to warp individual statistical results into MNI space.

### Scripts
These scripts were written for both the remote SLURM and local computing environment. In order to test or implement them it will be necessary to update the paths for both inputs and outputs. Variables for such are located at the beginning of each script.

#### Dependencies
<ul>
	<li><a href="https://afni.nimh.nih.gov">Analysis of Functional NeuroImages (AFNI)</a></li>
	<li><a href="http://stnava.github.io/ANTs/">Advanced Normalization Tools (ANTs)</a></li>
	<li><a href="https://www.r-project.org">The R Project</a></li>
</ul>

#### Suggested order of execution
Create the hemodynamic response functions first, followed by preprocessing, deconvolution and 3dttest++. 

##### HRF construction
Ideal HRFs were constructed using scripts found in the *timing* directory and were executed locally. Here is a list of these scripts, which analysis they were made for and which hemodynamic profile they created.

| Script | Analysis | What was modeled | Source fixation report |
|---|---|---|
| `event_LSA.r` | 1, 2, 4 | Semantic predictability with fixation duration | predictions.csv |
| `event_pos.R` | 1, 2, 4 | Syntactic predictability with fixation duration | predictions.csv |
| `event_orth.R`| 1, 2, 4 | Lexical predictability with fixation duration | predictions.csv |
| `length.R` | 2 | Word length | predictionwlengthandfrequency.csv |
| `frequency.R` | 2 | Word frequency | predictionwlengthandfrequency.csv |
| `lsa_noDuration.R` | 3 | Semantic predictability without fixation duration | predictions.csv |
| `pos_noDuration.R` | 3 | Syntactic predictability without fixation duration | predictions.csv |
| `ortho_noDuration.R` | 3 | Lexical predictability without fixation duration | predictions.csv |
| `orthoFunction.r` | 4 | Lexical predictability of function words | predictions.csv |

#### Preprocessing
Preprocessing is carried out via `preproc_batch.sh` and `preproc_job.sh`. Both scripts were written for the SLURM environment. The paths to inputs must be set prior to script execution and can be found under `ENVIRONMENT`. `preproc_batch.sh` submits an iteration of `preproc_job.sh` for each subject and creates a directory to store error and output information for debugging purposes. `preproc_job.sh` does the heavy lifting (i.e. reorganizes directory structure, creates BRIK and HEADER files, performs co-registration, slice-time correction, motion correction, motion censoring, and creates various masks). Motion censoring is dependent on `move_censor.pl`. If this step breaks then double check the path set with `$SCRIPT_DIR`.

#### Deconvolution and T-test
Deconvolution scripts were also written for the SLURM environment. Each *predictability* directory contains a different analysis pipeline. The pipeline found in *predictability1* was used for the study currently published as [Carter, Foster, Muncy and Luke (2019)](https://doi.org/10.1016/j.neuroimage.2019.01.018). The pipelines found in *predictability* directories 2-4 were created for the supplementary analysis discussed in the Data in Brief. 

Each directory contains a scripts named `3dDeconvolve_pred_batch.sh`, `3dDeconvolve_pred_job.sh`, `ants_trans_pred_batch.sh`, `ants_trans_pred_job.sh`, `3dttest_pred_batch.sh`, and `3dttest_pred_job.sh`. Scripts with the suffix `_batch.sh` reference scripts with the suffix `_job.sh`. The names are somewhat explanatory of function, and scripts were executed as follows: Deconvolution (prefix: `3dDeconvolve`) was performed first. This script relies on paths to the HRF profiles and the BRIK and HEADER files created during preprocessing (see `ENVIRONMENT`). This also applies a 5mm blur to the output. ANTs transformation was applied next. As you may have anticipated please ensure the proper paths are set for the variables in `ENVIRONMENT`. This script converts T<sub>1</sub> DICOMS to NIFTI format and applies an ANTs transformation to warp a participant's structural data into study template space ([see Nathan Muncy's GitHub for more information on how to make one](https://github.com/nmuncy/Linguistics)). This step is dependent on `ANTifyFunctional` (a script originally written by Craig Stark, with some modifications by Brock Kirwan). Student's T-tests were then performed via `3dttest_pred_batch.sh` and `3dttest_pred_job.sh` and group statistical maps were output to the *Group_Analysis* directory. Lines 54-288 will need to be edited in `3dttest_pred_job.sh` in order to test this step as only a subset of the subjects are offered in the sample dataset. The full dataset can be made available upon request.

Group results were then used to create conjunction maps. Conjunction maps for the primary analysis were created via `make_conjunction_mask.sh`. Conjunction maps comparing the second, third and fourth datasets to the primary were created via `supplementaryConjunction.sh`. Paths must be set under `VARIABLES` prior to execution.

#### fMRI script order and output

| Step | Script | Local or Remote | Output |
|------|--------|-----------------|--------|
| Preprocessing | `preproc_batch.sh` & `preproc_job.sh` | Remote SLURM | - |
| Deconvolution | `3dDeconvolve_pred_batch.sh` & `3dDeconvolve_pred_job.sh` | Remote SLURM | - |
| ANTs Transformation | `ants_trans_pred_batch.sh` & `ants_trans_pred_job.sh` | Remote SLURM | - |
| T-test | `3dttest_pred_batch.sh` & `3dttest_pred_job.sh` | Remote SLURM | - |
| Conjunction Maps | `make_conjunction_mask.sh` | Local | - |
|  | `supplementaryConjunction.sh` | Local | - |

### FAQs

Q: Why didn't I use BIDS format when structuring the data?
A: Didn't know about it at the time I put this together. Now that I do I use it in my latest projects. For more information on BIDs format see [Gorgolewski, et al., 2016](https://www.nature.com/articles/sdata201644).

Q: What do the terms LSA, POS and ORTHO stand for? They appear everywhere.
A: These are the prefixes used to denote the experimental condition. LSA = latent semantic analysis (semantic predictability), POS = part of speech (syntactic predictability), and ORTHO = orthographic (or lexical predictability).