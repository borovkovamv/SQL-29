--=============== ������ 6. POSTGRESQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� SQL-������, ������� ������� ��� ���������� � ������� 
--�� ����������� ��������� "Behind the Scenes".


--explain analyze
select f.film_id,
		f.title ,
		f.special_features 
from film f
where  array_position(f.special_features, 'Behind the Scenes') is not null
--Seq Scan on film f  (cost=0.00..66.50 rows=995 width=78) (actual time=0.043..1.073 rows=538 loops=1)
--Execution Time: 1.137 ms



--������� �2
--�������� ��� 2 �������� ������ ������� � ��������� "Behind the Scenes",
--��������� ������ ������� ��� ��������� ����� SQL ��� ������ �������� � �������.



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



--������� �3
--��� ������� ���������� ���������� ������� �� ���� � ������ ������� 
--�� ����������� ��������� "Behind the Scenes.

--������������ ������� ��� ���������� �������: ����������� ������ �� ������� 1, 
--���������� � CTE. CTE ���������� ������������ ��� ������� �������.

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


--������� �4
--��� ������� ���������� ���������� ������� �� ���� � ������ �������
-- �� ����������� ��������� "Behind the Scenes".

--������������ ������� ��� ���������� �������: ����������� ������ �� ������� 1,
--���������� � ���������, ������� ���������� ������������ ��� ������� �������.


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


--������� �5
--�������� ����������������� ������������� � �������� �� ����������� �������
--� �������� ������ ��� ���������� ������������������ �������������

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



--������� �6
--� ������� explain analyze ��������� ������ �������� ���������� ��������
-- �� ���������� ������� � �������� �� �������:

--1. ����� ���������� ��� �������� ����� SQL, ������������ ��� ���������� ��������� �������, 
--   ����� �������� � ������� ���������� �������
--2. ����� ������� ���������� �������� �������: 
--   � �������������� CTE ��� � �������������� ����������

1. ������� ����� ���������� ������ � ���������� "@>". ���� �� ��������� ��� ��������� ���� � "array_position", �� �� ������� ��� �� ������� "@>".
2. �� ��������� ���������, ��� CTE ��� ��������� ������, �� ������������ ������� ����������, ���� ���� ��������� ������ ������������,  �� ��  ����� ����������� � ��� � ������ � �� 19 ms � �� 30 ms.
	��� ��� ������, ��� ��� ������� � ������ �������.



--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� � ����� ������ �� ����� ���������

--������� �2
--��������� ������� ������� �������� ��� ������� ����������
--�������� � ����� ������ ������� ����� ����������.





--������� �3
--��� ������� �������� ���������� � �������� ����� SQL-�������� ��������� ������������� ����������:
-- 1. ����, � ������� ���������� ������ ����� ������� (���� � ������� ���-�����-����)
-- 2. ���������� ������� ������ � ������ � ���� ����
-- 3. ����, � ������� ������� ������� �� ���������� ����� (���� � ������� ���-�����-����)
-- 4. ����� ������� � ���� ����




