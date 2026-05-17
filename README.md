# DC Traffic Violations & Weather Analytics — Data Warehouse Project

**Tools:** MySQL · Python · ETL Pipeline · Star Schema · Data Wrangling  
**Domain:** Public Safety Analytics · Urban Data Analytics  
**Course:** Data Warehousing & Business Intelligence — University of Dayton, Spring 2025

---

## Project Overview

This project builds a fully functional data warehouse to analyze Washington D.C. moving traffic violations alongside daily weather conditions, uncovering patterns in ticketing behavior, agency performance, fine revenue, and weather-related accident trends.

The end-to-end pipeline covers data extraction, cleaning, transformation, and loading (ETL) into a structured MySQL star-schema database, followed by 8 analytical queries that answer real operational questions.

---

## Business Questions Answered

| # | Question |
|---|----------|
| a | Which agencies issue the most tickets, broken down by month? |
| b | How many tickets has each agency issued since October 2024? |
| c | What is the average number of tickets per day of the week? |
| d | How many tickets were issued during rainy weather periods? |
| e | What is the total precipitation recorded per month? |
| f | What are the total fines collected for speeding violations over 10 mph, by month? |
| g | What is the average ticket volume for each hour of the day (7 AM to 9 PM)? |
| h | Are accident-related tickets more common on rainy vs. non-rainy days? |

---

## Database Schema — Star Schema Design
 ```
                    ┌─────────────┐
                    │  DateDim    │
                    │─────────────│
                    │ dateID (PK) │
                    │ date        │
                    │ year        │
                    │ month       │
                    │ day         │
                    │ dayOfWeek   │
                    └──────┬──────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
┌─────────┴──────┐  ┌──────┴────────┐  ┌───┴──────────┐
│  AgencyDim     │  │ ViolationFact │  │  WeatherDim  │
│────────────────│  │───────────────│  │──────────────│
│ agencyID (PK)  │◄─│ violationID   │─►│ weatherID(PK)│
│ agencyCode     │  │ objectID      │  │ date         │
│ agencyName     │  │ location      │  │ temp_max/min │
│ agencyShort    │  │ issue_date    │  │ total_precip │
└────────────────┘  │ issue_time    │  │ precip_type  │
                    │ violation_code│  │ humidity_avg │
                    │ violation_desc│  │ windspeed_avg│
                    │ fine_amount   │  │ conditions   │
                    │ accident_ind  │  └──────────────┘
                    │ latitude      │
                    │ longitude     │
                    │ dateID (FK)   │
                    │ agencyID (FK) │
                    │ weatherID (FK)│
                    └───────────────┘

 ```

## ETL Pipeline Summary

### 1. Extract
- DC Moving Violations Dataset — ticket date/time, location, agency, violation type, fine amount, accident indicator, coordinates
- Daily Weather Dataset — temperature, precipitation, humidity, windspeed, visibility, UV index, conditions

### 2. Transform (Python)
- Standardized time formats (e.g., "5" to "05:00:00")
- Converted all dates to YYYY-MM-DD format
- Decomposed dates into year, month, day, day-of-week for dimensional modeling
- Normalized weather condition labels so rain, RAIN, Rain all map to the same value
- Matched every violation record to its corresponding weather record by date
- Removed rows with missing or invalid key fields

### 3. Load
- Loaded into MySQL finalproject database using a star schema
- Dimension tables store unique entities — one row per date, agency, and weather day
- Fact table links to dimensions via foreign keys to prevent redundancy
- Incremental load logic inserts only new records by date, preventing duplicates

---

## Files in This Repo
├── final_project_meghana_mudunuri.sql           # Database schema, CREATE TABLE statements
├── final_project_queries_meghana_mudunuri.sql   # 8 analytical SQL queries
├── ETL_and_Data_Wrangling_Documentation.docx    # Full ETL process write-up
└── README.md

---

## Sample Query

Accident rate on rainy vs. non-rainy days:

```sql
SELECT 
    CASE 
        WHEN w.conditions LIKE '%Rain%' OR w.precip_type LIKE '%rain%' THEN 'Rainy'
        ELSE 'Not Rainy'
    END AS WeatherType,
    SUM(CASE WHEN v.accident_indicator IN ('Y','YES') THEN 1 ELSE 0 END) AS AccidentTickets,
    COUNT(v.violationID) AS TotalTickets,
    ROUND(
      SUM(CASE WHEN v.accident_indicator IN ('Y','YES') THEN 1 ELSE 0 END) 
      / NULLIF(COUNT(v.violationID), 0) * 100, 2
    ) AS AccidentRate_Pct
FROM ViolationFact v
JOIN WeatherDim w ON v.weatherID = w.weatherID
GROUP BY WeatherType;
```

---

## Tech Stack

| Layer | Tool |
|-------|------|
| Database | MySQL |
| ETL and Cleaning | Python (Pandas, NumPy) |
| Schema Design | Star Schema — Fact and Dimension tables |
| Query Language | SQL (Joins, Aggregations, CASE, Window Functions) |
| Documentation | Microsoft Word |

---

## Author

Meghana Satya Lakshmi Mudunuri  
MS Business Analytics — University of Dayton  
meghana472003@gmail.com  
[LinkedIn](https://www.linkedin.com/in/meghana-satya-lakshmi/)
