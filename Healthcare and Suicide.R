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
# I wanted to determine if there was a relationship between medicaid and mental health.\
# In order to first determine if this was a worth while relationship to focus on
# I wanted to determine a visual relationship. In Graph 1 there appears to be a
# a slight negative relationship between the two. That is as the percentage of
# citizens covered by medicaid increases the Adjusted suicide rate decreases.


# Variable Selection:

lm1 <- lm(Adj_SR ~ Employer + Non.Group + Medicaid + Military + Uninsured, data = data)
lm2 <- update(lm1,~.-Employer)
lm3 <- update(lm2,~.-Medicaid)
lm4 <- update(lm3,~.-Non.Group)
lm5 <- update(lm4,~.-Military )
summary(lm5)

# In order to determine which variable has the most statistical significance I
# used variable selection. Through variable selection it was discovered that 
# The most statistical significant variable wasn't a certain type of coverage
# but it was coverage in general. The variable Uninsured was the most statistically 
# Significant variable which implies that the inverse variable Insured would be as 
# equally as significant. 

# Regression

lm6 <- lm(Adj_SR ~ Insured + Inpatient_DC, data = data)
summary(lm6)

# After determining that being Insured was the most statistically significant variable. 
# and there was no specific type of health coverage that provided a good predictor for
# mental health I began to look for additional data sets that could be merged with
# this existing data set in order find even more variables that have a connection to
# suicide rate. When looking at a graphic for suicide rates I began to notice a trend
# red states appear to have higher level of suicide rates. We take a look at this trend
# using the following graph.


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
# We can see that based on data from the 2020 election states that voted a majority Biden votes
# tended to have low rates of suicide and also more insured. This could indicate that could
# Indicate that there is some type of connection that legislation in those states
# have with either insurance or mental health. 

# Graph 3

ggplot(data = data, aes(Inpatient_DC, Adj_SR, color = factor(biden_win)))+
  geom_point() +
  labs(color = "Biden Wins", x = "Average Cost per Inpatient Day", 
       y = "Adjusted Suicide Rate")

# another relationship to notes is that there also seems to be a negative correlation
# with Average cost per Inpatient stay per day and Adjusted Suicide rate. This 
# could relationship doesn't seem to make sense at first because that would imply.
# that as the cost of Inpatient stays increase then suicide rates decrease. This would
# be counter intuitive to the fact that we just say how being insured is associated with
# a decrease in suicide rates. However, if we look at economic theory there is an explanation for this.
# Economic explains this in two ways. First the rise in prices of hospital bills
# could mean that the ability and wiliness to pay for insurance for citizens increase as well.
# If it cost around 1761 (The average in Wyoming) to stay in a hospital then less people are likely get 
# insurance as if a medical emergency was to occur then paying out of pocket isn't going to be as a burden.
# However if the cost of medical aid increase then that would incentive more people to get insurance. 
# The second explanation has to do with Moral Hazard. That is when more people are insured hospitals have more
# incentives to increase prices as the demand has increase due to people being able to afford more insurance. 
# Second the Moral hazard on behalf of the patients, if more people are covered then more of the population
# could increase their risk as they know the burden from the consquence of actions are not there's only to bare. 

# Graph 4
ggplot( data = data, aes(Insured, Inpatient_DC, color = biden_win)) + 
  geom_point()
# what was mentioned prior is conformed a bit more when looking at the relationship
# between being insured and the daily cost of inpatient care. 
#==============================================================================
#   2. Conclusion
#==============================================================================

