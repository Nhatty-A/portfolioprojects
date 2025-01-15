
Select *
From PortofolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From PortofolioProject..CovidVaccination
--order by 3,4

--- Select Data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths,population
From PortofolioProject..CovidDeaths
where continent is not null
Order by 1,2


-- Looking at the Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your coutry

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)* 100 As Death_Percentage
From PortofolioProject..CovidDeaths
Where location like '%states%'
and  continent is not null
Order by 1,2


-- Looking at the total_cases vs population
-- shows what percentage of population get covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentpopulationInfected
From PortofolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2


-- Looking at countries with highest infection rate compared to population

Select location, population, Max( total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentpopulationInfected
From PortofolioProject..CovidDeaths
-- Where location like '%states%'
Group by location, population
Order by PercentpopulationInfected desc

-- showing countries with highest death count per population

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
-- Where location like '%states%'
where continent is not null
Group by location
Order by TotalDeathCount desc  


-- Lets Break this by continents
-- showing continents with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc


--- Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
Order by 1,2


--- lokking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPoppleVaccinated,
---(RollingPoppleVaccinated/population)*100
From PortofolioProject..CovidDeaths  dea
Join PortofolioProject..CovidVaccinations  vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 2,3


-- USe CTE

With PopvsVac (continent, location, date, population,New_vaccinations, RollomgpeoppleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPoppleVaccinated
---(RollingPoppleVaccinated/population)*100
From PortofolioProject..CovidDeaths  dea
Join PortofolioProject..CovidVaccinations  vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
---order by 2,3
)
Select *, (RollomgpeoppleVaccinated/population)*100
From PopvsVac



--- TEMP TABLE
 DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Dtae datetime,
Population numeric, 
New_vaccinations numeric,
RollingPoppleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPoppleVaccinated
---(RollingPoppleVaccinated/population)*100
From PortofolioProject..CovidDeaths  dea
Join PortofolioProject..CovidVaccinations  vac
On dea.location = vac.location
and dea.date = vac.date
-- Where dea.continent is not null
---order by 2,3

Select *, (RollingPoppleVaccinated/population)*100
From #PercentPopulationVaccinated





--- Creating view to store data for visualizations

Create View PercentPopulationVaccinatedd as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPoppleVaccinated
---(RollingPoppleVaccinated/population)*100
From PortofolioProject..CovidDeaths  dea
Join PortofolioProject..CovidVaccinations  vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
---order by 2,3



select * 
from PercentPopulationVaccinated