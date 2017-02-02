setwd("...")
# library(gdata)
library(plyr)
library(xlsx)
rm(list=ls())

nTopics <- readLines('50_nTopics.txt')
nTopic_list <- vector('list', length = length(nTopics))
for (i in 1:length(nTopics)){
  ind_nTopic <- strsplit(nTopics[i], "'")
  nTopic <- ldply(ind_nTopic)[2]
  nTopic_list[i] <- nTopic
}

# save nTopic_list to a dataframe
nTopic_df = data.frame(nTopic = unlist(nTopic_list))
write.csv(nTopic_df, "nTopic_names.csv", row.names = FALSE)

df1 <- read.xlsx("2002_nTopic_Freq.xlsx", sheetName =1, header = TRUE)
for (year in 2003:2015){
  in_file <- paste(year,'_nTopic_Freq.xlsx', sep = "")
  # cur_df <- read.xls(in_file, header = TRUE)
  cur_df <- read.xlsx(in_file, sheetName = 1, header = TRUE)
  df1 <- rbind(df1, cur_df)
}
df1$NA. <- NULL

bTopics <- readLines('10_bTopics.txt')
bTopic_list <- vector('list', length = length(bTopics))
for (i in 1:length(bTopics)){
  ind_bTopic <- strsplit(bTopics[i], "'")
  bTopic <- ldply(ind_bTopic)[2]
  bTopic_list[i] <- bTopic
}

# save bTopic_list to a dataframe
bTopic_df = data.frame(bTopic = unlist(bTopic_list))
write.csv(bTopic_df, "bTopic_names.csv", row.names = FALSE)

df2 <- read.xlsx("2002_bTopic_Freq.xlsx", sheetName =1, header = TRUE)
for (year in 2003:2015){
  in_file <- paste(year,'_bTopic_Freq.xlsx', sep = "")
  cur_df <- read.xlsx(in_file, sheetName = 1, header = TRUE)
  df2 <- rbind(df2, cur_df)
}
df2$NA. <- NULL

df <- merge(df1, df2, by = 'X0')
df$X0 <- NULL

write.csv(df1, file = "nTopic_df.csv" )
write.csv(df2, file = "bTopic_df.csv")

n_b_topics <- c(nTopic_list, bTopic_list)
colnames(df) <- n_b_topics
write.csv(df, file = "allTopic_df.csv")

#frequency as entries
freq_df <- df

#turn to zero_one format
df[df > 0] <- 1

# write.csv(df, file = "allTopic_df.csv")

#preprocess the df for later use
df <- sapply(data.frame(df), as.numeric)
write.csv(df, file = "allTopic_df.csv",row.names = FALSE)




