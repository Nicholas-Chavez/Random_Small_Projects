-- Data: The data being used is Covid Data collected by Johns Hopkins University
-- Johns Hopkins University stopped collecting covid data as of 03/10/2023

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE new_cases is not null and total_deaths is not null
ORDER BY 3,4;

-- Looking at total cases vs. total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathCaseRatio
FROM PortfolioProject..Countries as cou
JOIN PortfolioProject..CovidDeaths as covid
ON cou.Country = covid.location
WHERE total_cases is not null and total_deaths is not null and location like '%states%'
ORDER BY DeathCaseRatio desc

-- Looking at countries with the highest infection rate

SELECT location, population, MAX(total_cases) as Infections, 
MAX((total_cases/population))*100 as InfectionRate
FROM PortfolioProject..CovidDeaths as covid
join PortfolioProject..Countries as cou
ON covid.location = cou.Country
WHERE total_cases is not null and population is not null
GROUP BY location, population
ORDER BY 4 DESC;

-- Showing the countries with the highest death count per population

SELECT location, population, MAX(CAST(total_deaths as int)) as TotalDeathCount, 
MAX((total_deaths/population)) as DeathPercentage
FROM PortfolioProject..CovidDeaths as Covid
JOIN PortfolioProject..Countries as Cou
ON Covid.location = Cou.Country
WHERE total_deaths is not null and total_cases is not null
GROUP BY location, population
ORDER BY TotalDeathCount DESC

-- Lets separate by continent

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths as Covid
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Looking at the total percentage of the population affected

WITH CTE_Cases AS
(
SELECT location, population, MAX(total_cases) as HeighestNumberOfCases, 
MAX((total_cases/population))*100 as HeighestPercentageOfCases
FROM PortfolioProject.dbo.Countries as coun
JOIN PortfolioProject.dbo.CovidDeaths as death
ON coun.Country = death.location
WHERE total_cases is not null and population is not null
GROUP BY location, population
)
SELECT SUM(population) as World_Population, SUM(HeighestNumberOFCases) as World_Heighest_Total_Cases,
(SUM(HeighestNumberOFCases)/SUM(population))*100 as Population_effected
FROM CTE_Cases

-- Global Death-to-case ratio

SELECT date, SUM(CAST(new_cases as int)) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathRate
FROM PortfolioProject..CovidDeaths
WHERE new_cases is not null and new_deaths is not null and new_cases <> 0
GROUP BY date
ORDER BY DeathRate

-- Looking at total population vs. vaccination

WITH CTE_PerodicVac (continent, location, date, population, new_vaccinations, PeriodicTotalVaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as PeriodicTotalVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	and dea.date = vac.date
WHERE new_vaccinations is not null and dea.continent is not null
)
SELECT *,
ROUND((PeriodicTotalVaccinations/population)*100, 3) as PeriodicPercentageOfPopulation
FROM CTE_PerodicVac

-- Alternative Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
new_vaccinations numeric,
PeriodicTotalVaccinations numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as PeriodicTotalVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	and dea.date = vac.date
WHERE new_vaccinations is not null and dea.continent is not null

SELECT *,
ROUND((PeriodicTotalVaccinations/Population)*100,3) as PeriodicPercentageOfPopulation
FROM #PercentPopulationVaccinated

-- Creating a View to store data for later visualizations

-- VIEW 1

CREATE View PeriodicVaccinations
AS
WITH CTE_PerodicVac (continent, location, date, population, new_vaccinations, PeriodicTotalVaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as PeriodicTotalVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	and dea.date = vac.date
WHERE new_vaccinations is not null and dea.continent is not null
)
SELECT *,
ROUND((PeriodicTotalVaccinations/population)*100, 3) as PeriodicPercentageOfPopulation
FROM CTE_PerodicVac

-- VIEW 2

CREATE VIEW World_Stats AS
WITH CTE_Cases AS
(
SELECT location, population, MAX(total_cases) as HeighestNumberOfCases, 
MAX((total_cases/population))*100 as HeighestPercentageOfCases
FROM PortfolioProject.dbo.Countries as coun
JOIN PortfolioProject.dbo.CovidDeaths as death
ON coun.Country = death.location
WHERE total_cases is not null and population is not null
GROUP BY location, population
)
SELECT SUM(population) as World_Population, SUM(HeighestNumberOFCases) as World_Heighest_Total_Cases,
(SUM(HeighestNumberOFCases)/SUM(population))*100 as Population_effected
FROM CTE_Cases

-- VIEW 3

CREATE View CovidDeathStats as
SELECT location, population, MAX(CAST(total_deaths as int)) as TotalDeathCount, 
MAX((total_deaths/population)) as DeathPercentage
FROM PortfolioProject..CovidDeaths as Covid
JOIN PortfolioProject..Countries as Cou
ON Covid.location = Cou.Country
WHERE total_deaths is not null and total_cases is not null
GROUP BY location, population

SELECT * FROM CovidDeathStats
