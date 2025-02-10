#difference_in_differences

panel_data_did <- read.csv("~/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache/panel_data_2_9.csv")

colnames(panel_data_did)

panel_data_did <- panel_data_did %>%
  select(-c(X.1, X, X.y))


colnames(panel_data_did)


#####
#####
##### Define pre and post based on EV adoption relative to all vehicles #####
#####
#####

