
#load libraries into current session
library(tidyr) #to manipulate data
library(dplyr) #to manipulate data
library(geomnet) #to draw network graph
library(readxl) #to read in excel spreadsheet
library(magrittr) #to use the %>% for easier data modification

##### Step 1: Create a Nodes Dataset - if you don't already have one ####################

# read in the data from Fake1.xlsx edges file
fake2 <- read_xlsx("Fake2.xlsx")

# collapse From/To columns
collapsed_list2 <- 
  gather(fake2, "node", 1:2) %>%
  filter(node != "Value")

# rename 2nd column to 'nodes'
colnames(collapsed_list2)[2] <- "nodes" 

# create data frame of unique node values only - no duplicates 
nodes_list2 <- data.frame(unique(collapsed_list2$nodes), stringsAsFactors = FALSE)

# rename the column of this data frame to nodes
colnames(nodes_list2) <- "nodes"

# remove the 'NA' value from the dataset
nodes_list2 <- nodes_list2 %>% 
  filter(nodes != "NA")

##### Step 2: Create network graph ########################################################

# turn fake1 into a data.frame object (it's currently a 'tibble')
edges_list2 <- data.frame(fake2)

# merge edges_list and nodes_list into one network - this uses 2 functions from geomnet package
net2 <- fortify(as.edgedf(edges_list2), nodes_list2)

# draw your network graph
ggplot(data = net2,
       aes(from_id = from_id, to_id = to_id)) +  
  geom_net(color='darkred', labelon = TRUE, directed=TRUE,fontsize = 4, arrowsize = 1.2, vjust=-0.6, linewidth = 0.3, ecolour = "grey70") + 
  labs(title="Network Diagram for Fake2") +
  theme_net()
