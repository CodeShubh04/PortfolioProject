select * from PortfolioProject..CovidDeaths where continent is not null order by 3,4

--select * from PortfolioProject..CovidVaccinations order by 3,4

select location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths order by 1,2 

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from PortfolioProject..CovidDeaths where location='India' order by 1,2 

select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage from PortfolioProject..CovidDeaths where location='India' order by 1,2 

select location,  MAX(total_cases) as HighestInfectionCount, population, MAX(total_cases/population)*100 as PopulationInfectedPercentage 
from PortfolioProject..CovidDeaths group by location, population order by PopulationInfectedPercentage desc 

select location,  MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths where continent is not null group by location order by TotalDeathCount desc 

-- Based on Continent
select location,  MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths where continent is null group by location order by TotalDeathCount desc 

select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths where continent is not null group by continent order by TotalDeathCount desc 

select date, SUM(new_cases) as Cases, SUM(cast(new_deaths as int)) as Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths where continent is not null group by date order by 1,2 

select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths where continent is not null order by 1,2 

select * from PortfolioProject..CovidVaccinations

select * from PortfolioProject..CovidDeaths dea JOIN PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date 

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations from PortfolioProject..CovidDeaths dea 
JOIN PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date where dea.continent is not null order by 1,2,3

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) from PortfolioProject..CovidDeaths dea 
JOIN PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date where dea.continent is not null order by 2,3

--CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinted) as
(select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
from PortfolioProject..CovidDeaths dea JOIN PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date where dea.continent is not null)
select *, (RollingPeopleVaccinted/population)*100 from PopvsVac

--TEMP Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated(
continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric)
insert into #PercentPopulationVaccinated select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac On dea.location = vac.location	and dea.date = vac.date
Select *, (RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated From PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac On dea.location = vac.location and dea.date = vac.date where dea.continent is not null 

select * from PercentPopulationVaccinated