# 🦠 COVID-19 Data Exploration — SQL Project

## Overview

This project explores global COVID-19 data using SQL Server, analyzing infection rates, death counts, and vaccination progress across countries and continents. The goal is to extract meaningful public health insights from raw epidemiological data and prepare clean views for downstream visualization (e.g. Tableau or Power BI).

---

## Dataset

Two tables sourced from [Our World in Data](https://ourworldindata.org/covid-deaths):

| Table | Description |
|---|---|
| `CovidDeaths` | Daily records of cases, deaths, and population by location |
| `CovidVaccinations` | Daily vaccination figures by location |

---

## Skills & Concepts Demonstrated

- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY` fundamentals
- Aggregate functions: `SUM()`, `MAX()`, `CAST()`
- Window functions: `SUM() OVER (PARTITION BY ... ORDER BY ...)`
- `JOIN` across multiple tables
- Common Table Expressions (CTEs)
- Temporary tables (`#TempTable`)
- Creating database Views

---

## Analysis Breakdown

### 1. Death Rate by Country
Calculates the percentage of confirmed cases that resulted in death — showing the likelihood of dying if infected in a given country.

```sql
SELECT location, date, total_cases, total_deaths,
       (total_deaths / total_cases) * 100 AS Death_Percentage
FROM CovidDeaths
WHERE location LIKE '%states%'
```

### 2. Infection Rate vs Population
Shows what share of a country's population contracted COVID-19.

```sql
SELECT location, date, population, total_cases,
       (total_cases / population) * 100 AS PercentPopulationInfected
FROM CovidDeaths
```

### 3. Countries with Highest Infection Rate
Ranks countries by peak infection rate relative to population size.

```sql
SELECT location, population,
       MAX(total_cases) AS HighestInfectionCount,
       MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC
```

### 4. Countries with Highest Death Count
Identifies the countries with the most total deaths.

### 5. Breakdown by Continent
Aggregates death counts at the continent level.

### 6. Global Daily & Cumulative Numbers
Summarizes worldwide new cases, total deaths, and global death percentage — both per day and overall.

### 7. Rolling Vaccination Progress (Window Function)
Joins death and vaccination tables to compute a running total of people vaccinated per country over time.

```sql
SUM(CAST(vac.new_vaccinations AS INT))
  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
  AS RollingPeopleVaccinated
```

### 8. CTE — Population vs Vaccinations
Wraps the rolling vaccination query in a CTE to calculate the vaccinated percentage of the population cleanly.

### 9. Temp Table — Percent Population Vaccinated
Achieves the same result as the CTE using a temporary table, demonstrating an alternative approach for intermediate data storage.

### 10. View — Storing Data for Visualization
Creates a reusable view `PercentPopulationVaccinated` to persist the rolling vaccination query for use in dashboarding tools.

---

## How to Run

1. Import the `CovidDeaths` and `CovidVaccinations` datasets into SQL Server under a database named `PortfolioProject`
2. Run the queries in order from top to bottom in SQL Server Management Studio (SSMS)
3. The final `CREATE VIEW` statement can be used as a data source in Tableau or Power BI

---

## Key Insights

- Death percentage and infection rates varied significantly by country and over time
- Continent-level aggregation reveals regional disparities in outbreak severity
- Rolling vaccination data highlights the pace of immunization relative to population size

---

## Author

**Natnael Amenu** — Data Analyst  
[LinkedIn](#) · [GitHub](#) · [Portfolio](#)
