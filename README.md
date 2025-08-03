# Netflix Data Cleaning & Analysis Project (End-to-End ELT)

## Overview
This project demonstrates a complete ELT (Extract → Load → Transform) pipeline using Python and SQL. We work with a Netflix dataset, clean and model the data, load it into a SQL database, and run analytical queries to uncover business insights.

## Motivation
- Practice building a real-world data engineering pipeline
- Use SQL and Python to clean and analyze a public dataset
- Create a portfolio-ready project showing structured thinking and technical implementation

## Dataset
- **Source**: Netflix Titles Dataset (e.g. from Kaggle)
- **Content**: Information about TV shows and movies available on Netflix including title, cast, genre, release year, country, duration, and more

##� Architecture & Workflow

### 1. Extract
- Download the dataset using the Kaggle API
- Store raw CSVs in the `data/raw/` folder

### 2. Load
- Load raw data into a SQL database (PostgreSQL, SQL Server, etc.)
- Create a raw staging table

### 3. Transform
- Clean the data using SQL:
  - Handle nulls and missing values
  - Standardize genres and duration formats
- Create a dimensional model:
  - 1 fact table and multiple dimension tables

### 4. Analyze
- Use SQL to answer business questions like:
  - What genres are most released each year?
  - What's the average movie duration over time?
  - Which countries produce the most content?


## Tech Stack
- Python (for extraction and automation)
- Pandas (for preprocessing)
- SQL (for transformations and analysis)
- PostgreSQL / SQL Server (for data storage)
- Kaggle API (for dataset download)

## Setup Instructions

### Prerequisites
- Python 3.x
- PostgreSQL or another SQL database installed
- Kaggle API credentials set up

### Environment Setup
```bash
pip install -r requirements.txt
```

### Run ETL
```bash
python scripts/download_data.py       # Download dataset from Kaggle
python scripts/load_to_sql.py         # Load raw CSV into SQL database
```

### Run SQL Scripts
Execute these SQL scripts in order:
1. `raw_load.sql`
2. `cleaning.sql`
3. `modeling.sql`
4. `analytical_queries.sql`

## Key Analytical Questions
- What genres are most frequently released per year?
- What is the distribution of movie durations?
- Which countries contribute the most to Netflix's catalog?
- What is the trend of new titles being added over time?

## Insights
- The number of Netflix titles has grown significantly post-2016
- TV Shows have a higher proportion of PG-rated content
- U.S., India, and the U.K. dominate Netflix’s content library

## Improvements & Future Work
- Automate pipeline with Apache Airflow
- Move to cloud data warehouse (e.g. Snowflake)
- Build interactive dashboards with Power BI or Streamlit
- Add data validation and testing with dbt or Great Expectations

## License
This project is open-sourced under the MIT License.

## Acknowledgments
- Inspired by [Netflix Data ELT Project](https://www.youtube.com/watch?v=ZnQwO6V7pec) on YouTube
- Thanks to the contributors and maintainers of the Kaggle Netflix dataset

---

*Created with ❤️ by Bryan Cha*
