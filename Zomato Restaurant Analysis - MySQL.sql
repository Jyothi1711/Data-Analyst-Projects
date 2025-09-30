create database Zomato;

select * from countrycode;

/*2. Build a Calendar Table using the Column Datekey
  Add all the below Columns in the Calendar Table using the Formulas.
   A. Year
   B. Monthno
   C. Monthfullname
   D. Quarter(Q1,Q2,Q3,Q4)
   E. YearMonth ( YYYY-MMM)
   F. Weekdayno
   G. Weekdayname
   H. FinancialMOnth ( April = FM1, May= FM2  …. March = FM12)
   I. Financial Quarter ( Quarters based on Financial Month) - APRIL-JUNE: FQ1, JULY-SEP:FQ2, OCT-DEC: FQ3, JAN-MARCH:FQ4*/
   
drop table KPI1;
create table KPI1 (
date date,
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
Datekey_Opening as date,
Year(Datekey_Opening) as year,
Month(Datekey_Opening) as month,
Day(Datekey_Opening) as Day,
week(Datekey_Opening) as week,
monthname(Datekey_Opening) as monthname,
dayofweek(Datekey_Opening) as weekday,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) as yearmonth,
dayname(Datekey_Opening) as dayname,

case 
when monthname(Datekey_Opening) in ('January','February','March') then 'Q1'
when monthname(Datekey_Opening) in ('April','May','June') then 'Q2'
when monthname(Datekey_Opening) in ('July','August','September') then 'Q3'
else 'Q4'
end as quarters,

case
when monthname(Datekey_Opening)='January' then 'FM10'
when monthname(Datekey_Opening)='February' then 'FM11'
when monthname(Datekey_Opening)='March' then 'FM12'
when monthname(Datekey_Opening)='April' then 'FM1'
when monthname(Datekey_Opening)='May' then 'FM2'
when monthname(Datekey_Opening)='June' then 'FM3'
when monthname(Datekey_Opening)='July' then 'FM4'
when monthname(Datekey_Opening)='August' then 'FM5'
when monthname(Datekey_Opening)='September' then 'FM6'
when monthname(Datekey_Opening)='October' then 'FM7'
when monthname(Datekey_Opening)='November' then 'FM8'
when monthname(Datekey_Opening)='December' then 'FM9'
end as Financial_months,

case when monthname(Datekey_Opening) in ('January','February','March') then 'FQ4'
when monthname(Datekey_Opening) in ('April','May','June') then 'FQ1'
when monthname(Datekey_Opening) in ('July','August','September') then 'FQ2'
else 'FQ3' 
end as Financial_Quarters from data;
desc KPI1;
Select * from KPI1 limit 10;

#3.Find the Numbers of Restaurants based on City and Country.
select city, count(restaurantID) as Total_City from data
group by city
order by count(RestaurantID) desc
limit 10;

select country, count(restaurantid) as Total_Restaurant from data d
left join countrycode c on d . CountryCode = c. CountryCode
group by country 
order by count(RestaurantID)desc
limit 10;

#4.Numbers of Restaurants opening based on Year , Quarter , Month
select distinct Year(Datekey_Opening) as year, count(*) as "#Restaurants_opening" from data
group by year;

select distinct Monthname(Datekey_Opening) as month, count(*) as "#Restaurants_opening" from data
group by month;

select 
case 
when monthname(Datekey_Opening) in ('January','February','March') then 'Q1'
when monthname(Datekey_Opening) in ('April','May','June') then 'Q2'
when monthname(Datekey_Opening) in ('July','August','September') then 'Q3'
else 'Q4'
end as Quarters,
count(*) as "#Restaurants_opening" from data
group by quarters;

#5. Count of Restaurants based on Average Ratings
select rating, count(Restaurantid) as Total_Restaurants from data
group by rating
order by  count(Restaurantid) desc;

#6. Create buckets based on Average Price of reasonable size and find out how many restaurants falls in each buckets
select 
case
when Average_Cost_for_two_Rs between 0 and 300 then '0-300'
when Average_Cost_for_two_Rs between 301 and 600 then '301-600'
when Average_Cost_for_two_Rs between 601 and 1000 then '601-1000'
when Average_Cost_for_two_Rs between 1001 and 45000 then '1001-45000'
else "others"
end as Cost_Range_Bucket, count(restaurantid) as Total_Restaurants
  from data
group by cost_range_bucket;

#7. Percentage of Restaurants based on "Has_Table_booking"
select Has_Table_booking, count(*) as Total_Restaurants, concat(round((count(*)/(select count(*) from data))*100,2),"%") as Percentage from data
group by Has_Table_booking;

#8. Percentage of Restaurants based on "Has_Online_delivery"
select Has_Online_delivery, count(*) as Total_Restaurants, concat(round((count(*)/(select count(*) from data))*100,2),"%") as Percentage from data
group by Has_Online_delivery;

#KPI Multirow Card
Select count(*) as Total_Restaurants, count(distinct(CountryCode)) as Total_Countries, count(distinct(City)) as Total_Cities,
concat(round(count(distinct(Cuisines))/1000,3),'K') as Total_Cuisines, concat(round(sum(Votes)/1000000.0,0),'M') as Total_Votes,
( select count(Has_Online_delivery)  from data
where Has_Online_delivery="Yes") as Online_Delivery_Restaurants, round(avg(rating),2) as  "Avg.Rating" from data;

#Top 10 Popular Restaurants
select RestaurantName as Top_10_Popular_Restaurants, sum(Votes) as No_Of_Votes from data
group by RestaurantName
order by sum(Votes) desc
limit 10;

#Top 10 Popular Cuisines
select Cuisines as Top_10_Popular_Cuisines, sum(Votes) as No_Of_Votes from data
group by Cuisines
order by sum(Votes) desc
limit 10;

#Distribution of Restaurant Across Different Cities
Select city,count(*) As Total_Restaurant from data
group by city
order by Total_Restaurant desc;
order by Total_Restaurant desc;




