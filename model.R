library(neuralnet)
library(superml)
setwd("C:/users/ripti/Documents/R/EDA/Project")
lbl = superml::LabelEncoder$new()
data = read.csv("./laptops.csv")
data = as.data.frame(data)
typeof(data)

data = data[,-12]
data = data[complete.cases(data),]


data$Company <- lbl$fit_transform(data$Company)
data$Product = lbl$fit_transform(data$Product)
data$TypeName = lbl$fit_transform(data$TypeName)
data$ScreenResolution = lbl$fit_transform(data$ScreenResolution)
data$Cpu = lbl$fit_transform(data$Cpu)
data$Memory = lbl$fit_transform(data$Memory)
data$Gpu = lbl$fit_transform(data$Gpu)
data$OpSys = lbl$fit_transform(data$OpSys)
data$Ram = lbl$fit_transform(data$Ram)

data

maxs <- apply(data, 2, max) 
mins <- apply(data, 2, min)
scaled <- as.data.frame(scale(data, center = mins, 
                              scale = maxs - mins))
scaled

dt = sort(sample(nrow(data), nrow(data)*.7))

train <- scaled[dt,]
test <-scaled[-dt,]


nn <- neuralnet(Price_euros ~ Company + Product + TypeName + Inches + ScreenResolution 
                + Cpu + Ram + Memory + Gpu + OpSys, 
                data = train, hidden = c(5, 3), 
                linear.output = TRUE)

# Predict on test data
pr.nn <- compute(nn, test[,1:11])

# Compute mean squared error
pr.nn_ <- pr.nn$net.result * (max(data$Price_euros) - min(data$Price_euros)) 
+ min(data$Price_euros)
test.r <- (test$Price_euros) * (max(data$Price_euros) - min(data$Price_euros)) + 
  min(data$Price_euros)
MSE.nn <- sum((test.r - pr.nn_)^2) / nrow(test)

# Plot the neural network
plot(nn)

plot(test$Price_euros, pr.nn_, col = "red", 
     main = 'Real vs Predicted')
abline(0, 1, lwd = 2)