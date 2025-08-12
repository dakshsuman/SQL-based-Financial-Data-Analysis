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