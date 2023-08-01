<h1>Cyclistic Case Study - Capstone Project</h1>

 ### [Tableau Dashboard](https://public.tableau.com/app/profile/emely.ortiz/viz/CyclisticCaseStudy-CapstoneProject_16908757833220/Dashboard1)

<h2>Description</h2>
For my Google Data Analytics Certificate capstone project, I worked with a public dataset for a fictional company provided by the course. The dataset consisted of bikeshare data from various months in 2022 and 2023, including ride information such as start and end times, ride lengths, user types (members or casual users), and the day of the week. The primary objectives of the project were data cleaning, data combination, ride length calculation, and analyzing ride patterns for different user types.


<h2>Business Task</h2>
Cyclistic, a bike-share company with 5,824 bicycles and 692 stations in Chicago, aims to increase profitability by converting casual riders into annual members. The finance analysts have determined that annual members generate higher profits compared to casual riders. To achieve this goal, Moreno's marketing team plans to design effective strategies. The team aims to understand the differences in usage patterns between annual members and casual riders, the reasons why casual riders might purchase annual memberships, and the impact of digital media on marketing tactics. This analysis seeks to provide valuable insights to guide the future marketing program.
<br />

<h2>Languages and Utilities Used</h2>

- <b>R programming language</b> 
- <b>tidyverse: A collection of R packages for data wrangling and visualization.</b>
- <b>lubridate: A package for working with dates and times in R.</b>
- <b>ggplot2: A data visualization package in R.</b>
- <b>dplyr: A package for data manipulation in R.</b>

<h2>Environments Used </h2>

- <b>Windows 10</b>
- <b>RStudio</b>
- <b>Tableau</b>

<h2>Data Cleaning and Manipulation</h2>
All datasets were combined into a single data frame and inconsistent column dates across different datasets were resolved.<br />

```ruby
all_2023 <- bind_rows(April_2023, Feb_2023, Jan_2023, June_2023, March_2023, May_2023)
all_2022 <- bind_rows(July_2022, Aug_2022, Sep_2022, Oct_2022, Nov_2022, Dec_2022)
all_trips <- bind_rows(all_2022, all_2023)
```

```ruby
all_trips$started_at <- mdy_hm(all_trips$started_at)
all_trips$ended_at <- mdy_hm(all_trips$ended_at)
```

Columns with latitude and longitude were removed as they were not needed for the analysis. <br />

```ruby
all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))
```

Date-time columns were converted to standard date-time format, and additional columns for date, month, day, year, and day of the week were added to facilitate analysis. <br />

```ruby
all_trips <- all_trips %>%
  mutate(
    date = date(started_at),
    month = month(started_at),
    day = day(started_at),
    year = year(started_at),
    day_of_week = wday(started_at, label = TRUE)
  )
```

Added a "ride_length" calculation to all_trips (in seconds) and converted date-time then calculated ride length using difftime().<br />

```ruby
all_trips$started_at <- as.POSIXct(all_trips$started_at, format = date_format)
all_trips$ended_at <- as.POSIXct(all_trips$ended_at, format = date_format)
```

```ruby
all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$date)
```


<h2>Summary of Analysis</h2>
I calculated descriptive statistics such as mean, median, max, and min ride lengths for each group. <br />


```ruby
mean_ride_length <- mean(all_trips_v2$ride_length)
median_ride_length <- median(all_trips_v2$ride_length)
max_ride_length <- max(all_trips_v2$ride_length)
min_ride_length <- min(all_trips_v2$ride_length)
```

I explored how ride patterns vary based on user types and weekdays. <br />

```ruby
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)
```
<h2>Export and Import to Tableau</h2>
Created a .csv file to import and visualize on Tableau.

```ruby
write.csv(all_trips_v2, file = "ride_data_tableau.csv", row.names = FALSE)
```

<p align="center">
<br />
<br />
Ride Trends by User Type and Year: <br/>
<img src="https://i.imgur.com/HQXMWyq.jpg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Popular Rideable Types by User Type:  <br/>
<img src="https://i.imgur.com/MBkpyep.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Seasonal Variation in Rides: <br/>
<img src="https://i.imgur.com/UiUPn62.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Weekly Usage Patterns:  <br/>
<img src="https://i.imgur.com/23tkLXS.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
</p>

<h2>Recommendations</h2>
Based on the analysis, I recommend the following to optimize Cyclistic's marketing efforts:

- <b>Targeted Seasonal Campaigns:</b> Implement targeted marketing campaigns during peak months to capitalize on higher user engagement. Focus on highlighting the benefits of annual memberships during periods of increased ride activity.
- <b>Promote Electric Bikes:</b> Leverage the popularity of electric bikes among both user types. Offer exclusive promotions or discounts on annual memberships for users opting for electric bikes to incentivize conversions.
- <b>Weekend Promotions:</b> Design special weekend promotions to appeal to casual riders who primarily use the service on weekends. Offer attractive deals for upgrading to annual memberships during these periods.
- <b>Incentives for Frequent Users:</b> Provide incentives to casual riders who frequently use the service, such as discounts on annual memberships based on the number of rides taken within a specific period.
- <b>Personalized Digital Campaigns:</b> Utilize digital media to deliver personalized messages to casual riders based on their usage patterns and preferences. These campaigns can highlight the benefits of becoming annual members, tailored to individual user needs.

<h2>Data Sources</h2>

The data for this analysis was obtained from the Divvy [bike-share program](https://divvy-tripdata.s3.amazonaws.com), a bike-sharing service based in Chicago. The dataset used in this analysis includes trip data for the last 12 months, covering a period from July 2022 to June 2023. The data was made available by Divvy under their [data license agreement](https://ride.divvybikes.com/data-license-agreement).

<br />
<br />

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
