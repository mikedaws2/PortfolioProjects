SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 3, 4


--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3, 4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE '%States%'
ORDER BY 1, 2

--Looking at Total Cases vs Population in country
--Shows what percentage of population got Covid
SELECT Location, date, population, total_cases, (total_cases/population)*100 AS Case_Percentage
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE '%States%'
ORDER BY 1, 2


--Looking at Countries with highest infection rate compared to Population
SELECT Location, population, MAX(total_cases) as Highest_infection_count, Max(total_cases/population)*100 AS Case_Percentage
FROM PortfolioProject..CovidDeaths
Group by Location, Population
ORDER BY Case_Percentage DESC

--Showing Countries with highest death count per population
SELECT Location, MAX(cast(Total_deaths as int)) AS Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
Group by Location
ORDER BY Total_Death_Count DESC

-- Showing continents with the highest death count per population
SELECT continent, MAX(cast(Total_deaths as int)) AS Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
Group by continent
ORDER BY Total_Death_Count DESC


--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) 
as Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is NOT NULL
ORDER BY 2, 3

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) 
as Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is NOT NULL
--ORDER BY 2, 3
)
Select *, (Rolling_People_Vaccinated/Population) * 100
FROM PopvsVac

-- Temp Table

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (Rolling_People_Vaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (Rolling_People_Vaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations 

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
