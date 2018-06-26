This is the repository for the code for the paper entitled *Linguistic Networks associated with Lexical, Semantic and Syntactic Predictability in Reading: A Fixation-Related fMRI Study*.

Scripts found in the *predictability1* directory apply to the original analysis. Scripts in directories named *predictability2*, *predictability3* and *predictability4* apply to analyses found in the Data in Brief.

Scripts were written for the SLURM environment. Scripts with the suffix `_batch.sh` reference scripts with the suffix `_job.sh`. Preprocessing (prefix: `preproc`) jobs were performed first, followed by deconvolution (prefix: `3dDeconv`). Individual statistical results were then warped into MNI space using `ANTifyFunctional` (via the `ants_` scripts). `ANTifyFunctional` is a script originally written by Craig Stark, with some modifications by Brock Kirwan. Group statistical maps were created (`3dttest`). These were then used to create conjunction maps (`make_conjunction_mask.sh`).

Ideal HRFs were constructed using scripts found in the *timing* directory.
