This is the repository for the code for the paper entitled "Linguistic Networks and Predictions: A Fixation-Related fMRI Study."

Scripts were written for the SLURM environment, with <prefix>_batch.sh scripts referencing <prefix>_job.sh scripts. Preprocessing (prefix: preproc) jobs were performed first, followed by deconvolution (prefix: 3dDeconv). Then group statistical maps were created (3dttest). These were then used to create conjunction maps (make_conjunction_mask.sh). ANTifyFunctional is a script originally written by Craig Stark, with some modifications by Brock Kirwan.

Ideal HRFs were constructed using scripts found in the timing directory.
