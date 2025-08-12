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
```
   # Save to CSV for reference
all_sector_data.to_csv("indian_sector_ticker_data2.csv", index=False)
print(all_sector_data.head())

```    ```sql```
