#####################################
## GOALS: ensure correct variable types, recode as necessary, and produce cleaned dataframe for analysis
#####################################
library(dplyr)
library(stringr)

# Load data
#alldata <- fread("01-cleandata/mergeddata.csv")
#alldata <- backupcopy

###########################################################
########### CLEAN, RECODE, AND/OR DERIVE OUTCOME VARIABLES: depression diagnosis and PHQ-9 score
###########################################################

## Does anyone in family have depression
alldata <- alldata %>% mutate(familydepression = case_when(
  is.na(diag_psych) ~ NA,
  diag_psych == "Dont Know" ~ NA,
  diag_psych == "Skip" ~ NA,
  diag_psych == "None" ~ FALSE,
  grepl("Depression", diag_psych, ignore.case = T) ~ TRUE,
  TRUE ~ FALSE # for people reporting other mental health conditions but not depression
))

## Does participant have depression
alldata <- alldata %>% mutate(depression = case_when(
  is.na(familydepression) ~ NA,
  familydepression == FALSE ~ FALSE,
  diag_dep == "Skip" ~ NA,
  grepl("Self", diag_dep, ignore.case = FALSE) ~ TRUE,
  TRUE ~ FALSE
))

## Does participant's father have depression
alldata <- alldata %>% mutate(fatherpsych = case_when(
  is.na(familydepression) ~ NA,
  familydepression == FALSE ~ FALSE,
  diag_dep == "Skip" ~ NA,
  grepl("Father", diag_dep, ignore.case = FALSE) ~ TRUE,
  TRUE ~ FALSE
))

## Does participant's mother have depression
alldata <- alldata %>% mutate(motherpsych = case_when(
  is.na(familydepression) ~ NA,
  familydepression == FALSE ~ FALSE,
  diag_dep == "Skip" ~ NA,
  grepl("Mother", diag_dep, ignore.case = FALSE) ~ TRUE,
  TRUE ~ FALSE
))

alldata <- alldata %>% relocate(depression, fatherpsych, motherpsych, .after = sex) %>%
  dplyr::select(-c(diag_psych, diag_dep, familydepression))



###########################################################
########### CLEAN, RECODE, AND/OR DERIVE PREDICTOR VARIABLES: immigration status and ethnicity
###########################################################

## Immigration status from birth country
alldata <- alldata %>% mutate(immigration = case_when(
  is.na(birthcountry) ~ NA,
  birthcountry == "Skip" ~ NA,
  birthcountry == "USA" ~ "Non-Immigrant",
  birthcountry == "Other" ~ "Immigrant"
)) %>% 
  relocate(immigration, .before = birthcountry) %>%
  dplyr::select(-birthcountry)
# relevel as factor
alldata$immigration <- factor(alldata$immigration, levels = c("Non-Immigrant", "Immigrant"))

summary(as.factor(alldata$ethnicity))
summary(as.factor(alldata$ethn_asian))
## Ethnicity (broad categories: White, Black, South Asian, Other Asian, MENA, Hispanic/Latinx, Mixed or Multiple Heritage)
alldata <- alldata %>% mutate(ethnicity = case_when(
  is.na(ethnicity) ~ NA,
  ethnicity == "Skip" ~ NA,
  ethnicity == "Race Ethnicity None Of These" ~ NA,
  ethnicity == "Prefer Not To Answer" ~ NA,
  grepl("\\|", ethnicity) ~ "Mixed or Multiple Heritage",
  ethnicity == "White" ~ "White",
  ethnicity == "Black" ~ "Black",
  ethnicity == "Asian" & (ethn_asian == "Asian Specific Indian" | ethn_asian == "Pakistani") ~ "South Asian",
  ethnicity == "Asian" & (ethn_asian != "Asian Specific Indian" & ethn_asian != "Pakistani" & ethn_asian != "Skip") ~ "Other Asian",
  ethnicity == "MENA" ~ "MENA",
  ethnicity == "Hispanic" ~ "Hispanic or Latinx",
  TRUE ~ NA
))
alldata <- alldata %>% dplyr::select(-c(ethn_asian, ethn_black, ethn_latino, ethn_mena, ethn_white))
# relevel as factor
alldata$ethnicity <- factor(alldata$ethnicity, levels = c(
  "White", "Black", "Hispanic or Latinx", "MENA", "Mixed or Multiple Heritage", "Other Asian", "South Asian"
))


###########################################################
########### CLEAN, RECODE, AND/OR DERIVE PREDICTOR VARIABLES: age, sex, BMI, income, alcohol, smoking, loneliness, fatherdep, motherdep
###########################################################

## Derive age at first survey instance
alldata <- alldata %>% mutate(age = date - birthdate) %>% 
  relocate(age, .after = person_id) %>% 
  dplyr::select(-c(date, birthdate)) %>%
  mutate(age = as.numeric(age))

