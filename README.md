# Linear Regression Analysis of Front Desk Traffic at a Salt Lake Hotel

This R language file builds a multiple linear regression model intended to predict the busyness at the front desk for the hotel I have worked at. 

## Collection
I collected the data myself with a little help from a friend from the Marriott's MARSHA reservations database, as well as defining and tracking a metric I am calling "service events" (more on that below).

## Usage
Do not use this data for anything without my explicit permission.

## Feature definitions
* <b>Recording Day of Week</b>: The day of the week the data was recorded.
* <b>Lagged Day of Week</b>: This is a holdover from my analysis of this data as a time series, where I could use an Excel sheet to change the lag on the predictor variables. It's currently set to not lag, since I concluded that this data is not a time series. This is because my familiarity with the industry leads me to believe each day has no significant relation to the last or future days in this day.
* <b>Shift</b>: The shift that the data is true for. AM shifts are from 7am-3pm, and PM shifts last from 3pm-11pm.
* <b>Arrivals</b>: The number of guests who have reservations for a given night and shift.
* <b>Departures</b>: This is recorded for the AM shift, but typically not for the PM shift, since the hotel's checkout time is 3pm, making departures insignificant for the PM shift's busyness.
* <b>Occupancy</b>: This is the percentage of rooms sold at the start of the given shift, given as a number between 0 and 100.
* <b>Guests per Occ</b>: <i>Guests per Occupancy Percentage</i>. This is the total number of guests in the hotel divided by the occupancy percentage.
* <b>NCGR</b>: Standing for <i>Non-Corportate Group Rooms</i>, this counts the number of rooms sold to guest who are traveling for an event that is non-professional in nature (e.g. the RootsTech conference or FanX). These rooms are sometimes a part of a contract with the event organizer or an affiliate. If they are from a contract, this comes from getting the arrivals and departures from the MARSHA database for the defined group. Otherwise, these numbers come from manual counting of people I have reason to believe are traveling for the event in question.
* <b>Service Events</b>: This counts the number of distinct encounters with people who need at least one task done by the desk. For instance, if a guest requested a towel, and another one needed to check in, that would be two service events. If one guest, at check-in, also mentioned she needed a towel, this would be 1 service event.

## Model diagnostics
The plots produced by the R script demonstrate that this model satisfies all the assumptions for linear regression: errors centered at zero, normality of errors, and homoskedacity. The last two are confirmed by a Shapiro-Wilk test and a Breusch-Pagan test respectively. 

## Model results
The adjusted $R^2$ value for the model is $R^2_\text{adj} = 0.662$, with a root-mean-squared error of $\text{RMSE}=11.032$.
