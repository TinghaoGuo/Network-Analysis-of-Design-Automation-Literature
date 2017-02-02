# citation analysis
library(plyr)
library(xlsx)

setwd("...")
rm(list=ls())

# read the mapping file
df <-  read.csv("2002_with_id_map.csv", header = TRUE, sep = ',')
for (year in 2003:2014){
  # print (year)
  in_file <- paste(year,'_with_id_map.csv', sep = "")
  # cur_df <- read.xls(in_file, header = TRUE)
  cur_df <- read.csv(in_file, header = TRUE, sep = ',')
  df <- rbind(df, cur_df)
}

df2 <- read.xlsx("2002_bTopic_Freq.xlsx", sheetName =1, header = TRUE)
for (year in 2003:2014){
  in_file <- paste(year,'_bTopic_Freq.xlsx', sep = "")
  cur_df <- read.xlsx(in_file, sheetName = 1, header = TRUE)
  df2 <- rbind(df2, cur_df)
}
df2$NA. <- NULL
#turn to zero_one format
df2[df2 > 0] <- 1
df2$PaperID  <-  df$PaperID

# read the citation links
df3 <- read.csv("citations_links.csv", header = TRUE, sep = ',')
source <- df3
colnames(source) <- c("PaperID","targetId")
target <- df3
colnames(target) <- c("sourceId", "PaperID")

################
# broad topics
b_node <-  NULL
b_edge <- NULL
b_avg_deg <- NULL
b_density <- NULL
b_node_total <- NULL

# load broad topic names
b_names <- read.csv("bTopic_names.csv", header = TRUE, sep = ",")

for (i in 1:10){
  col <- paste0("X",i)
  b_node_total[i] <- sum(df2[col])
  df_tmp <- df2[df2[col]>0,]
  df_tmp <- as.data.frame(df_tmp$PaperID)
  colnames(df_tmp) <- c("PaperID")
  
  # filter citaion network twice
  filtered_links_1 <- merge(x = df_tmp, y = source, by = "PaperID")
  colnames(filtered_links_1) = c("sourceId","PaperID")
  filtered_links_2 <- merge(x = df_tmp, y = filtered_links_1, by = "PaperID")
  
  # save df_tmp
  write.csv(df_tmp, file = paste0("papers_","bTopic",i,".csv"), row.names = FALSE)
  
  # save filtered_links_2
  colnames(filtered_links_2) = c("targetId","sourceId")
  write.csv(filtered_links_2, 
            file = paste0("citation_links_","bTopic",i,".csv"), 
            row.names = FALSE)
  
  if (nrow(filtered_links_2) > 0){
    # identify number of nodes and edges
    V <- length(unique(unlist(filtered_links_2))) # number of nodes
    E <- nrow(filtered_links_2) # number of edges
    
    # average degree (directed graph)
    avg_deg <- E/b_node_total[i]

  }
  else{
    V <- 0
    E <- 0
    avg_deg <- NA
  }
  
  b_node[i] = V
  b_edge[i] = E
  b_avg_deg[i] = avg_deg
}

b_metrics = data.frame(bTopic = b_names,
                       node_total = b_node_total,
                       node = b_node, 
                       edge = b_edge, 
                       avg_deg = b_avg_deg)
b_metrics['node_ratio'] = b_metrics$node/b_metrics$node_total
write.csv(b_metrics, file = 'bTopic_metrics.csv', row.names = FALSE)

##############
# narrow topics
df4 <- read.xlsx("2002_nTopic_Freq.xlsx", sheetName =1, header = TRUE)
for (year in 2003:2014){
  in_file <- paste(year,'_nTopic_Freq.xlsx', sep = "")
  # cur_df <- read.xls(in_file, header = TRUE)
  cur_df <- read.xlsx(in_file, sheetName = 1, header = TRUE)
  df4 <- rbind(df4, cur_df)
}
df4$NA. <-  NULL
#turn to zero_one format
df4[df4 > 0] <- 1
df4$PaperID  <-  df$PaperID

n_node <-  NULL
n_edge <- NULL
n_avg_deg <- NULL
n_density <- NULL
n_node_total <- NULL

# load broad topic names
n_names <- read.csv("nTopic_names.csv", header = TRUE, sep = ",")

for (i in 1:50){
  col <- paste0("X",i)
  n_node_total[i] <- sum(df4[col])
  df_tmp <- df4[df4[col]>0,]
  df_tmp <- as.data.frame(df_tmp$PaperID)
  colnames(df_tmp) <- c("PaperID")
  
  # filter citaion network twice
  filtered_links_1 <- merge(x = df_tmp, y = source, by = "PaperID")
  colnames(filtered_links_1) = c("sourceId","PaperID")
  filtered_links_2 <- merge(x = df_tmp, y = filtered_links_1, by = "PaperID")
  
  # save df_tmp
  write.csv(df_tmp, file = paste0("papers_","nTopic",i,".csv"), row.names = FALSE)
  
  # save filtered_links_2
  colnames(filtered_links_2) = c("targetId","sourceId")
  write.csv(filtered_links_2, 
            file = paste0("citation_links_","nTopic",i,".csv"), 
            row.names = FALSE)
  
  if (nrow(filtered_links_2) > 0){
    # identify number of nodes and edges
    V <- length(unique(unlist(filtered_links_2))) # number of nodes
    E <- nrow(filtered_links_2) # number of edges
    
    # average degree (directed graph)
    avg_deg <- E/n_node_total[i]

  }
  else{
    V <- 0
    E <- 0
    avg_deg <- NA
  }
  
  n_node[i] = V
  n_edge[i] = E
  n_avg_deg[i] = avg_deg
}

n_metrics = data.frame(nTopic = n_names,
                       node_total = n_node_total,
                       node = n_node, 
                       edge = n_edge, 
                       avg_deg = n_avg_deg)
n_metrics['node_ratio'] = n_metrics$node/n_metrics$node_total
write.csv(n_metrics, file = 'nTopic_metrics.csv',row.names = FALSE)

