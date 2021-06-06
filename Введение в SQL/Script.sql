select tc.table_name, kcu.column_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu on tc.constraint_name = kcu.constraint_name 
where tc.constraint_schema = 'public' and tc.constraint_type = 'PRIMARY KEY';

SELECT * FROM country;

