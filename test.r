data <- read.csv("Data/laptops.csv")

df = as.data.frame(data)
df = df[,c(4,5,6,7,8,9,10,13)]
df = df[complete.cases(df),]


inpdf <- data.frame(matrix(ncol=7,nrow=0))
colnames(inpdf) <- colnames(df[1:7])
inp <- c("Ultrabook", "13.3", "IPS Panel Retina Display 2560x1600",
         "Intel Core i5 2.3GHz", "8GB", "128GB SSD", "Intel Iris Plus Graphics 640" )
inpdf[nrow(inpdf) + 1,] = inp
inpdf$Inches = as.numeric(inpdf$Inches)
print(inpdf)


mdl <- lm(Price_euros ~ TypeName + Inches + ScreenResolution 
          + Cpu + Ram + Memory + Gpu, data = df)
predict(mdl, inpdf)