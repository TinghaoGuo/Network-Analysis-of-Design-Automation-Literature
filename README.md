# Network-Analysis-of-Design-Automation-Literature

-------------------------------------------------------------------------------
Version 1.0
Release date: 3/5/2017

--------------------------------------------------------------------------------
Authors: 
- Tinghao Guo (guo32@illinois.edu)
- Jiarui Xu (jiaruix@andrew.cmu.edu)
- Yue Sun (yuesun3@illinois.edu)
- Yilin Dong (ydong24@illinois.edu)
- Neal Davis (davis68@illinois.edu)
- James T. Allison (jtalliso@illinois.edu)

-------------------------------------------------------------------------------
Description:

This toolbox consists of python and R code for performing network analysis of
Design Automation Conference literature. The research work include:
- Co-authorship analysis: https://github.com/LargePanda/dac_network_analysis
  - most collaborate authors
  - clustering coefficients and average shortest path length (small world property)
- Topic modeling: 
  - Topic assignment for each paper
  - Topic frequencies and evolution
  - Topic relation exploration using correlation matrix and association rule learning
  - Citation analysis
  - Clustering analysis: Propagation mergence
    - https://github.com/sudongqi/Propagation_Mergence
    - https://www.ideals.illinois.edu/handle/2142/96023
 
-------------------------------------------------------------------------------
Requirements:

- Python libraries: Beautiful Soup, NetworkX, csv, pandas, nltk, enchant, json

- R packages: igraph, ggplot2, xlsx, gdata, plyr, corrplot, reshape2, arules, arulesViz
