# 📈 Stock Market Sector Analysis (India)

This project analyzes Indian stock market sector trends using a combination of Python (for data extraction) and SQL (for analytics). It leverages real-world stock data fetched from Yahoo Finance via the yfinance API, stored in structured datasets, and queried to uncover sector-wise performance, volatility, and seasonal patterns.

# 🚀 Project Overview

Data Collection: Automated extraction of historical stock prices and volumes for NIFTY 50 companies across multiple sectors using Python & yfinance.

Data Storage: Saved structured dataset into CSV and loaded into SQL for analysis.

SQL Analytics: Designed queries to evaluate sector performance across multiple dimensions:

# 📊 Average closing prices (yearly & sector-wise)

# 📉 Volatility & risk profiles

# 💹 Daily return patterns

# 📦 Trading volume trends

# 🌦️ Seasonal sector performance

# Deliverables:

finance.py → Data pipeline to fetch, clean & store data.

indian_sector_ticker_data2.csv → Structured dataset (5 years of history).

stock maket trends.sql → SQL queries for analysis.

#📂 Project Structure
├── finance.py                  # Python script for data extraction via yfinance
├── indian_sector_ticker_data2.csv  # Historical stock dataset (5 years)
├── stock maket trends.sql      # SQL scripts for trend and performance analysis
├── README.md                   # Project documentation

# 🔎 Key SQL Analyses
1️⃣ Data Quality & Coverage

Count of records per sector & ticker

Check for missing values in Close and Volume

2️⃣ Sector-wise Performance

Yearly average closing prices (2020–2024)

Price change percentage across years

Ranking sectors by long-term growth

3️⃣ Volatility & Risk

Standard deviation of stock prices to measure sector volatility

Average sector closing prices

4️⃣ Returns & Profitability

Average daily returns across sectors

Ranking sectors by profitability

5️⃣ Trading Volume Trends

Average daily trading volume per sector over years

Identifying sectors with increasing investor interest

6️⃣ Seasonal Patterns

Monthly performance trends (e.g., February seasonal closing prices)

# 🛠️ Tech Stack

Python (yfinance, pandas) → Data extraction & preprocessing

SQL → Querying & financial analytics

CSV → Data storage & portability

# 📊 Sample Insights

Financial Services & IT showed consistent growth across 2020–2024.

Metals & Mining exhibited high volatility, indicating higher investment risk.

FMCG demonstrated strong stability with steady average returns.

Trading volumes in Banking & IT sectors surged post-2021, highlighting market confidence.

# 📌 How to Run

Fetch Data (Python):

python finance.py


This will generate indian_sector_ticker_data2.csv.

Load Data into SQL:
```
CREATE TABLE sector_data (
    Date DATE,
    ticker VARCHAR(20),
    sector VARCHAR(50),
    Close FLOAT,
    Volume BIGINT
);
```
```
LOAD DATA INFILE 'indian_sector_ticker_data2.csv'
INTO TABLE sector_data
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
```

Run Queries:
Open stock maket trends.sql and execute in MySQL / PostgreSQL / any SQL environment.

# 🔮 Future Enhancements

Add Power BI / Tableau dashboards for visual insights.

Extend dataset with macroeconomic indicators (GDP, inflation, interest rates).

Build a machine learning model to predict sector returns & volatility.

# 🏆 Project Highlights

✔️ Combined Python + SQL for end-to-end financial analysis.
✔️ Real-world stock market dataset for meaningful sector insights.
✔️ Covers both risk (volatility) and return (profitability) analysis.
