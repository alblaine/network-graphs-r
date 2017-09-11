#install packages
install.packages("tidyr")
install.packages("dplyr")
install.packages("geomnet")
install.packages("readxl")
install.packages("magrittr")

#load libraries into current session
library(tidyr) #to manipulate data
library(dplyr) #to manipulate data
library(geomnet) #to draw network graph
library(readxl) #to read in excel spreadsheet
library(magrittr) #to use the %>% for easier data modification

##### Step 1: Create a Nodes Dataset - if you don't already have one ####################

# read in the data from Fake1.xlsx edges file
fake1 <- read_xlsx("Fake1.xlsx")

# collapse From/To columns
collapsed_list <- gather(fake1, "node", 1:2)   %>%
  filter(node != "Value")

# rename 2nd column to 'nodes'
colnames(collapsed_list)[2] <- "nodes" 

# create data frame of unique node values only - no duplicates 
nodes_list <- data.frame(unique(collapsed_list$nodes), stringsAsFactors = FALSE)

# rename the column of this data frame to nodes
colnames(nodes_list) <- "nodes"

##### Step 2: Create network graph ########################################################

# turn fake1 into a data.frame object (it's currently a 'tibble')
edges_list <- data.frame(fake1)

# merge edges_list and nodes_list into one network - this uses 2 functions from geomnet package
net <- fortify(as.edgedf(edges_list), nodes_list)

# draw your network graph
ggplot(data = net,
       aes(from_id = from_id, to_id = to_id)) +  
       geom_net(color='darkred', labelon = TRUE, directed=TRUE, fontsize = 4, arrowsize = 1.2, vjust=-0.6, linewidth = 0.3, ecolour = "grey70") + 
       labs(title="Network Diagram for Fake1") +
       theme_net()
