library(plyr)
library(corrplot)
library(arules)
library(arulesViz)
library(ggplot2)

rm(list=ls())
currentWD = "..."
setwd(currentWD)

df = read.csv("allTopic_df.csv", header = TRUE)
names = colnames(df)
# replace "." with space
names = gsub("[.]"," " ,names)
colnames(df) = names
bigTopics = names[51:60] # need to change
smallTopics = names[1:50]

df1 = df[,1:50] #narrow topics
df2 = df[,51:60] #broad topics

################################## iterm frequency plot
# broad topics
df2_sum = colSums(df2) # name is excluced
df2_freq = data.frame(bTopic = bigTopics, freq=df2_sum)

#######
# narrow topics
df1_sum = colSums(df1) # name is excluced
df1_freq = data.frame(nTopic = smallTopics, freq=df1_sum)

#################################apriori models
df1 <- sapply(data.frame(df1), as.numeric)
df2 <- sapply(data.frame(df2), as.numeric)
df <- sapply(data.frame(df), as.numeric)

df1 <- as(df1, "transactions")
df2 <- as(df2, "transactions") 
df <- as(df, "transactions") 

####################################
# narrow topics
n_model <- apriori(df1, parameter = list(support = 0.004, confidence = 0.5,
                                          minlen = 3, maxlen=4))
n_Allrules = as(n_model , "data.frame");
write.csv(n_Allrules, file = "n_Allrules.csv", row.names = FALSE)

############plot
pdf("nScatter.pdf", width = 8, height=8)
plot(n_model, measure = c("support","confidence"), shading = "lift",
     control = list(main=NULL))
dev.off()

pdf("nGrouped.pdf", width = 20, height=20)
p = plot(n_model,method = "grouped", measure = "confidence", shading = "lift",
     control = list(main = NULL, k= 50))
dev.off()

# save matrices in grouped plot
n_lift = p$sAggr
write.csv(n_lift, file = "n_lift.csv")

n_conf = p$mAggr
write.csv(n_conf, file = "n_conf.csv")

## filter rules
n_rules_sorted <- sort(n_model, by = "confidence")
quality(n_rules_sorted)$improvement <- interestMeasure(n_rules_sorted, measure = "improvement")
n_redundant = n_rules_sorted[is.redundant(n_rules_sorted)]
n_redundant_rules = as(n_redundant , "data.frame");
write.csv(n_redundant_rules, file = "n_redundant_rules.csv", row.names = FALSE)

n_nonredundant = n_rules_sorted[!is.redundant(n_rules_sorted)]
n_nonredundant_rules = as(n_nonredundant , "data.frame");
n_nonredundant_rules$improvement = NULL
write.csv(n_nonredundant_rules, file = "n_nonredundant_rules.csv", row.names = FALSE)

significant_idx = is.significant(n_nonredundant, df2, alpha=0.05,adjust='bonferroni')
n_significant = n_nonredundant[significant_idx]
n_significant_rules = as(n_significant, "data.frame")
n_significant_rules$improvement = NULL
write.csv(n_significant_rules, file = "n_significant_rules.csv", row.names = FALSE)

n_nonsignificant = n_nonredundant[!significant_idx]
n_nonsignificant_rules = as(n_nonsignificant, "data.frame")
n_nonsignificant_rules$improvement = NULL
write.csv(n_nonsignificant_rules, file = "b_nonsignificant_rules.csv", row.names = FALSE)

########### filter the rules for each topic
dir.create("n_topic_rules")
n_saved_path = paste0(currentWD,"/n_topic_rules/")
for (i in 1:50){
  n_name = gsub(" ","." ,smallTopics[i])
  n_name2 = gsub(" ","_" ,smallTopics[i])
  subset_df <- subset(n_significant, subset = ((lhs %in% n_name) | (rhs %in% n_name)) & 
                        lift > 2 & confidence > 0.8)
  subset_rules <- as(subset_df , "data.frame") 
  subset_rules$improvement = NULL
  write.csv(subset_rules, file = paste0(n_saved_path,"n_filtered_rules_",n_name2,".csv"), row.names = FALSE)
}

##################################
# broad topics 
b_model <- apriori(df2, parameter = list(support = 0.004, confidence = 0.5,
                                          minlen = 3, maxlen=4))

b_Allrules = as(b_model , "data.frame");
write.csv(b_Allrules, file = "b_Allrules.csv", row.names = FALSE)

############plot
pdf("bScatter.pdf", width = 8, height=8)
plot(b_model , measure = c("support","confidence"), shading = "lift",
     control = list(main=NULL))
dev.off()

pdf("bGrouped.pdf", width = 16, height=12)
p = plot(b_model,method = "grouped", measure = "confidence", shading = "lift",
         control = list(main = NULL, k = 20))
dev.off()

# save matrices in grouped plot
b_lift = p$sAggr
write.csv(b_lift, file = "b_lift.csv")

b_conf = p$mAggr
write.csv(b_conf, file = "b_conf.csv")

## filter rules
b_rules_sorted <- sort(b_model, by = "confidence")
quality(b_rules_sorted)$improvement <- interestMeasure(b_rules_sorted, measure = "improvement")
b_redundant = b_rules_sorted[is.redundant(b_rules_sorted)]
b_redundant_rules = as(b_redundant , "data.frame");
write.csv(b_redundant_rules, file = "b_redundant_rules.csv", row.names = FALSE)

## non-redundant rules
b_nonredundant = b_rules_sorted[!is.redundant(b_rules_sorted)]
b_nonredundant_rules = as(b_nonredundant , "data.frame");
b_nonredundant_rules$improvement = NULL
write.csv(b_nonredundant_rules, file = "b_nonredundant_rules.csv", row.names = FALSE)

# significance on the non-redundant rules
significant_idx = is.significant(b_nonredundant, df2, alpha=0.05,adjust='bonferroni')
b_significant = b_nonredundant[significant_idx]
b_significant_rules = as(b_significant, "data.frame")
b_significant_rules$improvement = NULL
write.csv(b_significant_rules, file = "b_significant_rules.csv", row.names = FALSE)

b_nonsignificant = b_nonredundant[!significant_idx]
b_nonsignificant_rules = as(b_nonsignificant, "data.frame")
b_nonsignificant_rules$improvement = NULL
write.csv(b_nonsignificant_rules, file = "b_nonsignificant_rules.csv", row.names = FALSE)

########### filter the rules for each topic
dir.create("b_topic_rules")
b_saved_path = paste0(currentWD,"/b_topic_rules/")
for (i in 1:10){
  b_name = gsub(" ","." ,bigTopics[i])
  b_name2 = gsub(" ","_" ,bigTopics[i])
  subset_df <- subset(b_significant, subset = ((lhs %in% b_name) |
                      (rhs %in% b_name)) & lift > 2 & confidence > 0.8)
  subset_rules <- as(subset_df , "data.frame") 
  subset_rules$improvement = NULL
  write.csv(subset_rules, file = paste0(b_saved_path,"b_filtered_rules_",b_name2,".csv"), row.names = FALSE)
}


