SELECT *
FROM CovidDeath
ORDER BY 3,4


--SELECT *
--FROM CovidVacc
--ORDER BY 3,4


-- Select the data to be used

SELECT LOCATION, date, total_cases, new_cases, total_deaths, population
FROM CovidDeath
ORDER BY 1,2

--Looking at Total Cases vs Death

SELECT LOCATION, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercDeath
FROM CovidDeath
WHERE location = 'Nigeria'
ORDER BY 1,2


ALTER TABLE covidDeath
ALTER COLUMN total_deaths int

-- Total Cases Against Population
SELECT LOCATION, date, total_cases, population,(total_cases/population)*100 as PercDeat
FROM CovidDeath

WHERE location = 'Nigeria'
ORDER BY 1,2

-- Coutries with highest infection rate

SELECT location,population,MAX(total_cases) as HighestInfecRate, MAX((total_cases/population))*100 as PercPopInfeceted
FROM CovidDeath
Where continent is not null
GROUP BY population, location
ORDER BY PercPopInfeceted DESC


-- Countries with highest death per pop
SELECT location,MAX(total_deaths) as highestDeathRate, MAX((total_deaths/population))*100 as PercPopDead
FROM CovidDeath
Where continent is not null
GROUP BY location
ORDER BY PercPopDead DESC


--Breaking down by continent

SELECT continent,MAX(total_cases) as highestDeathRate, MAX((total_cases/population))*100 as PercPopDead
FROM CovidDeath
Where continent is not null
GROUP BY continent
ORDER BY PercPopDead DESC

-- Showing Continent with highest death rate per population
SELECT continent,MAX(total_deaths) as highestDeathRate, MAX((total_deaths/population))*100 as PercPopDead
FROM CovidDeath
Where continent is not null
GROUP BY continent
ORDER BY  highestDeathRate DESC

--GLOBAL
SELECT date,SUM(total_cases), SUM(total_deaths),SUM(total_deaths)/sum(total_cases) *100 as DeathsPerc
FROM covidDeath
WHERE continent is not null
Group by date
order by DeathsPerc DESC

--Looking at Total Population Vs Vaccination
SELECT De.continent,De.location, De.date, De.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS int)) OVER (PARTITION BY De.location) as RollCount
FROM covidDeath as De JOIN CovidVacc as Vac On De.location = Vac.location
and De.date= Vac.date
WHERE De.continent is not null
order by 2,3

---USE CTE
With PopVSVac (Continent, Location, Date, Population, New_Vaccinationed, RollingPeopleVaccinated)
AS
(
SELECT De.continent,De.location, De.date, De.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS bigint)) OVER (PARTITION BY De.location) as RollCount
FROM covidDeath as De JOIN CovidVacc as Vac On De.location = Vac.location
and De.date= Vac.date
WHERE De.continent is not null

)
SELECT *, (RollingPeopleVaccinated/Population)*100 PercVac
FROM PopVSVac
order by PercVac DESC



-- TEMP Table
DROP TABLE IF EXISTS #PercVaccinated
CREATE TABLE #PercVaccinated
( Continent nvarchar(255), Location nvarchar(255), Date datetime, Population numeric, New_Vaccination numeric, RollingPeopleVaccinated numeric)

INSERT INTO #PercVaccinated
SELECT De.continent,De.location, De.date, De.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS bigint)) OVER (PARTITION BY De.location) as RollCount
FROM covidDeath as De JOIN CovidVacc as Vac On De.location = Vac.location
and De.date= Vac.date
WHERE De.continent is not null

SELECT *
FROM #PercVaccinated


--WORLD VIEW
SELECT continent,MAX(total_deaths) as highestDeathRate, MAX((total_deaths/population))*100 as PercPopDead
FROM CovidDeath
Where continent is not null
GROUP BY continent
ORDER BY  highestDeathRate DESC

--CREATE VIEW
CREATE VIEW PercPopVaccinated AS
SELECT De.continent,De.location, De.date, De.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS bigint)) OVER (PARTITION BY De.location) as RollCount
FROM covidDeath as De JOIN CovidVacc as Vac On De.location = Vac.location
and De.date= Vac.date
WHERE De.continent is not null

SELECT*
FROM PercPopVaccinated





