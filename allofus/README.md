### DESCRIPTION OF SCRIPTS
This R code is tailored for use in the All of Us Researcher **Workbench 2.0** provided by Verily. Scripts are described below in the order in which they should be run.

`01-importdata.R` imports the data from All of Us, merges different survey occurrences into one master file, and cleans the coding for all imported variables.

`02-cleandata.R` cleans and recodes imported variables, and derives additional variables required for analysis, producing an analysis-ready dataframe.

`03-demos.R` produces demographics tables with summary statistics for the participant sample stratified by ethnicity and immigration status.

`04-logreg-dep.R` runs logistic regression models to estimate the likelihood of self-reported lifetime depression diagnosis across ethnicity and immigration status subgroups.
