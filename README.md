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


