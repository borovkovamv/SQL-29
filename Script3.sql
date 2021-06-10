--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select concat(c.last_name, ' ', c.first_name), a.address , c2.city, c3.country 
from customer c 
join address a on c.address_id = a.address_id 
join city c2 on c2.city_id = a.city_id 
join country c3 on c3.country_id = c2.country_id 



--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select store_id, count(customer_id)
from customer
group by store_id 


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select store_id, count(customer_id)
from customer
group by store_id 
having count(customer_id) > 300



-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select c.store_id, count(customer_id), c2.city, concat(s2.last_name, ' ', s2.first_name)
from customer c
join store s on s.store_id = c.store_id
join address a on a.address_id = s.address_id 
join city c2 on c2.city_id = a.city_id 
join staff s2 on s2.staff_id = s.manager_staff_id 
group by c.store_id, c2.city_id , s2.staff_id 
having count(customer_id) > 300



--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select concat(c.last_name, ' ', c.first_name), count(i.film_id)
from rental  r
join customer c on c.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
group by r.customer_id, c.customer_id 
order by count(rental_id) desc limit 5



--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select concat(c.last_name, ' ', c.first_name) as "Фамилия и имя покупателя", 
	count(count_film) as "Количество фильмов", 
	round(sum(p.amount)) as   "Платежи", 
	min(p.amount)  as "Минимальное значение платежа", 
	max(p.amount) as "Максимальное значение платежа"
from payment p 
join customer c on c.customer_id = p.customer_id 
join 
	(select r.customer_id, count(i.film_id) as count_film 
	from rental r  
	join inventory i on r.inventory_id = i.inventory_id 
	group by  r.customer_id) f 
on f.customer_id = p.customer_id 
group by p.customer_id, c.customer_id 
order by concat(c.last_name, ' ', c.first_name) 

--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 

select c.city, 	c2.city 
from city c 
cross join city c2
where c.city_id <> c2.city_id

--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
select customer_id, round(avg(return_date::date - rental_date::date),2)
from rental 
group by customer_id
order by customer_id



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.





--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.





--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".







