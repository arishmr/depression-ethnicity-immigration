### DESCRIPTION OF SCRIPTS
This R and bash code is tailored for use in the Our Future Health **DNAnexus TRE**. Scripts are described below in the order in which they should be run.

`00-1-cleanstart.sh` is the bash code used to import data from Our Future Health into the JupyterLab environment. It also includes the bash code for uploading cleaned data back into Our Future Health's persistent storage.

`00-2-cleandata.R` cleans the raw data imported from Our Future Health into a format that is usable for the intended analyses (in brief, this involves merging variables from relevant dataframes, renaming columns, recoding variables to appropriate categories, assigning variables to be factors or numeric, and deriving new variables such as age or specific diagnoses from available data).

`01-analysis-start.sh` is the bash code used to create relevant directories within the JupyterLab environment for analysis of this data. It also includes the bash code for uploading outputs from analyses back into Our Future Health's persistent storage.

`02-loaddata.R` imports the cleaned dataset and classifies variables to appropriate categories.

`03-demos.R` calculates summary statistics for all relevant variables stratified by ethnicity and immigration status.

`04-logreg-dep.R` runs logistic regression models to estimate the likelihood of self-reported lifetime depression diagnosis or possible undiagnosed depression across ethnicity and immigration status subgroups.

`04-logreg-dep.R` runs these regression models with life stage at immigration and time since immigration as predictors.
