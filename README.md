This is the repository for the code for the paper entitled "Linguistic Networks and Predictions: A Fixation-Related fMRI Study."

Scripts were written for the SLURM environment, with _batch.sh scripts referencing _job.sh scripts. Preprocessing (prefix: preproc) jobs were performed first, followed by deconvolution (prefix: 3dDeconv). Individual statistical results were then warped into MNI space using ANTifyFunctional (via the ants_ scripts). ANTifyFunctional is a script originally written by Craig Stark, with some modifications by Brock Kirwan. Group statistical maps were created (3dttest). These were then used to create conjunction maps (make_conjunction_mask.sh).

Ideal HRFs were constructed using scripts found in the timing directory.
