
library(plyr)
library(corrplot)
library(xlsx)
library(reshape2)
library(ggplot2)
rm(list=ls())

setwd("...")

################## narrow topics
# extract topic names
nTopics <- readLines('50_nTopics.txt')
nTopic_list <- vector('list', length = length(nTopics))
for (i in 1:length(nTopics)){
  ind_nTopic <- strsplit(nTopics[i], "'")
  nTopic <- ldply(ind_nTopic)[2]
  nTopic_list[i] <- nTopic
}

n_colSums <- NULL
for (year in 2002:2015){
  in_file <- paste(year,'_nTopic_Freq.xlsx', sep = "")
  cur_df <- read.xlsx(in_file, sheetName = 1, header = TRUE)
  cur_df$NA. <- NULL
  cur_df$X0 <-  NULL
  cur_df[cur_df > 0] <- 1
  n_colSums[[year-2001]] <- list(colSums(cur_df))
}

n_freq <- as.data.frame(n_colSums)
n_freq_scaled = t(apply(n_freq, 1, function(x) x/sum(x)))
colnames(n_freq_scaled) <- c(2002:2015)
rownames(n_freq_scaled) <- nTopic_list
n_freq_scaled_mat <-  as.matrix(n_freq_scaled)
n_freq_scaled_df <-  melt(n_freq_scaled_mat)
names(n_freq_scaled_df) <-  c('narrow_topic', 'year', 'scaled_frequencies')

# save it as csv
write.csv(n_freq_scaled, "n_freq_scaled.csv",row.names = FALSE)

################## broad topics
# extract topic names
bTopics <- readLines('10_bTopics.txt')
bTopic_list <- vector('list', length = length(bTopics))
for (i in 1:length(bTopics)){
  ind_bTopic <- strsplit(bTopics[i], "'")
  bTopic <- ldply(ind_bTopic)[2]
  bTopic_list[i] <- bTopic
}

b_colSums <- NULL
for (year in 2002:2015){
  in_file <- paste(year,'_bTopic_Freq.xlsx', sep = "")
  cur_df <- read.xlsx(in_file, sheetName = 1, header = TRUE)
  cur_df$NA. <- NULL
  cur_df$X0 <-  NULL
  cur_df[cur_df > 0] <- 1
  b_colSums[[year-2001]] <- list(colSums(cur_df))
}

b_freq <- as.data.frame(b_colSums)
b_freq_scaled = t(apply(b_freq, 1, function(x) x/sum(x)))
colnames(b_freq_scaled) <- c(2002:2015)
rownames(b_freq_scaled) <- bTopic_list
b_freq_scaled_mat <-  as.matrix(b_freq_scaled)
b_freq_scaled_df <-  melt(b_freq_scaled_mat)
names(b_freq_scaled_df) <-  c('broad_topic', 'year', 'scaled_frequencies')

# save it as csv
write.csv(b_freq_scaled, "b_freq_scaled.csv",row.names = FALSE)



