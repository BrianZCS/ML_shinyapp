library(shiny)
library(bslib)
library(tidyverse)
library(lubridate)

data = read_csv("./data_daily.csv")
colnames(data) = c('Date', 'Receipt_Count')

## data screening
lm = lm(Receipt_Count~Date,data)
summary(lm)
plot(data, cex = 1, col = "blue") #Plot the results
abline(lm,lwd = 2,col = "red")

# Train test split
sample = sample(c(TRUE, FALSE), nrow(data), replace = TRUE, prob = c(0.7,0.3))
train = data[sample,]
test = data[!sample,]

## Because the challenge requires to show the ML skills, here is the code to implement Linear Regression without using package
X <- as.matrix(train$Date) # extract your predictors
X <- cbind(1, X) # add an intercept to your design matrix
y <- train$Receipt_Count
betas <- solve(t(X) %*% X) %*% t(X) %*% y

y_bar = betas[1,1] + betas[2,1]*as.numeric(test$Date)
MSE = sum((y_bar-test$Receipt_Count)^2)/nrow(test)
MSE


# Validation
lm = lm(Receipt_Count~Date,train)
y_bar = predict(lm, data.frame('Date' = test$Date))
MSE = sum((y_bar-test$Receipt_Count)^2)/nrow(test)
MSE

# From the graph, linear model seems perfect. However, we don't want a straight line. 
# Lukily, based on the graph above, the points are evenly distributed in two sides of linear regression line.
# So I decided to calculate the standard deviation of the normal noise which I can add to my model. 
sd = mean(c(sd(data$Receipt_Count[month(data$Date)==1]),sd(data$Receipt_Count[month(data$Date)==2]),
            sd(data$Receipt_Count[month(data$Date)==3]),sd(data$Receipt_Count[month(data$Date)==4]),
            sd(data$Receipt_Count[month(data$Date)==5]),sd(data$Receipt_Count[month(data$Date)==6]),
            sd(data$Receipt_Count[month(data$Date)==7]),sd(data$Receipt_Count[month(data$Date)==8]),
            sd(data$Receipt_Count[month(data$Date)==9]),sd(data$Receipt_Count[month(data$Date)==10]),
            sd(data$Receipt_Count[month(data$Date)==11]),sd(data$Receipt_Count[month(data$Date)==12])))

# Validation
lm = lm(Receipt_Count~Date,train)
y_bar = predict(lm, data.frame('Date' = test$Date)) + rnorm(nrow(test), 0, sd)
MSE = sum((y_bar-test$Receipt_Count)^2)/nrow(test)
MSE
## Although the MSE increases, the receipt count makes more sense. 

## visualization
plot(test$Date, y_bar, col = "blue")
par(new=TRUE)
plot(test$Date, test$Receipt_Count)
abline(lm,lwd = 2,col = "red")

# when predict next year, we want to use as many data as possible
lm = lm(Receipt_Count~Date,data)

ui <- fluidPage(
  titlePanel("Fetch Machine Learning Challenge"),
  tabsetPanel(
    tabPanel("Prediction",
             dateInput(
               "date",
               "Date:",
               value = "2022-01-01",
               min = "2022-01-01",
               max = "2022-12-31",
               format = "yyyy-mm-dd"
             ),
             textOutput("text"),
    ),
    tabPanel("Home Page",
             p("Author: Zhi Zheng (Brian),
                Email: zzheng94@wisc.edu,
               Education: UW-Madison"),
             h2("Introduction"), 
             p("This project predicts the possible number of the scanned receipts for a given future month."),
    )),
  theme = bs_theme(
    fg = "#000000",
    bg = "#b8e2f2"
  ))

server <- function(input, output) {
  output$text = renderText(paste("The predicted recript count is: ", round(predict(lm, data.frame('Date' = input$date))+ rnorm(1, 0, sd))))
}

shinyApp(ui, server)