## Recode sex
alldata <- alldata %>% mutate(sex = replace_values(sex,
                                                   "Intersex" ~ NA,
                                                   "Prefer Not To Answer" ~ NA,
                                                   "Sex At Birth None Of These" ~ NA,
                                                   "Skip" ~ NA,
                                                   "Male" ~ "Male",
                                                   "Female" ~ "Female"
))
# relevel as factor
alldata$sex <- factor(alldata$sex, levels = c("Male", "Female"))


## Derive BMI
# some people had height and weight measured in a separate "instance", so this needs to be cleaned up
alldata <- alldata %>% separate_wider_delim(c(height, weight), delim = "|", names_sep = "_T", too_few = "align_start")
# coerce to numeric
alldata <- alldata %>% mutate(across(.cols = c(height_T1, height_T2, weight_T1, weight_T2),
                                     .fns = ~as.numeric(.)))
# calculate mean height and weight in case two separate measurements were recorded
alldata <- alldata %>% mutate(height = rowMeans(across(c(height_T1, height_T2)), na.rm = TRUE)) %>% 
  mutate(height = height/100) %>% 
  mutate(height = ifelse(is.nan(height), NA, height))
alldata <- alldata %>% mutate(weight = rowMeans(across(c(weight_T1, weight_T2)), na.rm = TRUE)) %>% 
  mutate(weight = ifelse(is.nan(weight), NA, weight))
# now calculate BMI
alldata <- alldata %>% mutate(bmi = (weight / height^2))
alldata <- alldata %>% dplyr::select(-c(height_T1, height_T2, height, weight_T1, weight_T2, weight)) %>%
  relocate(bmi, .after = ethnicity)


## Recode income
alldata <- alldata %>% mutate(income = replace_values(income,
                                                      "less 10k" ~ "<10k",
                                                      "10k 25k" ~ "10-25k",
                                                      "25k 35k" ~ "25-35k",
                                                      "35k 50k" ~ "35-50k",
                                                      "50k 75k" ~ "50-75k",
                                                      "75k 100k" ~ "75-100k",
                                                      "100k 150k" ~ "100-150k",
                                                      "150k 200k" ~ "150-200k",
                                                      "more 200k" ~ ">200k",
                                                      "Prefer Not To Answer" ~ NA,
                                                      "Skip" ~ NA
))
# relevel as factor
alldata$income <- factor(alldata$income, levels = c(
  "<10k", "10-25k", "25-35k", "35-50k", "50-75k", "75-100k", "100-150k", "150-200k", ">200k"
))

## Recode current (i.e. past year) alcohol use
alldata <- alldata %>% mutate(alcohol = case_when(
  is.na(alcohol) ~ NA,
  alcohol == "Never" | alcohol == "Monthly Or Less" ~ "Rarely or Never",
  alcohol == "Prefer Not To Answer" ~ NA,
  alcohol == "Skip" ~ NA,
  TRUE ~ "Regularly"
))
# relevel as factor
alldata$alcohol <- factor(alldata$alcohol, levels = c("Rarely or Never", "Regularly"))

## Recode lifetime smoking (logical variable, TRUE if 100 smokes in lifetime)
alldata <- alldata %>% mutate(smoking = case_when(
  is.na(smoking) ~ NA,
  smoking == "Prefer Not To Answer" ~ NA,
  smoking == "Dont Know" ~ NA,
  smoking == "Skip" ~ NA,
  smoking == "Yes" ~ TRUE,
  smoking == "No" ~ FALSE
))

summary(as.factor(alldata$ucla1))
## Derive UCLA 8-item loneliness scale score
alldata <- alldata %>% mutate(across(.cols = c(ucla1, ucla2, ucla4, ucla5, ucla7, ucla8), 
                                     .fns = ~str_replace_all(.x, c(
                                       "Never" = "1",
                                       "Rarely" = "2",
                                       "Sometimes" = "3",
                                       "Often" = "4",
                                       "Skip" = NA
                                     ))))
alldata <- alldata %>% mutate(across(.cols = c(ucla3, ucla6), 
                                     .fns = ~str_replace_all(.x, c(
                                       "Never" = "4",
                                       "Rarely" = "3",
                                       "Sometimes" = "2",
                                       "Often" = "1",
                                       "Skip" = NA
                                     ))))
# convert all UCLA items to numeric
alldata <- alldata %>% mutate(across(.cols = starts_with("ucla"), .fns = ~as.numeric(.x)))
# calculate sum of UCLA loneliness scale items
alldata$loneliness <- rowSums(alldata[,c("ucla1", "ucla2", "ucla3", "ucla4",
                                         "ucla5", "ucla6", "ucla7", "ucla8")])
alldata <- alldata %>% dplyr::select(-starts_with("ucla"))

###########################################################
########### drop participants with missing data in core variables
###########################################################
alldata <- alldata %>% drop_na(c(depression, ethnicity, immigration, age, sex))

summary(alldata)

###########################################################
########### export cleaned dataset
###########################################################

fwrite(alldata, "02-cleandata/cleandata.csv", row.names = FALSE)
