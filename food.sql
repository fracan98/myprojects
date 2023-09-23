/* Food waste is a serious issue that characterizes more developed countries. 
From the data available, 1/3 of food is annually thrown away and wasted,
 while a significant portion of the global population still suffers from hunger.

Thanks to the dataset from the Food and Agriculture Organization, 
we aim to understand which countries waste the most, which ones are the most virtuous,
 and which types of food are wasted the most. */


-- Selection of all the columns to see if the dataset was imported correctly
SELECT *
FROM food

/* For every country in the dataset, 
the percentage of food loss is reported. 
To identify the countries that waste the most, 
I calculated the mean percentage of food loss for each 
country based on the data available in the dataset. 
It's important to note that while one country may 
waste a significant amount of one type of food, 
it may not waste as much of others */

SELECT  country ,AVG(loss_percentage) AS AVG_loss_percentage
FROM food
GROUP BY country
ORDER BY AVG_loss_percentage DESC
LIMIT 10;

/* Haiti is the country that wastes the highest percentage, 
followed by Australia and New Zealand. 
What's interesting is that among the top 10 countries, 
there is Africa with a 30% loss percentage, including two African countries,
Gabon and Algeria. It's worth noting that three Caribbean 
countries are also in the top ranks.
However, it's important to mention that the number of times 
these countries are reported in the database varies. 
For example, Haiti is only reported five times for the same commodity, 
Mango. Therefore, this measure may not be very reliable.
As a result, I have decided to focus only on the countries 
that have been reported more than 15 times over the 21-year period*/

SELECT  country ,AVG(loss_percentage) AS AVG_loss_percentage
FROM food
GROUP BY country
HAVING COUNT(country)>15
ORDER BY AVG_loss_percentage DESC
LIMIT 10;

/* So, Peru is leading with an average loss percentage of 21%. America ranks ninth, but it's crucial to consider the significant impact of its 11.6% 
loss on a global scale. */

/* TOP 5 country for wasting food per year */
WITH Avg_consume AS (
SELECT year,country, AVG(loss_percentage) AS avg_loss
FROM food
	GROUP BY year,country
),

Rank_Nation AS (
    SELECT year,country,avg_loss,
	ROW_NUMBER() OVER(
	PARTITION BY year
	ORDER BY avg_loss DESC) AS Rank1
FROM Avg_consume

)
SELECT R.year,R.avg_loss,R.country
FROM Rank_Nation AS R
WHERE Rank1<=5


/*Now, we need to consider the most environmentally responsible countries, 
those that waste the least in terms of percentage */
SELECT  country ,AVG(loss_percentage) AS AVG_loss_percentage
FROM food
GROUP BY country
HAVING COUNT(country)>15
ORDER BY AVG_loss_percentage ASC
LIMIT 10;

/* Latvia is at the top, followed by the UK and Serbia. It's worth mentioning that
4 out of the top 10 countries are in the European Union */


/* TOP 5 country for wasting food from
2020 to 2021 */

SELECT year,country,AVG(loss_percentage) AS avg_loss
FROM food
WHERE year >2019 
GROUP BY country,year
ORDER BY avg_loss DESC
LIMIT 5

-- America's situation.
SELECT commodity, country, MAX(loss_percentage) AS max_loss_percentage
FROM food
WHERE country = 'United States of America'
GROUP BY commodity,country
ORDER BY max_loss_percentage DESC


-- Average by country of each type of wasted food (top10)

SELECT commodity,AVG(loss_percentage) AS mean_loss_percentage
FROM food
GROUP BY commodity
ORDER BY mean_loss_percentage DESC
LIMIT 10

/* As we can observe from the data, snails are the most wasted food item 
with a mean loss percentage of 50%. 
In the top 10, we can also identify 
various types of juices, as well as pig and sheep meat.*/

-- The 10 less wasted

SELECT commodity,AVG(loss_percentage) AS mean_loss_percentage
FROM food
GROUP BY commodity
ORDER BY mean_loss_percentage ASC
LIMIT 10

-- The max loss percentage of a single food

SELECT country, commodity,MAX(loss_percentage) AS max_loss_percentage
FROM food
GROUP BY country,commodity
ORDER BY max_loss_percentage DESC
LIMIT 5

/* As we can see from the data vegetables and fruits have
the highest probability to get wasted. The highs can reach
65% of the production*/

/* Return the country that waste for a single food more than 50% of that. 
USA appears several times */

SELECT 
  CASE 
    WHEN loss_percentage > 50 THEN country
    ELSE NULL
  END AS country_name
FROM 
  food
WHERE
  loss_percentage > 50
ORDER BY 
  loss_percentage DESC;


-- Where does the major waste occur in the supply chain?

SELECT activity,MAX (loss_percentage) AS max_loss_percentage
FROM food
GROUP BY activity
ORDER BY max_loss_percentage DESC
LIMIT 4


-- Years where the average waste of food are greater

SELECT year, AVG(loss_percentage) AS mean_loss_percentage
FROM food
GROUP BY year
ORDER BY mean_loss_percentage DESC

-- I see if the number of measurements is similar or not

SELECT COUNT(m49_code) AS Count_ , year
FROM food
GROUP BY year
ORDER BY Count_

/*With the exception of 2021 where the values are high 
as there are only 26 measurements, the waste values are
between 4 and 5%, except for 2020 where the pandemic has 
affected consumption. */

--TOP 10 MOST WASTED FOOD in %

SELECT commodity, MAX (loss_percentage) AS max_loss_percentage
FROM food
GROUP BY commodity
ORDER BY max_loss_percentage DESC
LIMIT 10

/* Most of the commodities that are wasted the most are fruits and vegetables. 
This makes sense because they generally have a shorter shelf life */

--TOP 10 LESS WASTED FOOD in %

SELECT commodity, MAX (loss_percentage) AS max_loss_percentage
FROM food
GROUP BY commodity
ORDER BY max_loss_percentage ASC
LIMIT 10

/* It includes goat's meat, but also fruit like rasberries
and currants. */


--MAJOR CAUSE OF LOSS OF FOOD
/*The count is the best way to understand the most 
common cause of waste because it allows us to count 
the number of occurrences of each individual cause. 
However, in the "cause_of_loss" column, it's worth noting 
that there are many null values. */

SELECT cause_of_loss, COUNT(*) AS Conteggio
FROM food
WHERE LENGTH(cause_of_loss) >1 -- so it avoids counting nulls and blanks
GROUP BY cause_of_loss
ORDER BY Conteggio DESC
LIMIT 5

/*At the top, we have physical losses,
while other issues include damage caused by insects, 
as well as mismatches in supply and demand.
Number 5 on the list is decay.*/


