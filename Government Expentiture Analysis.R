# This is an analysis of Data from the UNCTAD and Our World in data for Depression Rates and Government Expenditures in multiple different sectors.
# This data was wrangled in SQL. Code for wrangling is available in GitHub labeled "Mental_Health_Government_Spending_Wrangling.sql"

# Data available to download on Kaggle
# UNCTAD: https://www.kaggle.com/datasets/adamgrey88/world-governments-expenditure-dataset-2000-2021
# Our World in Data: https://www.kaggle.com/datasets/thedevastator/uncover-global-trends-in-mental-health-disorder/data

#==============================================================================
#   1. Settings, packages, and options
#==============================================================================
library(tidyverse)

# Set working directory 
setwd("C:/Users/Nicho/OneDrive/Desktop")
wel_data <- read.csv("Clean_MH.csv")

options(scipen = 9)

#==============================================================================
#   2. Analysis section
#==============================================================================

# Regression and Variable Selection
lm1 <- lm(Depression_Per ~ .- Anxiety_Per - Country  , data = wel_data)
lm2 <- update(lm1,~.-Fuel_and_energy)
lm3 <- update(lm2,~.-Environment_protection)
lm4 <- update(lm3,~.-Agriculture_forestry_fishing_and_hunting)
lm5 <- update(lm4,~.-Economic_affairs_n.e.c.)
lm6 <- update(lm5,~.-Recreation_culture_and_religion)
lm7 <- update(lm6,~.-Mining_manufacturing_and_construction)
lm8 <- update(lm7,~.-Housing_and_community_amenities)
lm9 <- update(lm8,~.-General_public_services)
lm10 <- update(lm9,~.-Defence)
lm11 <- update(lm10,~.-Health)
lm12 <- update(lm11,~.-General_economic_commercial_and_labour_affairs)
lm13 <- update(lm12,~.-Total_function)
lm14 <- update(lm13,~.-Communication)
lm15 <- update(lm14,~.-RandD_Economic_affairs)
lm16 <- update(lm15,~.-Social_protection)
lm17 <- update(lm16,~.-Other_industries)
summary(lm17)

# Through variable selection it was determined that the two most statistically significant variables for Depression percentage
# are Education expense and Public Order and Safety expense. Public order and safety have a negative correlation and Education has a positive correlation.

#Graphing the variables
ggplot(wel_data, aes(x = Education, y = Public_order_and_safety, color = Depression_Per)) +
  geom_point(size = 2, alpha = 0.75) 

# Despite these two variables having statistically significance when looking at the graph there are a few issues to note.
# Public Order and Safety expense and Education expense seem to be positively correlation. This hints to high Multicollinearity.
# Therefore based on the analysis I cannot reliably isolate the individual effects.

# Individual relations
ggplot(wel_data, aes(x = Education, y = Depression_Per)) +
  geom_point(size = 2, alpha = 0.75) 

ggplot(wel_data, aes(x = Public_order_and_safety, y = Depression_Per)) +
  geom_point(size = 0.75, alpha = 0.5) 

# when looking at the individual graphs of the relationship between depression rates and the variables a trend can be observed.
# When both expenses are low we see that depression rates have a higher range and allow for depression rates below 3 percent.
# However when both expenses begin to increase the depression rates stay above 3 percent.
# There could be multiple reasons for this however one potential reason could be that when a country has fewer resources
# The ability to collect data for depression rates or define depression could be hindered leading to lower observed rates. However, more research is needed to confirm this claim. 

#==============================================================================
#   2. Conclusion
#==============================================================================

# The data is not sufficient for determining a relationship between expense and depression rates.
# In future analysis It might be beneficial to find different sources of government expenditures or even combine sectors that have similarities in what they provide to determine a relationship.
# Also this data was focused on 2017. Potentially a different focus year could lead to different results.
# Additional events and country circumstances also differ from country to country. If the analysis is redone potentially including a fix effects model
# could lead to better insights of effects. 
