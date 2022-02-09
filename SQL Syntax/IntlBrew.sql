/*
* 1. Create the table Saleorders
*/
DROP TABLE IF EXISTS SalesOrders;

CREATE TABLE IF NOT EXISTS SalesOrders
(
    SALES_ID integer PRIMARY KEY NOT NULL,
    SALES_REP character varying(10)NOT NULL,
    EMAILS character varying(30)NOT NULL,
    BRANDS character varying(20) NOT NULL,
   	PLANT_COST NUMERIC NOT NULL,
    UNIT_PRICE NUMERIC NOT NULL,
	QUANTITY INTEGER NOT NULL,
	COST NUMERIC NOT NULL,
    PROFIT NUMERIC NOT NULL,
	COUNTRIES character varying(20) NOT NULL,
	REGION character varying(20) NOT NULL,
	MONTHS character varying(20) NOT NULL,
	YEARS character varying(20) NOT NULL
);

/*
* 2. Import the data into the the table Salesorders and confirm upload
*/
COPY Salesorders
FROM 'C:\**...\International_Breweries.csv'
DELIMITER ',' 
CSV HEADER;

SELECT * FROM Salesorders;

/*
* Session A.1 Within the space of the last three years, what was the profit worth of the breweries,
inclusive of the anglophone and the francophone territories
*/

SELECT years, to_char(SUM(profit),'FML999,999,999,999,999,999.00') AS "Profit Worth" FROM SalesOrders
GROUP BY 1
ORDER BY 1;

/*
* Session A.2 Profit per Territory 
*/

SELECT years,
	CASE
		WHEN countries = 'Ghana' 	THEN 'Anglophone'
		WHEN countries = 'Nigeria' 	THEN 'Anglophone'
		WHEN countries = 'Benin' 	THEN 'Francophone'
		WHEN countries = 'Senegal' 	THEN 'Francophone'
		WHEN countries = 'Togo' 	THEN 'Francophone'
		ELSE 'Undefined Region'
	END AS regioncalc,
to_char(SUM(profit),'FML999,999,999,999,999,999.00') AS "Annual Profit per Territory" FROM SalesOrders
GROUP BY 1,2
ORDER BY 1 ASC;

/*
* From the profit per territory, it is observed that Profit is reducing for the both the anglophone & francophone countries on a year-on-year 
basis 
Franco: ($22.7m -> 22.3m -> 18.0m) 
Anglo: ($15.7m -> 14.6m -> 11.9m)

Sales in the francophone countries held steady in the first two years and then had a slight dip in 2019
compared to steady dip observed in the Anglophone countries
*/

/*
* Session A.3 Country that generated the highest profit in 2019,
*/
SELECT countries,years, SUM(profit) AS "Profit per Country - 2019" FROM SalesOrders
WHERE years = '2019'
GROUP BY 1,2
ORDER BY 2 DESC,3 DESC
LIMIT 1;

/*
* Session A.4 Year with the highest profit.
*/

SELECT years, SUM(profit) AS "Profit per Year" FROM SalesOrders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*
* Session A.5 Which month in the three years was the least profit generated?
*/
SELECT years, months, SUM(profit) AS "Least Monthly Profit over Period" FROM SalesOrders
GROUP BY 1,2
ORDER BY 3 
LIMIT 3;

/*
* Session A.6. What product had the minimum profit in the month of December 2018?
*/
SELECT years, months, brands, SUM(profit) AS "Minumum Profit in Dec 2018" FROM SalesOrders
WHERE years = '2018' AND months = 'December'
GROUP BY 1,2,3
ORDER BY 4 ASC
LIMIT 1;

/*
* Session A.7 Compare the profit in percentage for each of the month in 2019
*/
SELECT years, months,SUM(cost) AS "Cost Price",SUM(profit) AS "Monthly Profit",to_char(100*(SUM(profit)/SUM(cost)),'FM990D99%') As "Profit % Per Month" FROM SalesOrders
WHERE years = '2019'
GROUP BY 1,2
ORDER BY 1,CASE
		WHEN months = 'January' 	THEN '01'
		WHEN months = 'February' 	THEN '02'
		WHEN months = 'March' 		THEN '03'
		WHEN months = 'April' 		THEN '04'
		WHEN months = 'May'		 	THEN '05'
		WHEN months = 'June' 		THEN '06'
		WHEN months = 'July' 		THEN '07'
		WHEN months = 'August' 		THEN '08'
		WHEN months = 'September'	THEN '09'
		WHEN months = 'October' 	THEN '10'
		WHEN months = 'November'	THEN '11'
		WHEN months = 'December' 	THEN '12'
		ELSE 'Undefined Month'
	END 

