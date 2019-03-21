This is the repository for the code for the paper entitled [Linguistic networks associated with lexical, semantic and syntactic predictability in reading: a fixation-related fMRI study](https://doi.org/10.1016/j.neuroimage.2019.01.018) and an associated Data in Brief currently under review.

## Contents
### Primary Analysis

Scripts found in the *predictability1* directory apply to the primary analysis.

Scripts were written for the SLURM environment. Scripts with the suffix `_batch.sh` reference scripts with the suffix `_job.sh`. Preprocessing (prefix: `preproc`) jobs were performed first, followed by deconvolution (prefix: `3dDeconv`). Individual statistical results were then warped into MNI space using `ANTifyFunctional` (via the `ants_` scripts). `ANTifyFunctional` is a script originally written by Craig Stark, with some modifications by Brock Kirwan. Group statistical maps were created (`3dttest`). These were then used to create conjunction maps (`make_conjunction_mask.sh`).

Ideal HRFs were constructed using scripts found in the *timing* directory. Here is a list of which hemodynamic profile each created.

| Script | Analysis | What was modeled |
|---|---|---|
| `event_LSA.r` | 1, 2, 4 | Semantic predictability with fixation duration |
| `event_pos.R` | 1, 2, 4 | Syntactic predictability with fixation duration |
| `event_orth.R`| 1, 2, 4 | Lexical predictability with fixation duration |
| `length.R` | 2 | Word length |
| `frequency.R` | 2 | Word frequency |
| `lsa_noDuration.R` | 3 | Semantic predictability without fixation duration |
| `pos_noDuration.R` | 3 | Syntactic predictability without fixation duration |
| `ortho_noDuration.R` | 3 | Lexical predictability without fixation duration |
| `orthoFunction.r` | 4 | Lexical predictability of function words |


### Data in Brief
Scripts in directories named *predictability2*, *predictability3* and *predictability4* apply to analyses found in the Data in Brief. `supplementaryConjunction.sh` was used to make conjunction maps comparing geography of the supplementary analyses to the primary analyses.

## How to use this dataset
