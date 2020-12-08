#############################
#Data science first project #
#Energy efficiency          #
#Kisal wije@Rshiny          #
#############################
library(tidyverse)
library(caret)
library(randomForest)
# import data
energy <- read.csv("F:/energy/ENB2012_data.csv")
# rename columns
colnames(energy) <- c("relative_compactness", "surface_area", "wall_area", 
                      "roof_area", "overall_height", "orientation", "glazing_area",
                      "glazing_area_distribution", "heating_load", "cooling_load")

# normalization
#preproc <- preProcess(energy[,1:8], method = "range")
#energy <- predict(preproc, energy)



# split data
set.seed(123)
ind <- sample(2, nrow(energy), replace = T, prob = c(0.7,0.3))
train <- energy[ind==1,]
test <- energy[ind==2,]

# modeling
rf1 <- randomForest(heating_load~., data = train[-10], ntree = 500,
                    mtry = 8,
                    importance = TRUE,
                    proximity = TRUE)
rf2 <- randomForest(cooling_load~., data = train[-9])

# prediction
pred <- predict(rf1,test[1:8])


# Hyper parameter tuning for models
plot(rf1)

t <- tuneRF(train[,1:8], train[,9],
       stepFactor = 0.5,
       plot = TRUE,
       ntreeTry = 500,
       trace = TRUE,
       improve = 0.05)

t2 <- tuneRF(train[,1:8], train[,10],
             stepFactor = 0.5,
             plot = TRUE,
             ntreeTry = 233,
             trace = TRUE,
             improve = 0.05)

# save models
saveRDS(rf1, "model1.rds")
saveRDS(rf2, "model2.rds")

