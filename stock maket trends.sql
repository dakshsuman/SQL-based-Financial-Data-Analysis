SELECT 
    sector, 
    ticker, 
    COUNT(*) AS record_count, 
    MIN(Date) AS earliest_date, 
    MAX(Date) AS latest_date
FROM sector_data
GROUP BY sector, ticker
ORDER BY sector, ticker;

SELECT 
    ticker, 
    sector, 
    Date, 
    Close, 
    Volume
FROM sector_data
WHERE Close IS NULL or
 volume is null;
#no null values

    SELECT sector,
    year(Date) as year ,
    round(avg(close),2) as avg_close_price from sector_data 
    group by sector, year;
    
    WITH yearly_avg AS (
    SELECT 
        sector,
        YEAR(Date) AS year,
        AVG(Close) AS avg_close_price
    FROM sector_data
    WHERE YEAR(Date) IN (2020,2021,2022,2023, 2024)
    GROUP BY sector, YEAR(Date)
),
pivot_data AS (
    SELECT 
        sector,
        MAX(CASE WHEN year = 2020 THEN avg_close_price END) AS avg_close_2020,
        MAX(CASE WHEN year = 2021 THEN avg_close_price END) AS avg_close_2021,
		MAX(CASE WHEN year = 2022 THEN avg_close_price END) AS avg_close_2022,
		MAX(CASE WHEN year = 2023 THEN avg_close_price END) AS avg_close_2023,
        MAX(CASE WHEN year = 2024 THEN avg_close_price END) AS avg_close_2024
    FROM yearly_avg
    GROUP BY sector
)
SELECT 
    sector,
    avg_close_2020,
    avg_close_2024,
    ROUND(((avg_close_2021 - avg_close_2020) / avg_close_2020 * 100), 2) AS price_change_pct_20to21,
    ROUND(((avg_close_2022 - avg_close_2021) / avg_close_2021 * 100), 2) AS price_change_pct_21to22,
    ROUND(((avg_close_2023 - avg_close_2022) / avg_close_2022 * 100), 2) AS price_change_pct_22to23,
    ROUND(((avg_close_2024 - avg_close_2023) / avg_close_2023 * 100), 2) AS price_change_pct_23to24,
    ROUND(((avg_close_2024 - avg_close_2020) / avg_close_2020 * 100), 2) AS price_change_pct
FROM pivot_data
ORDER BY price_change_pct DESC;

#sector Volatility

select sector, 
count(distinct ticker) as num_stocks,
round( STDDEV(close),2) as price_volatility,
round(avg(close),2) as Avg_close_price
from sector_data
where date between '2020-01-01' and '20224-12-31'
group by sector
order by price_volatility;


#Average Daily Returns by Sector

WITH daily_returns AS (
    SELECT 
        ticker,
        sector,
        Date,
        ROUND((Close - LAG(Close) OVER (PARTITION BY ticker ORDER BY Date)) 
              / LAG(Close) OVER (PARTITION BY ticker ORDER BY Date) * 100, 2) AS daily_return
    FROM sector_data
    WHERE Date BETWEEN '2020-01-01' AND '2024-12-31'
)
SELECT 
    sector,
    COUNT(DISTINCT ticker) AS num_stocks,
    ROUND(AVG(daily_return), 2) AS avg_daily_return
FROM daily_returns
WHERE daily_return IS NOT NULL
GROUP BY sector
ORDER BY avg_daily_return DESC;

#Trading Volume Trends
SELECT 
    sector,
    year(Date) AS year,
    ROUND(AVG(Volume), 2) AS avg_daily_volume
FROM sector_data
WHERE Date BETWEEN '2020-01-01' AND '2024-12-31'
GROUP BY sector, year(Date)
ORDER BY sector, year;


#Seasonal Performance Patterns

Select Sector,
month(Date) as month,
round(avg(close),2) as avg_closing_price
from sector_data 
where month(Date) = "2"
group by sector, month
order by 2,1

