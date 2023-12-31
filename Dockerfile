# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest 

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# install renv & restore packages
RUN Rscript -e 'install.packages("tidyverse")'
RUN Rscript -e 'install.packages("lubridate")'

RUN mkdir /root/app

COPY . /root/app

EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('/root/app', host = '0.0.0.0', port = 3838)"]