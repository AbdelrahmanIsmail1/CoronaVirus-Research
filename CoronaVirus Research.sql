Select * FROM dbo.Deaths
ORDER BY 3,4;

Select * FROM dbo.vacin
ORDER BY 3,4;

-- cases and deaths percentange of the total poplutation
Select location,date,total_cases,total_deaths,population,
             (total_cases /population)*100 as covidpercentage,
				(Cast(total_deaths as float)/CAST(total_cases as float)*100) as DeathPercentage
FROM dbo.Deaths
ORDER BY 7 desc;


--Countries highest infection and death rate
Select location,population,	
				max(total_cases) as highest_infectionCount,
               max(CAST(total_cases as float) /CAST(population as float))*100 as infected_populationPERCENT
			   max(cast(total_deaths as float)) as highest_deathCount
			
FROM dbo.Deaths
where continent is not null
GROUP BY location,population
ORDER BY 4 desc;



--continents highest death rate
Select location ,	
				max(cast(total_deaths as float)) as highest_deathCount
             
			
FROM dbo.Deaths
where continent is null
GROUP BY location
ORDER BY 2 desc;



--Infection spreading around the world

	Select date,
			sum(new_cases) as TotalCases,
			 sum(new_deaths) as TotalDeaths,
			 case
					when sum(new_cases)='0' then '0'
					else (sum(new_deaths) /sum(new_cases))*100 
				end	as DeathPercentage
	FROM dbo.Deaths
	group by date


	--Joining vacin table and deaths table
	
	-- Showing daily vaccination in each country
	--USE CTE to get the percentage of vacinations to population

With vacinVpop (continent,population,date,new_vaccinations,Daily_Vacinations_perCountry)
as 
(
	Select dea.continent,dea.population,dea.date,vac.new_vaccinations,
	        SUM(Cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location,dea.date) as Daily_Vacinations_perCountry
	from dbo.Deaths dea
	join dbo.Vacin vac
	on dea.date= vac.date
	where dea.continent is not null
	)

	Select *,(Daily_Vacinations_perCountry/population) as vacination_Per_population
	FROM vacinVpop;

	

