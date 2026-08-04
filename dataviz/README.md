### DESCRIPTION OF SCRIPTS
This R code produces visualisation of the outputs from logistic regression models for both the All of Us and Our Future Health datasets. Scripts are described below in the order in which they should be run.

`01-packages.R` imports relevant packages, and installs them if they are not available.

`02-loaddata.R` accepts the analytical outputs from All of Us and Our Future Health (produced through scripts in other folders) and cleans these dataframes for visualisation.

`03-logregplots.R` produces forest plots of odds ratios with confidence intervals across a range of models, all adjusted for age and sex.

`04-supp_plots.R` produces supplementary forest plots for models adjusted for age, sex, body mass index, household income, current alcohol use, smoking, social interaction, and parental history of depression.
