create database desql;
use desql;
select * from covidinfected;
select * from covidvaccine;
select location,population,MAX(total_cases) from covidinfected
group by location;
-- Total Number of Covid Positive Cases
select location,population,MAX(CAST(total_cases as UNSIGNED)) as Total_Cases from covidinfected;
-- Percentage of Population Infeceted
select location,population,MAX(CAST(total_cases AS unsigned)) as Total_Cases,MAX((total_cases/population)*100) as Percentage_of_population_infected
from covidinfected
group by location;
-- Highest number of new cases recorded in a day
select location,date,MAX(new_cases) FROM covidinfected
group by location;
-- Maximum number of deaths in a single day
select location,date,MAX(cast(new_deaths as unsigned)) as Max_Deaths_in_a_Day from covidinfected
group by location;
-- Percentage of population fully vaccinated
select a.location,a.population,MAX(cast(b.people_fully_vaccinated as unsigned)) as No_of_Vaccinated,MAX( cast((b.people_fully_vaccinated/a.population)*100 as float)) as Percentage_Vaccinated from covidinfected a 
join covidvaccine b
on a.location=b.location
and a.date=b.date
group by a.location;
--  Most number of vaccinations administered in a single day
select location,date,MAX( cast(new_vaccinations as unsigned)) as total_vaccines from covidvaccine
group by location,date
having total_vaccines>0
order by total_vaccines desc limit 1;
-- Total Vaccinations Vs Population
select a.location,a.date,a.population,b.new_vaccinations,SUM(cast(new_vaccinations as unsigned)) over (partition by a.location order by a.location,a.date)
from covidinfected a
join covidvaccine b
on a.location=b.location
and a.date=b.date
group by a.location,a.date
order by a.location;
 