B2
SELECT years, months, SUM(cost) AS "Cost Price", SUM(profit) AS "Monthly Profit",
to_char(100*(SUM(profit)/SUM(cost)),'FM990D99%') As "Profit % Per Month"
FROM SalesOrders
WHERE years = '2019'
GROUP BY 1,2
ORDER BY to_date(months, 'month')


/*
* Session A.8 Which particular brand generated the highest profit in Senegal?
*/
SELECT countries,brands, SUM(profit) AS "Highest Profit per Brand-Senegal" FROM SalesOrders
WHERE countries = 'Senegal'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

/*
* Session B.1 the top three brands consumed in the francophone countries
*/

SELECT brands,countries, to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Top 3 - Francophone Countries " FROM SalesOrders
			WHERE countries IN ('Benin', 'Senegal', 'Togo')
			GROUP BY 1,2
			ORDER BY SUM(Quantity) DESC
		LIMIT 3;

/*
* Session B.2 Find out the top two choice of consumer brands in Ghana
*/

SELECT countries, brands,to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Top 2 Brands in Ghana" FROM SalesOrders
WHERE countries = 'Ghana'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 2;

/* Session B.3  Find out the details of beers consumed in the past three years in the most oil rich
country in West Africa.
*/
	

SELECT countries,brands, to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Beer Details - Nigeria" FROM SalesOrders
	WHERE countries = 'Nigeria' AND
	brands NOT LIKE '%malt%'
	GROUP BY 2,1
	ORDER BY 1,3 DESC;	

/* Session B.4  Favorites malt brand in Anglophone region between 2018 and 2019
*/
SELECT brands, to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Favorites malt brand - Anglophone" FROM SalesOrders
	WHERE 
	countries IN('Nigeria','Ghana') AND
	years BETWEEN '2018' AND '2019' AND
	brands LIKE '%malt%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/*
* Session B.5 Which brands sold the highest in 2019 in Nigeria?
*/
SELECT countries,brands, to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Highest Brand-Nigeria" FROM SalesOrders
	WHERE 
	countries = 'Nigeria' AND years = '2019'
GROUP BY 2,1
ORDER BY 3 DESC
LIMIT 1

/*
* Session B.6 Favorites brand in South_South region in Nigeria
*/
SELECT countries,brands, to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Highest Brand-Nigeria SS" FROM SalesOrders
	WHERE 
	countries = 'Nigeria' AND region = 'southsouth'
GROUP BY 2,1
ORDER BY 3 DESC
LIMIT 1

/*
* Session B.7 Beer consumption in Nigeria
*/
SELECT countries,to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Beer - Nigeria" FROM SalesOrders
	WHERE 
	countries ='Nigeria'AND 
	brands NOT LIKE '%malt%'
GROUP BY 1
ORDER BY 2 DESC

/*
* Session B.8 Level of consumption of Budweiser in the regions in Nigeria
*/
SELECT countries,region,brands, to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Budweiser - Nigeria Regions" FROM SalesOrders
	WHERE 
	countries ='Nigeria' AND 
	brands = 'budweiser'
GROUP BY 1,3,2
ORDER BY 2

/*
* Session B.9 Level of consumption of Budweiser in the regions in Nigeria in 2019
*/
SELECT countries,region,brands, years, sum(Quantity) AS "Budweiser - Nigeria Regions (2019)" FROM SalesOrders
	WHERE 
	years = '2019' AND
	countries ='Nigeria' AND 
	brands = 'budweiser'
GROUP BY 4,3,2,1
ORDER BY 5 DESC

/*
* Session C.1 Country with the highest consumption of beer.
*/
SELECT countries,to_char(SUM(Quantity),'FM999,999,999,999,999,999') AS "Highest Beer Consumption - Country" FROM SalesOrders
	WHERE 
	brands NOT LIKE '%malt%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* Session C.2 Highest sales personnel of Budweiser in Senegal
*/

SELECT brands, sales_rep,  SUM(Quantity) AS "Highest Sales Rep - Senegal (Top 5)" FROM SalesOrders
	WHERE 
	countries ='Senegal' AND brands = 'budweiser'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5

/*
* Country with the highest profit of the fourth quarter in 2019
*/
SELECT countries, SUM(Profit) AS "Beer per Country - 4th QTR 2019" FROM SalesOrders
	WHERE 
	years ='2019' AND Months IN ('October','November','December')
GROUP BY 1
ORDER BY 2 DESC
