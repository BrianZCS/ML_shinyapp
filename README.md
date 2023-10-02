# ML_shinyapp

The app predicts the possible number of the scanned receipts for a given future months based on the number of the observed scanned receipts each day for the year 2021. I manually implement Linear Regression because the data is simple. Even though I choose a complicated model, the result will be trivial considering that we only have one predictor (date). 

# App in the open website

You should be able to find my app at https://brianzheng.shinyapps.io/shinyapp/.

# Open the shiny app
Download my shiny add and data_daily.csv file to the local computer. Then open app.R in Rstudio. 
Then call
```
runApp()
```

# Pull my docker file
```
docker pull brianzcs/dockerhub:ml-challenge
```

# More past ML project
Because the challenge has limited input (only date as predictor), I will list more of my ML projects to show my ML skills.

Convolutional Neural Network for classification:

https://github.com/BrianZCS/CNN

Manully implemented decision tree:

https://github.com/BrianZCS/DecisionTree

Reinforcement Learning:

https://github.com/BrianZCS/RL_game

# Load my Docker tar file
```
docker load -i ml-challenge.tar
docker run -d --rm -p 3838:3838 ml-challenge
```
Then the web page will be available at localhost:3838