--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".


--explain analyze
select f.film_id,
		f.title ,
		f.special_features 
from film f
where  array_position(f.special_features, 'Behind the Scenes') is not null
--Seq Scan on film f  (cost=0.00..66.50 rows=995 width=78) (actual time=0.043..1.073 rows=538 loops=1)
--Execution Time: 1.137 ms



--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.



--explain analyze
select f.film_id,
		f.title ,
		f.special_features 
from film f
where 'Behind the Scenes' = any(f.special_features) 
--Seq Scan on film f  (cost=0.00..76.50 rows=538 width=78) (actual time=0.046..1.120 rows=538 loops=1)
--Execution Time: 1.195 ms



--explain analyze
select f.film_id,
		f.title ,
		f.special_features 
from film f
where f.special_features @> array['Behind the Scenes']
--Seq Scan on film f  (cost=0.00..66.50 rows=538 width=78) (actual time=0.015..0.379 rows=538 loops=1)
--Execution Time: 0.399 ms



--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

--explain analyze
with cte as (
select f.film_id,
		f.title ,
		f.special_features 
from film f
where  array_position(f.special_features, 'Behind the Scenes') is not null)
select
	r.customer_id,
	count(i.film_id) as film_count
from rental r 
join inventory i using(inventory_id)
join cte ct using(film_id)
group by r.customer_id
order by r.customer_id 
--Sort  (cost=715.35..716.84 rows=599 width=10) (actual time=22.574..22.608 rows=599 loops=1)
--Execution Time: 22.878 ms


--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.


--explain analyze
select
	r.customer_id,
	count(i.film_id) as film_count
from rental r 
join inventory i using(inventory_id)
join (select f.film_id,
		f.title ,
		f.special_features 
from film f
where  array_position(f.special_features, 'Behind the Scenes') is not null) vt using(film_id)
group by r.customer_id
order by r.customer_id 
--Sort  (cost=715.35..716.84 rows=599 width=10) (actual time=31.829..31.866 rows=599 loops=1)
--Execution Time: 32.166 ms


--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view my_fist_view as
select
	r.customer_id,
	count(i.film_id) as film_count
from rental r 
join inventory i using(inventory_id)
join (select f.film_id,
		f.title ,
		f.special_features 
from film f
where  array_position(f.special_features, 'Behind the Scenes') is not null) vt using(film_id)
group by r.customer_id
order by r.customer_id 
with data

refresh materialized view my_fist_view

--explain analyze
select * from my_fist_view
--Seq Scan on my_fist_view  (cost=0.00..9.99 rows=599 width=10) (actual time=0.031..0.122 rows=599 loops=1)
--Execution Time: 0.175 ms



--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:

--1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, 
--   поиск значения в массиве происходит быстрее
--2. какой вариант вычислений работает быстрее: 
--   с использованием CTE или с использованием подзапроса

1. Быстрее всего выполнился запрос с оператором "@>". Хотя по стоимости они одинаковы были с "array_position", но по вермени все же быстрее "@>".
2. По стоимости одинаково, что CTE что вложенные запрос, по фактическому времени отличаются, хотя если выполнять запрос неоднократно,  то он  может выполниться и тот и другой и за 19 ms и за 30 ms.
	Так что считаю, что без разницы в данном примере.



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день




