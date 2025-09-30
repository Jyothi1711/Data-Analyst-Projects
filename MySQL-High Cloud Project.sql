Create database maindata;

Select * from maindata;

/*KPI1 - "1.calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)"
   A.Year
   B.Monthno
   C.Monthfullname
   D.Quarter(Q1,Q2,Q3,Q4)
   E. YearMonth ( YYYY-MMM)
   F. Weekdayno
   G.Weekdayname
   H.FinancialMOnth
   I. Financial Quarter*/

drop table KPI1;
create table KPI1 (
date Date,
Year int,
Month int,
Day int,
week int,
Monthname varchar(50),
Weekday int,
yearmonth varchar(50),
Dayname varchar(50),
Quarters varchar(50),
Financial_Months Varchar(50),
Financial_Quarters Varchar(50));

Insert into KPI1 (date, Year,Month,Day,week,Monthname,Weekday,yearmonth,Dayname,Quarters,Financial_months,Financial_Quarters)
select
concat(year,"-",month,"-",day) as date,
Year(concat(year,"-",month,"-",day)) as year,
Month(concat(year,"-",month,"-",day)) as month,
Day(concat(year,"-",month,"-",day)) as Day,
week(concat(year,"-",month,"-",day)) as week,
monthname(concat(year,"-",month,"-",day)) as monthname,
dayofweek(concat(year,"-",month,"-",day)) as weekday,
concat(year(concat(year,"-",month,"-",day)),'-',monthname(concat(year,"-",month,"-",day))) as yearmonth,
dayname(concat(year,"-",month,"-",day)) as dayname,

case 
when monthname(concat(year,"-",month,"-",day)) in ('January','February','March') then 'Q1'
when monthname(concat(year,"-",month,"-",day)) in ('April','May','June') then 'Q2'
when monthname(concat(year,"-",month,"-",day)) in ('July','August','September') then 'Q3'
else 'Q4'
end as quarters,

case
when monthname(concat(year,"-",month,"-",day))='January' then 'FM10'
when monthname(concat(year,"-",month,"-",day))='February' then 'FM11'
when monthname(concat(year,"-",month,"-",day))='March' then 'FM12'
when monthname(concat(year,"-",month,"-",day))='April' then 'FM1'
when monthname(concat(year,"-",month,"-",day))='May' then 'FM2'
when monthname(concat(year,"-",month,"-",day))='June' then 'FM3'
when monthname(concat(year,"-",month,"-",day))='July' then 'FM4'
when monthname(concat(year,"-",month,"-",day))='August' then 'FM5'
when monthname(concat(year,"-",month,"-",day))='September' then 'FM6'
when monthname(concat(year,"-",month,"-",day))='October' then 'FM7'
when monthname(concat(year,"-",month,"-",day))='November' then 'FM8'
when monthname(concat(year,"-",month,"-",day))='December' then 'FM9'
end as Financial_months,

case when monthname(concat(year,"-",month,"-",day)) in ('January','February','March') then 'FQ4'
when monthname(concat(year,"-",month,"-",day)) in ('April','May','June') then 'FQ1'
when monthname(concat(year,"-",month,"-",day)) in ('July','August','September') then 'FQ2'
else 'FQ3' 
end as Financial_Quarters from maindata;
desc KPI1;
Select * from KPI1 limit 10;

/*KPI2 - 2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)*/
/*Load Factor % on Year, Quarter and Month*/

Select year as year, 
concat(round(count(Transported_passengers/Available_Seats)/1000,2),"%") as "Load_Factor_Percentage" from maindata
group by Year;

Select 
case 
when monthname(concat(year,"-",month,"-",day)) in ('January','February','March') then 'Q1'
when monthname(concat(year,"-",month,"-",day)) in ('April','May','June') then 'Q2'
when monthname(concat(year,"-",month,"-",day)) in ('July','August','September') then 'Q3'
else 'Q4'
end as quarters, 
concat(round(count(Transported_passengers/Available_Seats)/1000,2),"%") as "Load_Factor_Percentage" from maindata
group by quarters;

Select monthname(concat(year,"-",month,"-",day)) as "monthname", 
concat(round(count(Transported_passengers/Available_Seats)/1000,2),"%") as "Load_Factor_Percentage" from maindata
group by monthname;

/*KPI3 - 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)*/
/*Top 10 load Factor % on a Carrier Name */

Select carrier_name, 
ifnull(concat(round(count(Transported_passengers/Available_Seats)/1000,2),"%"),0) as "Load_Factor_Percentage" from maindata
group by Carrier_name
order by Load_Factor_Percentage desc limit 10;

/*KPI4 - 4. Identify Top 10 Carrier Names based passengers preference */
/*Top 10 Carrier Names based on Passenger preference*/

select carrier_name, count(transported_passengers) as Total_Passengers from maindata
group by carrier_name
order by Total_Passengers desc limit 10;

/*KPI5 - 5. Display top Routes ( from-to City) based on Number of Flights */
/*Top 10 Routes (from-to City) based on Number of Flights*/

Select from_to_city, count(Airline_ID) as No_of_flights from maindata
group by from_to_city
order by No_of_flights desc limit 10;

/*KPI6 - 6. Identify the how much load factor is occupied on Weekend vs Weekdays.*/
/*Load Factor occupied on Weekend vs Weekdays*/

Select
case when dayofweek(concat(year,"-",month,"-",day)) in (1,7)
then 'Weekend' else 'Weekday' end as Weekday_Weekend, 
concat(round(count(Transported_passengers/Available_Seats)/1000,2),"%") as "Load_Factor_Percentage" from maindata
group by Weekday_Weekend;

/*KPI7 - 7. Identify number of flights based on Distance group*/
/*Number of Flights based on group*/

Select Distance_Group_ID,count(departures_performed) as No_of_Flights from maindata
group by Distance_Group_ID
order by No_of_flights desc;












/*KPI10 - 10. Use the filter to provide a search capability to find the flights between 
Source Country, Source State, Source City to Destination Country , Destination State, Destination City*/

Select carrier_name, origin_country, Destination_country, Origin_state, Destination_state, Origin_city,Destination_city from maindata;
