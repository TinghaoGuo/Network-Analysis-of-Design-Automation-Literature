library(igraph)
library(corrplot)
library(reshape2)
setwd("...")
rm(list=ls())

# load the data
df = read.csv("allTopic_df.csv", header = TRUE)
names = colnames(df)
# replace "." with space
names = gsub("[.]"," " ,names)
bigTopics = names[51:60]
smallTopics = names[1:50]
cutoff = 0.25
# change column names (without period) of correlation matrix
colnames(df) = names

allCorr <- cor(df)
write.csv(allCorr, "allCorr.csv")