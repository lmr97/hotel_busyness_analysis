library(dplyr)
library(ggplot2)
library(ggfortify)
library(MASS)
library(lmtest)
library(regclass)
setwd("/home/martinr/Desktop/Personal_Coding/R/Service Event Prediction")

events.data = read.csv("lag0service_events_data.csv")

events.data$Lagged.Day.of.Week = recode(events.data$Lagged.Day.of.Week,
                                        Sunday = "Su", 
                                        Monday = "Mo",
                                        Tuesday = "Tu",
                                        Wednesday = "We",
                                        Thursday = "Th",
                                        Friday = "Fr", 
                                        Saturday = "Sa")
events.data$Recording.Day.of.Week = recode(events.data$Recording.Day.of.Week, 
                                           Sunday = "Su",
                                           Monday = "Mo",
                                           Tuesday = "Tu",
                                           Wednesday = "We",
                                           Thursday = "Th",
                                           Friday = "Fr",
                                           Saturday = "Sa")

events.data$Date = as.Date(events.data$Date, format="%m/%d/%Y")

# exclude extreme outliers
events.data[c(12,17,30,41,57,84,165,177),1:4]
events.data = events.data[-c(12,17,30,41,57,84,165,177),]
attach(events.data)

print("#####################################################################")
print("################# Difference in SEs by Day of Week ##################")
print("#####################################################################")

summary(aov(Service.Events ~ Recording.Day.of.Week))
boxplot(Service.Events ~ Recording.Day.of.Week)

print("#####################################################################")
print("######################### Model Optimizing ##########################")
print("#####################################################################")

full = lm(Service.Events ~ Lagged.Day.of.Week + 
          Arrivals + Departures + NCGR + Guests.per.Occ. +
          Occupancy, data = events.data)

null = lm(Service.Events ~ 1, data = events.data)

best.model = stepAIC(full, scope=list(lower=null, upper=full),
                         data=events.data, direction='both')

print("#####################################################################")
print("########################## Model Results ############################")
print("#####################################################################")

summary(best.model)

print("#####################################################################")
print("####################### Assumption Checking #########################")
print("#####################################################################")

plot(best.model)

# check for multicollinearity
cor(events.data[, 5:9]) # shows all correlations
plot(Arrivals ~ Occupancy)  # most significant, investigate VIF of each variable

# investigate most correlated variables for VIF
VIF(best.model)
 
bptest(best.model)
shapiro.test(best.model$residuals)

print("#####################################################################")

print("########################### Prediction ##############################")
print("#####################################################################")

pred.x = data.frame(Shift = "PM",
                    Lagged.Day.of.Week = "Th",
                    Arrivals = 13,
                    Departures = 0,
                    Occupancy = 65,
                    NCGR = 0,
                    Guests.per.Occ. = 83.0/65.0)

predict(best.model, pred.x)