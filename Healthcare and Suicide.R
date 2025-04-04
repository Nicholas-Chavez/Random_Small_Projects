#Data: The Data used in this Analysis was collected from Kff.org, cdc.gov, and kaggle.com.
#The Data was merged using excel with the states being the index for all the data. All data was taken from the year 2022 with a exception of the biden voters data 
# which was taken from 2020 as that was when the last presidential election took place. 
#Medicaid Data: https://www.kff.org/other/state-indicator/health-insurance-coverage-population-0-64/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D
#Suicide Rate Data: https://www.cdc.gov/suicide/facts/rates-by-state.html
# Voter Data: https://www.kaggle.com/datasets/callummacpherson14/2020-us-presidential-election-results-by-state
#Inpatient Data: https://www.kff.org/health-costs/state-indicator/expenses-per-inpatient-day/?currentTimeframe=0&selectedRows=%7B%22states%22:%7B%22all%22:%7B%7D%7D%7D&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D

#==============================================================================
#   1. Settings, packages, and options
#==============================================================================
library(tidyverse)

setwd("C:/Users/Nicho/OneDrive/Desktop")
data <- read.csv("HC_Coverage_suicide.csv")

#==============================================================================
#   2. Analysis section
#==============================================================================
view(data)

# Graph 1
ggplot(data = data, aes(Medicaid, Adj_SR, color)) +
  geom_point()
# I wanted to determine if there was a relationship between Medicaid and suicide rates. 
# To first determine if this was a worthwhile relationship to analyze
# I wanted to determine a visual relationship. In Graph 1 there appears to be
# a slight negative relationship between the two. That is as the percentage of
# citizens covered by Medicaid increases the adjusted suicide rate decreases.


# Variable Selection:

lm1 <- lm(Adj_SR ~ Employer + Non.Group + Medicaid + Military + Uninsured, data = data)
lm2 <- update(lm1,~.-Employer)
lm3 <- update(lm2,~.-Medicaid)
lm4 <- update(lm3,~.-Non.Group)
lm5 <- update(lm4,~.-Military )
summary(lm5)

# To determine which variable has the most statistical significance I
# used variable selection. Through variable selection, it was discovered that 
# the most statistically significant variable wasn't a type of coverage
# but it was overall coverage. The variable Uninsured was the most statistically 
# significant variable which implies that the inverse variable Insured would be
# equally as significant. 

# Regression

lm6 <- lm(Adj_SR ~ Insured + Inpatient_DC, data = data)
summary(lm6)

# After determining that being Insured was the most statistically significant variable. 
# and there was no specific type of health coverage that provided a good predictor for
# mental health I began to look for additional data sets that could be merged with
# this existing data set to find even more variables that have a connection to
# suicide rate. When looking at a graphic for suicide rates I began to notice a trend
# red states appear to have higher levels of suicide rates. We take a look at this trend
# using the following graph (Graph 2). 


# Graph 2
data$biden_win <- as.factor(data$biden_win)  
ggplot(data = data, aes(Insured, Adj_SR, color = biden_win)) +
  geom_point() +
  labs(color = "Biden Win")+
  scale_color_manual(
    name   = "Biden Win",  
    values = c("0" = "red", "1" = "blue"),  
    labels = c("0" = "No", "1" = "Yes")    
  )
# Based on data from the 2020 presidential election, states that had voted and resulted in Joe Biden as the majority
# tended to have low rates of suicide and also more insured citizens. This could indicate that 
# there is some connection that legislation in those states
# and either insurance or mental health. 

# Graph 3

ggplot(data = data, aes(Inpatient_DC, Adj_SR, color = factor(biden_win)))+
  geom_point() +
  labs(color = "Biden Wins", x = "Average Cost per Inpatient Day", 
       y = "Adjusted Suicide Rate")

# There also seems to be a negative correlation between the average cost per inpatient stay per day and the adjusted suicide rate. This 
# relationship doesn't seem to make sense initially because  1) Insurance is a means to reduce the cost of healthcare and 2) The relationship between Insurance and suicide rate has a negative correlation, based on Graph 1. 
# However, if we look at economic theory there is an explanation for this.
# Economics explains this event in two ways. First, the rise in prices of hospital bills
# could mean that the ability and willingness to pay for insurance for citizens increase as well.
#For Example, if it costs around 1761 USD(The average in Wyoming) to stay in a hospital, and let's assume 1761 USD is a reasonable price for a majority of citizens, fewer people are likely to get 
# insurance if a medical emergency was to occur because paying out of pocket isn't going to be enough of a burden.
# However if the cost of medical care increases to a point where a medical emergency would hinder people's well-being by a significant amount then such an event would incentivize more people to get insurance. 
# The second explanation has to do with Moral Hazard. That is when more people are insured hospitals have more
# incentives to increase prices as the demand has increased due to people being able to afford more healthcare.
# Additionally, there is a Moral hazard on behalf of the patients. If more people are covered then more of the population
# has an incentive to take on more risk as they know the burden from the consequence of their actions and not there's only to bear. 

# Graph 4
ggplot( data = data, aes(Insured, Inpatient_DC, color = biden_win)) + 
  geom_point()
# what was mentioned prior is confirmed a bit more when looking at the relationship
# between being insured and the daily cost of inpatient care per day. 
#==============================================================================
#   2. Conclusion
#==============================================================================

#To summarize, there are moderate relationships between suicide rates, insurance coverage, and the average cost of inpatient stays per day. 
# However, when incorporating votes during the 2020 Presidential Election, Red States tend to have higher levels of suicide rates in 2022 than Blue States. 
# Despite the previously established relationships this new relationship puts less emphasis on the other variables and more on political ideology. # This emphasis on Political Ideology would indicate that on the issue of suicide rate and mental health, it might be more worthwhile to look at predictor variables that take into account areas of policy in which there are differences based on Political Ideology. 
