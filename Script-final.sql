--1
select city "Город", count(airport_code) as "Количество аэропортов"
from airports a
group by city 
having count(airport_code) > 1;

--2
select aero.*, a2.airport_name 
	from (
	select f.departure_airport 
	from flights f
	where f.aircraft_code =(
	select a.aircraft_code
	from aircrafts a 
	order by range desc
	limit 1)
	group by f.departure_airport) aero
join airports a2 on a2.airport_code = aero.departure_airport


--3
select f.flight_id, f.scheduled_departure, f.actual_departure, 	f.actual_departure - f.scheduled_departure "Задержка вылета"
from flights f
where f.actual_departure is not null
order by 4 desc
limit 10

--4
select 
	case 
	when count(b.book_ref) > 0 then 'Да'
	else 'Нет'
	end as "Брони без посадочных"
from bookings b
left join tickets t on b.book_ref = t.book_ref
left join boarding_passes bp on t.ticket_no = bp.ticket_no
where bp.boarding_no is null

--5
with cte1 as (
	select 
		f.flight_id,
		f.aircraft_code,
		f.departure_airport,
		f.actual_departure,
		count(bp.boarding_no) as "Количество посадочных"
	from flights f 
	join boarding_passes bp on bp.flight_id = f.flight_id 
	where f.actual_departure is not null
	group by f.flight_id 
),
cte2 as(
	select 
		s.aircraft_code,
		count(s.seat_no) as "Количество мест в самолете"
	from seats s 
	group by s.aircraft_code )
select 
	c1.actual_departure,
	c1.departure_airport,
	c1.flight_id,
	c2."Количество мест в самолете",
	c1."Количество посадочных",
	c2."Количество мест в самолете" - c1."Количество посадочных" as "Свободные места", 
	round((c2."Количество мест в самолете" - c1."Количество посадочных") / c2."Количество мест в самолете" :: dec, 2) * 100 as "% свободных мест на рейсе",
	sum(c1."Количество посадочных") over (partition by (c1.actual_departure::date, c1.departure_airport) order by c1.actual_departure, c1.departure_airport) "Количество вылетевших пассажиров"
from cte1 c1 
join cte2 c2 on c2.aircraft_code = c1.aircraft_code

--6
select 
aircraft_code as "Тип самолета", 
round(count(flight_id) * 100. / (select count(flight_id) from flights f2)) as "% перелетов"
from flights f 
group by aircraft_code

--7
with cte1 as (
	select flight_id, max (amount) as economy
	from ticket_flights tf 
	where fare_conditions = 'Economy'
	group by flight_id),
cte2 as (
	select flight_id, min (amount) as business 
	from ticket_flights tf 
	where fare_conditions = 'Business'
	group by flight_id)
select a.city 
from airports a
left join flights f on a.airport_code = f.departure_airport 
left join cte1 on f.flight_id = cte1.flight_id
left join cte2 on cte1.flight_id = cte2.flight_id
where cte1.economy > cte2.business
group by a.city

--8
create view view1 as
	select distinct c1.city as city1, c2.city as city2
	from airports c1
	cross join airports c2
	where c1.city != c2.city
	
create view view2 as
	select a1.city as city1, a2.city as city2
	from flights f 
	join airports a1 on f.departure_airport = a1.airport_code
	join airports a2 on f.arrival_airport = a2.airport_code
	group by a1.city, a2.city
	
select *
from cities
except
select *
from connected_cities
order by city1, city2

--9
select 
	a1.airport_name as "Вылет",
	a2.airport_name AS "Прилет",
	a.model AS "Модель самолета",
	a."range",
	round((acos(sind(a1.latitude) * sind(a2.latitude) + cosd(a1.latitude) * cosd(a2.latitude) * cosd(a1.longitude - a2.longitude)) * 6371)::dec, 2) as "Расстояние между аэропортами",		
	case 
		when a."range" < acos(sind(a1.latitude) * sind(a2.latitude) + cosd(a1.latitude) * cosd(a2.latitude) * cosd(a1.longitude - a2.longitude)) * 6371 
		then 'НЕТ, ALARM!'
		else 'Да, все ОК'
	end "Проверка, долетит?"
from flights f
join airports a1 on f.departure_airport = a1.airport_code
join airports a2 on f.arrival_airport = a2.airport_code
join aircrafts a on a.aircraft_code = f.aircraft_code 
group by a1.airport_code, a2.airport_code, a.aircraft_code 
order by a1.airport_name, a2.airport_name, a.model
