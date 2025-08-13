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

<img width="1920" height="967" alt="Yearly close price" src="https://github.com/user-attachments/assets/9e1c9cba-9ce3-48b7-8e34-5cafcc21801d" />


• Analyzed sector-wise performance trends over the 5-year period, identifying high-growth sectors based on average closing price growth.


## year-over-year  closing prices 2020 to 2024.
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
<img width="1920" height="967" alt="%change by year" src="https://github.com/user-attachments/assets/dcca90e4-bc6a-4750-88e4-f7e78e8b25c4" />


• High-Growth Sectors: Consumer Services (+712.7%), Capital Goods (+722.71%), and Metals & Mining (+437.44%) lead with exceptional returns, driven by significant year-over-year gains, especially in 2023-24.


• Underperforming Sectors: FMCG (+51.34%) and Financial Services (+68.64%) show the slowest growth, suggesting stability but limited potential for aggressive gains.


## Measures price volatility
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
<img width="1920" height="967" alt="Price volatility by sector" src="https://github.com/user-attachments/assets/ec1f0f78-c590-4cd9-aa83-a6fa998207f9" />


• High-Volatility Sectors: Automobile & Auto Components (1495), Construction / Construction Materials (2338.93), and Healthcare (949) show the greatest price fluctuations, offering high-risk opportunities.


• Low-Volatility Sectors: Power (22.96), Capital Goods (22.96), and Telecommunication (26.28) provide stability, suitable for risk-averse investors.

## Calculating the average daily return for each sector
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

<img width="1920" height="967" alt="avg daily" src="https://github.com/user-attachments/assets/fc40f482-67d3-4908-80f4-644d0262934c" />

• High-Return Sectors: Consumer Services (+0.26%), Capital Goods (+0.22%), and Metals & Mining (+0.18%) lead in daily returns, offering the best short-term growth prospects.


• Lower-Return Sectors: FMCG (+0.06%), Information Technology and Financial Services (+0.09%) show the weakest daily returns, indicating stability but limited upside.

## Tracks the average daily trading volume per sector
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
<img width="1920" height="967" alt="daily avg" src="https://github.com/user-attachments/assets/986063d7-44f4-4b6d-8318-4b234d7bc78e" />

• High-Volume Sectors: Financial Services (213073.31 in 2021), Metals & Mining (2240867.49 in 2022), and Power (1742318.61 in 2024) show the highest average daily volumes, reflecting strong liquidity and investor engagement.


• Low-Volume Sectors: Power in 2020 and 2021, Consumer Durables (92437.20 in 2023), and Capital Goods (260.49 in 2024) indicate lower activity, suggesting stability or reduced interest.

## Analyzes the average closing price for each sector by month
```sql
#Seasonal Performance Patterns
Select Sector,
month(Date) as month,
round(avg(close),2) as avg_closing_price
from sector_data 
group by sector, month
order by 1,2;
```
<img width="1920" height="967" alt="avg monthly closing price" src="https://github.com/user-attachments/assets/fc0c2a4d-dbcc-4cce-80b5-c021d2236f84" />

• High-Performing Months: Consumer Services (November, 2432.3), Metals & Mining (February, 897.68), and Healthcare (November, 2287.41) show the highest average closing prices, indicating optimal investment months.


• Low-Performing Months: Power (December, 184.83), Consumer Durables (December, 2625.09), and FMCG (January, 1123.78) have the lowest prices, suggesting caution during these periods.







# Sector Performance Summary (2020-2024)
Top performers in total price change: Consumer Services (+720%), Capital Goods (+710%), Metals & Mining (+430%). 

These sectors showed strong growth amid recovery from COVID, infrastructure push, and commodity cycles. Laggards: Construction Materials (+40%), FMCG (+50%).

High daily returns: Consumer Services (0.25%), Capital Goods (0.22%). Low returns: FMCG (0.05%).

Volatility leaders (risky): Construction Materials (2389 INR std dev), FMCG (1495). Stable: Consumer Services/Capital Goods (23).

Volume trends: Declining overall; Automobile highest in 2020 but dropped sharply by 2024, signaling reduced liquidity in cyclicals.

# 2025 Outlook & Opportunities

India's market poised for 8-18% returns (Nifty target 25,000-27,500), driven by 6.5-7% GDP growth, RBI rate cuts, and reforms. Risks: US tariffs, FII outflows, inflation. Bullish sectors: IT (AI/cloud, 8-15% CAGR), Renewables/EVs (18-25% CAGR, green push), Pharma/Healthcare (10-12% CAGR, exports), Infrastructure (10-15% CAGR, capex), Banking/Fintech (12-15% CAGR, digital). Avoid: Autos (margin pressure), Commodities (tariffs).

Top stocks: TCS/Infosys (IT), Tata Power/Adani Green (Renewables), Sun Pharma (Pharma), L&T (Infra), ICICI Bank (Banking).

# Portfolio Rebalancing Advice

Overweight: Capital Goods (high return/low vol), Renewables (policy tailwinds), IT/Pharma (resilient).

Underweight: Construction (high vol/low growth), FMCG (stagnant), Oil/Gas (cyclical risks).

Allocate 40% large-caps for stability, 30% mid-caps for growth, 30% small-caps for upside. Rebalance quarterly; buy dips in outperformers. Diversify across 3-5 sectors to manage volatility.
