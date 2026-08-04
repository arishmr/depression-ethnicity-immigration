# Depression in minority ethnicities and immigrants: Cross-cohort analysis in Our Future Health (UK) and All Of Us (USA)
Analysis code for a cross-cohort study exploring the rates of depression diagnosis and undiagnosed depression in ethnic minorities and immigrants.

### PROJECT SUMMARY
The goal of this study was to determine whether rates of self-reported depression diagnosis and possible undiagnosed depression differed by ethnicity or immigration status. To achieve this, we analysed cross-sectional data from 1,915,159 participants in UK’s Our Future Health (OFH) and 210,949 participants in USA’s All Of Us (AoU). 

### CONTACT
For any questions about the code, please contact the lead investigator: Dr Arish Mudra Rakshasa-Loots ([arish.mrl@ed.ac.uk](mailto:arish.mrl@ed.ac.uk)).

### DATA DICTIONARY
A full description of variables used in the analysis can be found in:
- the Our Future Health data dictionary, at this link: https://research.ourfuturehealth.org.uk/data-and-cohort/
- the All of Us codebook, at this link: https://support.researchallofus.org/hc/en-us/articles/360051991531--All-of-Us-Survey-Codebooks

### GENERAL APPROACH
Exposures of interest were ethnicity and immigration status. Outcomes of interest were self-reported lifetime depression diagnosis in both cohorts, and ‘possible undiagnosed depression’ (no self-reported depression diagnosis but Patient Health Questionnaire [PHQ-9] score ≥10 at baseline assessment) in OFH. Logistic regression adjusted for sociodemographic and lifestyle variables was used to estimate Odds Ratios (OR) for these outcomes.

### DESCRIPTION OF CODE
Analysis code for Our Future Health is available in the `ourfuturehealth` folder.
Analysis code for All of Us is available in the `allofus` folder.
Analysis code for visualisation of results from both cohorts is available in the `dataviz` folder.
Specific README files describing the scripts relevant to each set of analyses are available in the respective folders.
