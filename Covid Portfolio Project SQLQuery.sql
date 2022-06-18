Select *
From dbo.[Covid Deaths]
where continent is not null
Order by 3,4

--Select *
--From dbo.[Covid Vaccinations]
--Order by 3,4

--Select Data that we are going to be using 

Select 
 location,
 date,
 total_cases,
 new_cases,
 total_deaths,
 population
From dbo.[Covid Deaths]
where continent is not null
Order by 1,2

-- Looking at Total Cases Vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

Select 
 location,
 date,
 total_cases,
 total_deaths,
 (total_deaths/total_cases) * 100 as Death_percentage 
From dbo.[Covid Deaths]
Where location = 'Canada'
and continent is not null
Order by 3,4

-- Looking at Total Cases Vs Population
-- Shows percantage of popluation that got covid 

Select 
 location,
 date,
 total_cases,
 population,
 (total_cases/population) * 100 as Case_percentage 
From dbo.[Covid Deaths]
--Where location = 'Canada'
where continent is not null
Order by 3,4


--Countires with highest infestion rate compared to population 

Select 
	 location,
	 population,
	 Max(total_cases) as highest_infection_count ,
	 Max((total_cases/population)) * 100 as Case_percentage 
From dbo.[Covid Deaths]
--Where location like 'Canada' 
	-- or location like 'United States'
where continent is not null
Group by Location, population
Order by Case_percentage DESC


--Countries with highest death count per population

Select 
	 location,
	 Max(cast(total_deaths as int)) as Total_death_count 
From dbo.[Covid Deaths]
--Where location like 'Canada' 
	-- or location like 'United States'
Where continent is not null
Group by Location
Order by Total_death_count  DESC

--LET'S BREAK THINGS DOWN BY CONTINENT
--Continent with highest death count

Select 
	 continent,
	 Max(cast(total_deaths as int)) as Total_death_count 
From dbo.[Covid Deaths]
--Where location like 'Canada' 
	-- or location like 'United States'
Where continent is not null
Group by continent
Order by Total_death_count  DESC


Select 
	 location,
	 Max(cast(total_deaths as int)) as Total_death_count 
From dbo.[Covid Deaths]
Where continent is null
 and location in ('Europe','North America', 'Asia', 'South America', 'Africa', 'Oceania')
Group by location
Order by Total_death_count  DESC


--Global Numbers

Select 
Sum(new_cases) as Total_New_Cases,
Sum(cast(new_deaths as int)) as Total_deaths,
Sum(cast(new_deaths as int))/Sum(new_cases)* 100 as Death_Percentage_NC
From dbo.[Covid Deaths]
--Where location = 'Canada'
where continent is not null
--Group by date
Order by 2,1



Select 
 date,
Sum(new_cases) as Total_New_Cases,
Sum(cast(new_deaths as int)) as Total_deaths,
Sum(cast(new_deaths as int))/Sum(new_cases)* 100 as Death_Percentage_NC
From dbo.[Covid Deaths]
--Where location = 'Canada'
where continent is not null
Group by date
Order by 2,1

--Looking at Total Population vs vaccinations


Select *
From [dbo].[Covid Deaths] dea
Join [dbo].[Covid Vaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date

Select 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	Sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.Location) as Rolling_people_vaccinated 
From [dbo].[Covid Deaths] dea
Join [dbo].[Covid Vaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,1