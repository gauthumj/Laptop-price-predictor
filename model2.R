library(neuralnet)
library(superml)
lbl = superml::LabelEncoder$new()
data = read.csv("./data/laptops.csv")
data = as.data.frame(data)

typeof(data)

data = data[,c(4,5,6,7,8,9,10,13)]
data = data[complete.cases(data),]

mdl <- lm(Price_euros ~ TypeName + Inches + ScreenResolution 
                + Cpu + Ram + Memory + Gpu, data = data)
predict(mdl, data[2,])


data$Cpu = lbl$fit_transform(data$Cpu)
data$Gpu = lbl$fit_transform(data$Gpu)
data$TypeName = lbl$fit_transform(data$TypeName)
data$Inches = lbl$fit_transform(data$Inches)
data$ScreenResolution = lbl$fit_transform(data$ScreenResolution)
data$Ram = lbl$fit_transform(data$Ram)
data$Memory = lbl$fit_transform(data$Memory)
data$Price_euros = lbl$fit_transform(data$Price_euros)


maxs <- apply(data, 2, max) 
mins <- apply(data, 2, min)
scaled <- as.data.frame(scale(data, center = mins, 
                              scale = maxs - mins))


dt = sort(sample(nrow(data), nrow(data)*.7))

train <- scaled[dt,]
test <-scaled[-dt,]


nn <- neuralnet(Price_euros ~ TypeName + Inches + ScreenResolution 
                + Cpu + Ram + Memory + Gpu, 
                data = train, hidden = c(4, 2), 
                linear.output = TRUE)
# Predict on test data
pr.nn <- compute(nn, test[,1:7])

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
saveRDS(nn, "nn.rds")
