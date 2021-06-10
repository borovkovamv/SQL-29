--=============== ������ 4. ���������� � SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--���� ������: ���� ����������� � �������� ����, �� �������� ����� ������� � �������:
--�������_�������, 
--���� ����������� � ���������� ��� ���������� �������, �� �������� ����� ����� � � ��� �������� �������.

create schema lecture_4

-- ������������� ���� ������ ��� ��������� ���������:
-- 1. ���� (� ������ ����������, ����������� � ��)
-- 2. ���������� (� ������ �������, ���������� � ��)
-- 3. ������ (� ������ ������, �������� � ��)



--������� ���������:
-- �� ����� ����� ����� �������� ��������� �����������
-- ���� ���������� ����� ������� � ��������� �����
-- ������ ������ ����� �������� �� ���������� �����������

 
--���������� � ��������-������������:
-- ������������� �������� ������ ������������� ���������������
-- ������������ ��������� �� ������ ��������� null �������� � �� ������ ����������� ��������� � ��������� ���������
 
--�������� ������� �����

create table languages (
	language_id serial primary key,
	language varchar(50) unique not null)



--�������� ������ � ������� �����

insert into languages(language)
values
	('����������'),
	('�����������'),
	('��������'),
	('�������')


--�������� ������� ����������

create table nationalities (
	nationality_id serial primary key,
	nationality varchar(50) unique not null)

--�������� ������ � ������� ����������

insert into nationalities(nationality) 
values 
	('����������'),
	('��������'),
	('�����'),
	('�������'),
	('��������'),
	('����')

--�������� ������� ������

	create table countries (
	country_id serial primary key,
	country varchar(50) unique not null)


--�������� ������ � ������� ������

insert into countries(country)
values
	('��������'),
	('��������������'),
	('�������'),
	('���������� ���������'),
	('�������')

--�������� ������ ������� �� �������

create table countries_nationalities(
	country_id integer references countries not null,
	nationality_id integer references nationalities not null,
	constraint countries_nationalities_pkey primary key (country_id, nationality_id))

--�������� ������ � ������� �� �������

insert into countries_nationalities 
values
	(1,3),
	(1,6),
	(2,1),
	(2,2),
	(2,3),
	(3,2),
	(3,3),
	(4,4),
	(5,5)

--�������� ������ ������� �� �������

create table languages_nationalities(
	language_id integer references languages not null,
	nationality_id  integer references nationalities not null,
	constraint languages_nationalities_pkey primary key (language_id, nationality_id ))

--�������� ������ � ������� �� �������
	
insert into languages_nationalities 
values
	(1,1),
	(2,2),
	(3,3),
	(4,4),
	(4,5),
	(1,6),
	(3,6),
	(1,5)


--======== �������������� ����� ==============


--������� �1 
--�������� ����� ������� film_new �� ���������� ������:
--�   	film_name - �������� ������ - ��� ������ varchar(255) � ����������� not null
--�   	film_year - ��� ������� ������ - ��� ������ integer, �������, ��� �������� ������ ���� ������ 0
--�   	film_rental_rate - ��������� ������ ������ - ��� ������ numeric(4,2), �������� �� ��������� 0.99
--�   	film_duration - ������������ ������ � ������� - ��� ������ integer, ����������� not null � �������, ��� �������� ������ ���� ������ 0
--���� ��������� � �������� ����, �� ����� ��������� ������� ������� ������������ ����� �����.



--������� �2 
--��������� ������� film_new ������� � ������� SQL-�������, ��� �������� ������������� ������� ������:
--�       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--�       film_year - array[1994, 1999, 1985, 1994, 1993]
--�       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--�   	  film_duration - array[142, 189, 116, 142, 195]



--������� �3
--�������� ��������� ������ ������� � ������� film_new � ������ ����������, 
--��� ��������� ������ ���� ������� ��������� �� 1.41



--������� �4
--����� � ��������� "Back to the Future" ��� ���� � ������, 
--������� ������ � ���� ������� �� ������� film_new



--������� �5
--�������� � ������� film_new ������ � ����� ������ ����� ������



--������� �6
--�������� SQL-������, ������� ������� ��� ������� �� ������� film_new, 
--� ����� ����� ����������� ������� "������������ ������ � �����", ���������� �� �������



--������� �7 
--������� ������� film_new