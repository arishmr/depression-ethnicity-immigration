## Only keep data on self-reported lifetime depression
dep_ethnicity <- dep_ethnicity %>% filter(outcome == "Lifetime Depression")
dep_immigration <- dep_immigration %>% filter(outcome == "Lifetime Depression")

## Remove data where models did not converge
dep_ethnicity <- dep_ethnicity %>% filter_out(ci.max == Inf)
dep_immigration <- dep_immigration %>% filter_out(n < 50)



###########################################
## PLOTS OF ODDS RATIOS - DEPRESSION across ETHNICITIES
###########################################

plotdata <- dep_ethnicity
plotdata <- plotdata %>%
  filter_out(ethnicity == "Overall") %>%
  filter(immigration == "Overall") %>%
  filter(model == "Minimally Adjusted")
plotdata <- plotdata %>% mutate(sig = as.factor(ifelse(p.fdr < 0.05, "Significant", "Non-Significant")))
#plotdata$sig <- relevel(plotdata$sig, ref = "Non-Significant")
plotdata$ethnicity <- factor(plotdata$ethnicity, levels = c("Arab, Middle Eastern, or North African", "Black", "Hispanic or Latinx", "Mixed or Multiple Heritage", "Other Asian", "South Asian", "White"))


depethn <- ggplot(plotdata,
       aes(x = ethnicity, y = OR, group = cohort, color = cohort)) +
  geom_point(size = 2, position=position_dodge(width = 0.5)) +  
  geom_errorbar(aes(ymin = ci.min, ymax = ci.max), width = 0.1, size = 0.5, position=position_dodge(width = 0.5)) +
  #geom_text(aes(y = ci.max, color = sig, label = scales::comma(n)), vjust = -0.5, position = position_dodge(width = 0.8), size = 2) +
  facet_grid( ~ outcome, scale="free_y") +
  geom_hline(aes(yintercept = 1), color = "darkgray", linetype = "dashed", cex = 0.5) +
  labs(y = "Odds Ratio (95% CI)", x = "", color = "", subtitle = "Compared to White Participants") +
  theme_bw() +
  theme(legend.position = "bottom") +
  guides(group = "none") +
  scale_y_continuous(limits = c(0.2, 1.2)) +
  scale_color_brewer(palette = "Dark2") +
  theme(panel.spacing.x = unit(1, "lines")) +
  theme(panel.spacing.y = unit(1.5, "lines")) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
  #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  theme(axis.title = element_text(face="bold"))
depethn

ggsave("04-figures/Depression_Ethnicity.png", width = 5, height = 5, dpi = 300)

rm(plotdata)



###########################################
## PLOTS OF ODDS RATIOS - DEPRESSION across IMMIGRATION STATUS
###########################################

plotdata <- dep_immigration
plotdata <- plotdata %>%
  filter(model == "Minimally Adjusted")
plotdata <- plotdata %>% mutate(sig = as.factor(ifelse(p.fdr < 0.05, "Significant", "Non-Significant")))
plotdata$sig <- relevel(plotdata$sig, ref = "Non-Significant")
plotdata$ethnicity <- factor(plotdata$ethnicity, levels = c("Overall", "Arab, Middle Eastern, or North African", "Black", "Hispanic or Latinx", "Mixed or Multiple Heritage", "Other Asian", "South Asian", "White"))


depimm <- ggplot(plotdata,
       aes(x = ethnicity, y = OR, group = cohort, color = cohort, alpha = sig)) +
  geom_point(size = 2, position=position_dodge(width = 0.5)) +  
  geom_errorbar(aes(ymin = ci.min, ymax = ci.max), width = 0.1, size = 0.5, position=position_dodge(width = 0.5)) +
  #geom_text(aes(y = ci.max, color = sig, label = scales::comma(n)), vjust = -0.5, position = position_dodge(width = 0.8), size = 2) +
  facet_grid( ~ outcome, scale="free_y") +
  geom_hline(aes(yintercept = 1), color = "darkgray", linetype = "dashed", cex = 0.5) +
  labs(y = "Odds Ratio (95% CI)", x = "", color = "", subtitle = "Compared to Non-Immigrant Participants") +
  theme_bw() +
  theme(legend.position = "bottom") +
  guides(group = "none", alpha = "none") +
  scale_alpha_discrete(range = c(0.3, 1)) +
  scale_y_continuous(limits = c(0.2,1.2)) +
  scale_color_brewer(palette = "Dark2") +
  theme(panel.spacing.x = unit(1, "lines")) +
  theme(panel.spacing.y = unit(1.5, "lines")) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
  #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  theme(axis.title = element_text(face="bold"))
depimm

ggsave("04-figures/Depression_Immigration.png", width = 6, height = 5, dpi = 300)

rm(plotdata)


## Export patched figures for publication
{depethn + depimm} +
  plot_layout(guides = 'collect', axis_titles = 'collect') & theme(legend.position = 'bottom') +
  theme(plot.subtitle = element_text(size = 10, face = "plain"))
ggsave("04-figures/Fig1_CrossCohort_Depression.png", width = 10, height = 5, dpi = 300)

rm(depethn, depimm)
