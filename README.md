# SQL-based-Financial-Data-Analysis
## Overview
This project leverages SQL to analyze large stock market datasets, providing insights for investment decision-making and portfolio management. It includes SQL scripts for extracting, filtering, and aggregating financial data to identify trends and generate actionable reports.

## Features

•	Data Collection through yfinance ( Python)

•	Data Extraction & Filtering: SQL queries to process and clean large stock market datasets.

•	Sector-wise Analysis: Evaluates performance trends across sectors over a 5-year period, highlighting high-growth and underperforming sectors.

•	Summary Reports: Generates reports to support investment decisions and portfolio rebalancing.

•	Scalability: Optimized for efficient processing of large datasets in relational databases.

## Methodology

SQL queries executed on 'sector_data' table (loaded from CSV). Key queries include:

•	Data summary (record counts, date ranges per sector/ticker).

•	Null checks (no nulls in Close/Volume).

•	Yearly average close prices and percentage changes (2020-2024).

•	Sector volatility (std.dev of close prices).

•	Average daily returns.

•	Trading volume trends by year.

•	Seasonal patterns (e.g., monthly average close prices).

## Data Collection
The dataset was compiled by retrieving historical financial data for 40+ Indian stock market tickers across 14 sectors, including Information Technology (e.g., INFY.NS, TCS.NS), Financial Services (e.g., HDFCBANK.NS, ICICIBANK.NS), and Metals & Mining (e.g., TATASTEEL.NS), covering the period from January 1, 2020, to December 31, 2024. Data was sourced using the yfinance Python library, which provides access to Yahoo Finance API endpoints for daily closing prices (Close) and trading volumes (Volume). The process involved:

•	Defining a sector-ticker mapping with tickers such as ADANIENT.NS, HINDALCO.NS, and others specified for the project.

•	Fetching 5-year historical data (period="5y") for each ticker using a Python script, 

•	Handling potential errors (e.g., invalid tickers) with try-except blocks to ensure robust data retrieval.


•	Storing the collected data, including Date, ticker, sector, Close, and Volume, in a MySQL database named sector_performance via the Excel to sql method.


```python
import yfinance as yf
import pandas as pd
import time
   # Sector-ticker mapping
sector_tickers = {
       "Metals & Mining": ["ADANIENT.NS", "HINDALCO.NS", "JSWSTEEL.NS", "TATASTEEL.NS"],
       "Services": ["ADANIPORTS.NS"],
       "Healthcare": ["APOLLOHOSP.NS", "CIPLA.NS", "SUNPHARMA.NS"],
       "Consumer Durables": ["TITAN.NS"],
       "Financial Services": ["AXISBANK.NS", "BAJFINANCE.NS", "BAJAJFINSV.NS", "HDFCBANK.NS",
                               "HDFCLIFE.NS", "ICICIBANK.NS", "INDUSINDBK.NS", "JIOFIN.NS", "KOTAKBANK.NS", "SBILIFE.NS", "SBIN.NS", "SHRIRAMFIN.NS"],
       "Telecommunication": ["BHARTIARTL.NS"],
       "FMCG": ["HINDUNILVR.NS", "ITC.NS", "NESTLEIND.NS", "TATACONSUM.NS"],
       "Automobile & Auto Components": ["BAJAJ-AUTO.NS", "EICHERMOT.NS", "HEROMOTOCO.NS", "M&M.NS", "MARUTI.NS", "TATAMOTORS.NS"],
       "Capital Goods": ["BEL.NS"],
       "Oil, Gas & Consumable Fuels": ["COALINDIA.NS", "ONGC.NS", "RELIANCE.NS"],
       "Construction / Construction Materials": ["GRASIM.NS", "LT.NS", "ULTRACEMCO.NS"],
       "Information Technology": ["HCLTECH.NS", "INFY.NS", "TCS.NS", "TECHM.NS", "WIPRO.NS"],
       "Power": ["NTPC.NS", "POWERGRID.NS"],
       "Consumer Services": ["ETERNAL.NS", "TRENT.NS"]
   }
   # Fetch historical data
sector_data = []
for sector, tickers in sector_tickers.items():
       for ticker in tickers:
           try:
               stock = yf.Ticker(ticker)
               hist = stock.history(period="5y")[["Close", "Volume"]]
               hist = hist.reset_index()
               hist["ticker"] = ticker
               hist["sector"] = sector
               sector_data.append(hist)
               time.sleep(0.5)  # Avoid rate limiting
           except Exception as e:
               print(f"Error fetching data for {ticker}: {e}")
   # Combine into a single DataFrame
all_sector_data = pd.concat(sector_data, ignore_index=True)
all_sector_data = all_sector_data[["Date", "ticker", "sector", "Close", "Volume"]]

   # Save to CSV for reference
all_sector_data.to_csv("indian_sector_ticker_data2.csv", index=False)
print(all_sector_data.head()) 
```


## Yearly Average Close Prices by Sector
 ```sql
  SELECT sector,
    year(Date) as year ,
    round(avg(close),2) as avg_close_price from sector_data 
    group by sector, year;
 ```
Analyzed sector-wise performance trends over the 5-year period, identifying high-growth sectors (e.g., Consumer Services with +713%, Capital Goods with +1037%, Metals & Mining with +378%) and underperforming sectors (e.g., FMCG with +43%, Oil, Gas & Consumable Fuels with +80%) based on average closing price growth.

## Computes year-over-year percentage changes in average closing prices and the overall change from 2020 to 2024 to identify high-growth and underperforming sectors.
```sql
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
```

High-Growth Sectors: Consumer Services (+712.7%), Capital Goods (+722.71%), and Metals & Mining (+437.44%) lead with exceptional returns, driven by significant year-over-year gains, especially in 2023-24.

Underperforming Sectors: FMCG (+51.34%) and Financial Services (+68.64%) show the slowest growth, suggesting stability but limited potential for aggressive gains.

```sql
# Volatility
select sector, 
count(distinct ticker) as num_stocks,
round( STDDEV(close),2) as price_volatility,
round(avg(close),2) as Avg_close_price
from sector_data
where date between '2020-01-01' and '20224-12-31'
group by sector
order by price_volatility;

```
```sql
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
```
```sql

#Trading Volume Trends
SELECT 
    sector,
    year(Date) AS year,
    ROUND(AVG(Volume), 2) AS avg_daily_volume
FROM sector_data
WHERE Date BETWEEN '2020-01-01' AND '2024-12-31'
GROUP BY sector, year(Date)
ORDER BY sector, year;
```

```sql
#Seasonal Performance Patterns
Select Sector,
month(Date) as month,
round(avg(close),2) as avg_closing_price
from sector_data 
where month(Date) = "2"
group by sector, month
order by 2,1
```













