Go
Create View DeathRatio
as
Select SUM(new_cases) as total_case ,
SUM(new_deaths) as total_death ,
(SUM(new_deaths)/NULLIF(SUM(new_cases),0)*100) As DeathPercentage
From Portfolio..CovidDeaths
Where continent is not null  

Go

Go

Create View HighestDeathRatio
as 
Select location,
population,
date,
MAX(new_cases) as HighestInfected,
MAX((total_cases/population)) as PercentPopulationInfected
From Portfolio..CovidDeaths
Group by location ,population,date

Go

Go
Create view HighestDeathByDate
as
Select location,
population,
MAX(new_cases) as HighestInfected,
MAX((total_cases/population)) as PercentPopulationInfected
From Portfolio..CovidDeaths
Group by location ,population

Go

GO
--Showing countries with highest death count per population 
Create View HighestDeathByPopulation
As
 SELECT location,population , MAX(total_deaths) AS HighestDeaths 
 FROM Portfolio..CovidDeaths
 WHERE continent is not null
 GROUP BY location ,population

GO

GO
--Showing highest death counts by continetns
Create View HighestDeathsByContinents
As
 SELECT continent , MAX(total_deaths) AS HighestDeaths
 FROM Portfolio..CovidDeaths
 WHERE continent is not null 
 GROUP BY continent

GO

GO
--Join two tables and looking at total population vs new vaccination 
Create View NewVaccinationsPopulation
As
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
 FROM Portfolio..CovidDeaths dea
 JOIN Portfolio..CovidVaccinations vac
   ON dea.location = vac.location
   AND dea.date = vac.date
   WHERE dea.continent is not null 
   AND vac.new_vaccinations is not null
   
GO

GO
 --Create view #percentpopulationvaccinated
 CREATE VIEW populationvaccinated
 as 
SELECT 
 dea.location,
 dea.continent, 
 dea.date, 
 dea.population,
 vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations AS BIGINT)) 
   OVER (PARTITION BY dea.location ORDER BY dea.date,dea.location) AS vaccinatedpeople
 FROM 
  Portfolio..CovidDeaths dea 
 JOIN 
  Portfolio..CovidVaccinations vac 
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE 
  vac.new_vaccinations is not null
  AND dea.continent is not null
GO

Select * from HighestDeathRatio