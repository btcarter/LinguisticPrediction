This is the repository for the code for the paper entitled [Linguistic networks associated with lexical, semantic and syntactic predictability in reading: a fixation-related fMRI study](https://doi.org/10.1016/j.neuroimage.2019.01.018) and an associated Data in Brief currently under review.

## Contents
### Primary Analysis

Scripts found in the *predictability1* directory apply to the primary analysis.

Scripts were written for the SLURM environment. Scripts with the suffix `_batch.sh` reference scripts with the suffix `_job.sh`. Preprocessing (prefix: `preproc`) jobs were performed first, followed by deconvolution (prefix: `3dDeconv`). Individual statistical results were then warped into MNI space using `ANTifyFunctional` (via the `ants_` scripts). `ANTifyFunctional` is a script originally written by Craig Stark, with some modifications by Brock Kirwan. Group statistical maps were created (`3dttest`). These were then used to create conjunction maps (`make_conjunction_mask.sh`).

Ideal HRFs were constructed using scripts found in the *timing* directory.

### Data in Brief
Scripts in directories named *predictability2*, *predictability3* and *predictability4* apply to analyses found in the Data in Brief. `supplementaryConjunction.sh` was used to make conjunction maps comparing geography of the supplementary analyses to the primary analyses.
