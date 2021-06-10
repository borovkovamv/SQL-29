--=============== ������ 3. ������ SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ��� ������� ���������� ��� ����� ����������, 
--����� � ������ ����������.

select concat(c.last_name, ' ', c.first_name), a.address , c2.city, c3.country 
from customer c 
join address a on c.address_id = a.address_id 
join city c2 on c2.city_id = a.city_id 
join country c3 on c3.country_id = c2.country_id 



--������� �2
--� ������� SQL-������� ���������� ��� ������� �������� ���������� ��� �����������.

select store_id, count(customer_id)
from customer
group by store_id 


--����������� ������ � �������� ������ �� ��������, 
--� ������� ���������� ����������� ������ 300-��.
--��� ������� ����������� ���������� �� ��������������� ������� 
--� �������������� ������� ���������.

select store_id, count(customer_id)
from customer
group by store_id 
having count(customer_id) > 300



-- ����������� ������, ������� � ���� ���������� � ������ ��������, 
--� ����� ������� � ��� ��������, ������� �������� � ���� ��������.

select c.store_id, count(customer_id), c2.city, concat(s2.last_name, ' ', s2.first_name)
from customer c
join store s on s.store_id = c.store_id
join address a on a.address_id = s.address_id 
join city c2 on c2.city_id = a.city_id 
join staff s2 on s2.staff_id = s.manager_staff_id 
group by c.store_id, c2.city_id , s2.staff_id 
having count(customer_id) > 300



--������� �3
--�������� ���-5 �����������, 
--������� ����� � ������ �� �� ����� ���������� ���������� �������

select concat(c.last_name, ' ', c.first_name), count(i.film_id)
from rental  r
join customer c on c.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
group by r.customer_id, c.customer_id 
order by count(rental_id) desc limit 5



--������� �4
--���������� ��� ������� ���������� 4 ������������� ����������:
--  1. ���������� �������, ������� �� ���� � ������
--  2. ����� ��������� �������� �� ������ ���� ������� (�������� ��������� �� ������ �����)
--  3. ����������� �������� ������� �� ������ ������
--  4. ������������ �������� ������� �� ������ ������

select concat(c.last_name, ' ', c.first_name) as "������� � ��� ����������", 
	count(count_film) as "���������� �������", 
	round(sum(p.amount)) as   "�������", 
	min(p.amount)  as "����������� �������� �������", 
	max(p.amount) as "������������ �������� �������"
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

--������� �5
--��������� ������ �� ������� ������� ��������� ����� �������� ������������ ���� ������� ����� �������,
 --����� � ���������� �� ���� ��� � ����������� ���������� �������. 
 --��� ������� ���������� ������������ ��������� ������������.
 

select c.city, 	c2.city 
from city c 
cross join city c2
where c.city_id <> c2.city_id

--������� �6
--��������� ������ �� ������� rental � ���� ������ ������ � ������ (���� rental_date)
--� ���� �������� ������ (���� return_date), 
--��������� ��� ������� ���������� ������� ���������� ����, �� ������� ���������� ���������� ������.
 
select customer_id, round(avg(return_date::date - rental_date::date),2)
from rental 
group by customer_id
order by customer_id



--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� ������ ������� ��� ��� ����� � ������ � �������� ����� ��������� ������ ������ �� �� �����.





--������� �2
--����������� ������ �� ����������� ������� � �������� � ������� ������� ������, ������� �� ���� �� ����� � ������.





--������� �3
--���������� ���������� ������, ����������� ������ ���������. �������� ����������� ������� "������".
--���� ���������� ������ ��������� 7300, �� �������� � ������� ����� "��", ����� ������ ���� �������� "���".







