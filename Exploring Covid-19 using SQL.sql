select * 
from PortfolioProject..Covid_Deaths
order by 3,4

select * 
from PortfolioProject..Covid_Vaccinations
order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..Covid_Deaths
order by 1,2


--Looking at deaths vs total cases
--Shows the likelihood of dying from contracting covid in ones country

select location, date, total_cases, total_deaths, 
(total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject..Covid_Deaths
where location like '%states%'
order by 1,2


--Looking at total cases vs the population
--Shows what percentage of the population contracted covid

select location, date, total_cases, population, 
(total_cases/population) * 100 as PercentOfPopulutionInfected
from PortfolioProject..Covid_Deaths
where location like '%states%' and continent is not null
order by 1,2


--Looking at the countries with highest infection rate compared to population

select location, population, Max(total_cases) as HighestInfectionCount, 
MaX(total_cases/population) * 100 as PercentOfPopulutionInfected
from PortfolioProject..Covid_Deaths
Group by location, population
order by 1,2


--Showing countries with the highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..Covid_Deaths
--where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc


--Looking at total death count by continent

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..Covid_Deaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--Global numbers by date

select date, SUM(new_cases) as TotalNewCases, 
SUM(cast(new_deaths as int)) as TotalNewDeathCount,
SUM(cast( new_deaths as int))/ SUM(new_cases) * 100 as TotalNewDeaths
from PortfolioProject..Covid_Deaths
--where location like '%states%'
where continent is not null
Group by date
order by 1,2


--Looking at the total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null
order by 2,3


--Use CTE

With PopvsVac (Continent, Location,  Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population) * 100
from PopvsVac



--Using temp table

Drop Table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(
continent nvarchar (255),
location nvarchar (255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population) * 100
from #PercentPeopleVaccinated



--Creating views for later visualizations


CREATE VIEW PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from PortfolioProject..Covid_Deaths dea
join PortfolioProject..Covid_Vaccinations vac
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null

select * 
from percentpopulationvaccinated



Create View InfectionCountPerCountry AS
select location, population, Max(total_cases) as HighestInfectionCount, 
MaX(total_cases/population) * 100 as PercentOfPopulutionInfected
from PortfolioProject..Covid_Deaths
Group by location, population

select * 
from InfectionCountPerCountry





