# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization
# dplyr for data manipulation
# # # # # # # # # # # # # # # # # # # # # # #  

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
library(dplyr) #helps manipulate data

getwd() #displays my working directory

#=====================
# STEP 1: COLLECT DATA
#=====================
Jan_2023 <- read.csv("jan2023.csv")
Feb_2023 <- read.csv("feb2023.csv")
March_2023 <- read.csv("march2023.csv")
April_2023 <- read.csv("april2023.csv")
May_2023 <- read.csv("may2023.csv")
June_2023 <- read.csv("june2023.csv")
July_2022 <-read.csv("july2022.csv")
Aug_2022 <-read.csv("aug2022.csv")
Sep_2022 <-read.csv("sep2022.csv")
Oct_2022 <-read.csv("oct2022.csv")
Nov_2022 <-read.csv("nov2022.csv")
Dec_2022 <-read.csv("dec2022.csv")

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compared column names for each of the files to ensure they all join properly

colnames(Jan_2023)
colnames(Feb_2023)
colnames(March_2023)
colnames(April_2023)
colnames(May_2023)
colnames(June_2023)
colnames(July_2022)
colnames(Aug_2022)
colnames(Sep_2022)
colnames(Oct_2022)
colnames(Nov_2022)
colnames(Dec_2022)

# Renaming the columns to make them consistent
# Inspected the dataframes and looked for incongruencies

str(Jan_2023)
str(Feb_2023)
str(March_2023)
str(April_2023)
str(May_2023)
str(June_2023)
str(July_2022)
str(Aug_2022)
str(Sep_2022)
str(Oct_2022)
str(Nov_2022)
str(Dec_2022)

# Stacked individual data frames into one big data frame
all_2023 <- bind_rows(April_2023, Feb_2023, Jan_2023, June_2023, March_2023, May_2023)
all_2022 <- bind_rows(July_2022, Aug_2022, Sep_2022, Oct_2022, Nov_2022, Dec_2022)
all_trips <- bind_rows(all_2022, all_2023)

# Removing lat and long
all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Ensuring all the dates are the same format

# Converted `started_at` and `ended_at` columns to standard date-time format

all_trips$started_at <- mdy_hm(all_trips$started_at)
all_trips$ended_at <- mdy_hm(all_trips$ended_at)

# Added columns that list the date, month, day, and year of each ride
all_trips <- all_trips %>%
  mutate(
    date = date(started_at),
    month = month(started_at),
    day = day(started_at),
    year = year(started_at),
    day_of_week = wday(started_at, label = TRUE)
  )

#Checking my work so far
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame
dim(all_trips)  #Dimensions of the data frame
head(all_trips) #See the first 6 rows of data frame
tail(all_trips)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics
table(all_trips$year) #Checking to see if both years show

# Added a "ride_length" calculation to all_trips (in seconds)
# Converted date-time strings to POSIXct format with specified format
date_format <- "%m/%d/%y %H:%M"
all_trips$started_at <- as.POSIXct(all_trips$started_at, format = date_format)
all_trips$ended_at <- as.POSIXct(all_trips$ended_at, format = date_format)

# Calculated the ride length using difftime()
all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$date)

# Inspected the structure of the columns
str(all_trips)

# Made sure that "ride_length" from Factor is numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# Removing "bad" data due to some of the data being from the company and we will not use that
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length <= 0),]

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Removed rows with missing values in the ride_length column
all_trips_v2 <- all_trips_v2[complete.cases(all_trips_v2$ride_length),]

# Calculating the mean, median, max, and min ride lengths
mean_ride_length <- mean(all_trips_v2$ride_length)
median_ride_length <- median(all_trips_v2$ride_length)
max_ride_length <- max(all_trips_v2$ride_length)
min_ride_length <- min(all_trips_v2$ride_length)

summary(all_trips_v2$ride_length)

# Comparing members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# Average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# ridership data by type and weekday
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>% #creates weekday field using wday()
  group_by(member_casual, weekday) %>% #groups by usertype and weekday
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% #calculates the avg duration
  arrange(member_casual, weekday) #sorts

# visualization for number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# visualization for average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================

# Creating a csv file that so I can visualize on Tableau

write.csv(all_trips_v2, file = "ride_data_tableau.csv", row.names = FALSE)