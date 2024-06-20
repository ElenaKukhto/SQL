--6.1
--С помощью оператора GROUP BY посчитайте количество курьеров мужского и женского пола в таблице couriers.
--Новую колонку с числом курьеров назовите couriers_count. Результат отсортируйте по этой колонке по возрастанию.
SELECT sex, COUNT (courier_id) AS couriers_count
FROM couriers
GROUP BY sex
ORDER BY couriers_count

--6.2
--Посчитайте количество созданных и отменённых заказов в таблице user_actions. Новую колонку с числом заказов назовите orders_count.
--Результат отсортируйте по числу заказов по возрастанию.
SELECT action, COUNT (order_id) AS orders_count
FROM user_actions
GROUP BY action
ORDER BY orders_count

--6.3
--Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца и посчитайте, сколько заказов было сделано в каждом из них.
--Расчёты проведите по таблице orders. Колонку с усечённой датой назовите month, колонку с количеством заказов — orders_count.
--Результат отсортируйте по месяцам — по возрастанию.
SELECT DATE_TRUNC('month', creation_time) AS month, COUNT(order_id) AS orders_count
FROM orders
GROUP BY DATE_TRUNC('month', creation_time)
ORDER BY month

--6.4
--Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца и посчитайте, сколько заказов было сделано и сколько было отменено в каждом из них.
--Расчёты проведите по таблице user_actions. Колонку с усечённой датой назовите month, колонку с количеством заказов — orders_count.
--Результат отсортируйте сначала по месяцам — по возрастанию, затем по типу действия — тоже по возрастанию.
SELECT action, DATE_TRUNC('month', time) AS month, COUNT (order_id) AS orders_count
FROM user_actions
GROUP BY action, DATE_TRUNC('month', time)
ORDER BY month, orders_count

--6.5
--По данным в таблице users посчитайте максимальный порядковый номер месяца среди всех порядковых номеров месяцев рождения пользователей сервиса. 
--С помощью группировки проведите расчёты отдельно в двух группах — для пользователей мужского и женского пола.
--Новую колонку с максимальным номером месяца рождения в группах назовите max_month. 
--Преобразуйте значения в новой колонке в формат INTEGER, чтобы порядковый номер был выражен целым числом. Результат отсортируйте по колонке с полом пользователей.
SELECT sex, MAX(DATE_PART('month', birth_date))::INTEGER AS max_month
FROM users
GROUP BY sex
ORDER BY sex

--6.6
--По данным в таблице users посчитайте порядковый номер месяца рождения самого молодого пользователя сервиса.
SELECT sex, DATE_PART('month', MAX(birth_date))::INTEGER AS max_month
FROM users
GROUP BY sex
ORDER BY sex

--6.7
--Посчитайте максимальный возраст пользователей мужского и женского пола в таблице users. Возраст измерьте числом полных лет.
--Новую колонку с возрастом назовите max_age. Преобразуйте значения в новой колонке в формат INTEGER, чтобы возраст был выражен целым числом.
--Результат отсортируйте по новой колонке по возрастанию возраста.
SELECT sex, DATE_PART('year', MAX(AGE(current_date,birth_date)))::INTEGER AS max_age
FROM users
GROUP BY sex
ORDER BY max_age

--6.8
--Разбейте пользователей из таблицы users на группы по возрасту и посчитайте количество пользователей каждого возраста.
--Колонку с возрастом назовите age, а колонку с числом пользователей — users_count. Преобразуйте значения в колонке с возрастом в формат INTEGER, чтобы возраст был выражен целым числом.
--Результат отсортируйте по колонке с возрастом по возрастанию.
SELECT COUNT(user_id) AS users_count, DATE_PART('year', AGE(current_date,birth_date))::INTEGER AS age
FROM users
GROUP BY DATE_PART('year', AGE(current_date,birth_date))
ORDER BY age

--6.9
--К условиям задачи 6.8 + добавьте в группировку ещё и пол пользователя. Все NULL значения в колонке birth_date заранее отфильтруйте с помощью WHERE.
--Отсортируйте полученную таблицу сначала по колонке с возрастом по возрастанию, затем по колонке с полом — тоже по возрастанию.
SELECT sex, COUNT(user_id) AS users_count, DATE_PART('year', AGE(current_date,birth_date))::INTEGER AS age
FROM users
WHERE birth_date IS NOT NULL
GROUP BY DATE_PART('year', AGE(current_date,birth_date)), sex
ORDER BY age, sex

--6.10
--Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку и рассчитайте количество заказов в каждой группе за неделю с 29 августа по 4 сентября 2022 года включительно. 
--Для расчётов используйте данные из таблицы orders.
--Результат отсортируйте по возрастанию размера заказа.
SELECT array_length(product_ids, 1) AS order_size, COUNT(order_id) AS orders_count 
FROM orders
WHERE creation_time BETWEEN '2022/08/29' AND '2022/09/05'
GROUP BY order_size
ORDER BY order_size

--6.11
--Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку и рассчитайте количество заказов в каждой группе. 
--Учитывайте только заказы, оформленные по будням. В результат включите только те размеры заказов, общее число которых превышает 2000. 
--Для расчётов используйте данные из таблицы orders. Выведите две колонки: размер заказа и число заказов такого размера.
--Результат отсортируйте по возрастанию размера заказа.
SELECT array_length(product_ids, 1) AS order_size, COUNT(order_id) AS orders_count 
FROM orders
WHERE DATE_PART('dow', creation_time) in (1, 2, 3, 4, 5)
GROUP BY order_size
HAVING COUNT(order_id) > 2000
ORDER BY order_size

Вариант решения от создателя курса:
SELECT array_length(product_ids, 1) as order_size,
       count(order_id) as orders_count
FROM   orders
WHERE  to_char(creation_time, 'Dy') not in ('Sat', 'Sun')
GROUP BY order_size having count(order_id) > 2000
ORDER BY order_size

--6.12
--Определите пять пользователей, сделавших в августе 2022 года наибольшее количество заказов.
--Выведите две колонки — id пользователей и число оформленных ими заказов. Колонку с числом оформленных заказов назовите created_orders.
--Результат отсортируйте сначала по убыванию числа заказов, сделанных пятью пользователями, затем по возрастанию id этих пользователей.
SELECT user_id, COUNT(action) AS created_orders
FROM user_actions
WHERE action = 'create_order'AND time between '2022/08/01' AND '2022/09/01'
GROUP BY user_id
ORDER BY created_orders DESC, user_id
LIMIT 5

Вариант решения от создателя курса:
SELECT user_id,
       count(distinct order_id) as created_orders
FROM   user_actions
WHERE  action = 'create_order'
   and date_part('month', time) = 8
   and date_part('year', time) = 2022
GROUP BY user_id
ORDER BY created_orders desc, user_id limit 5

--6.13
--Определите курьеров, которые в сентябре 2022 года доставили только по одному заказу.
SELECT courier_id
FROM courier_actions
WHERE action = 'deliver_order' 
AND DATE_PART('month',time) = 9
AND DATE_PART('year', time) = 2022
GROUP BY courier_id
HAVING COUNT(DISTINCT order_id) = 1
ORDER BY courier_id

--6.14
--Из таблицы user_actions отберите пользователей, у которых последний заказ был создан до 8 сентября 2022 года.
--Выведите только их id. Результат отсортируйте по возрастанию id пользователя.
SELECT user_id
FROM user_actions
WHERE action = 'create_order'
GROUP BY user_id
HAVING MAX(time) < '2022/09/08'
ORDER BY user_id

--6.15
--Разбейте заказы из таблицы orders на 3 группы в зависимости от количества товаров. Посчитайте число заказов, попавших в каждую группу. 
--Выведите наименования групп и число товаров в них. Отсортируйте полученную таблицу по колонке с числом заказов по возрастанию.
SELECT 
case when array_length(product_ids, 1) >= 1 and array_length(product_ids, 1) <= 3 then 'Малый'
when array_length(product_ids, 1) >= 4 and array_length(product_ids, 1) <= 6 then 'Средний'
when array_length(product_ids, 1) >= 7 then 'Большой' 
end as order_size,
COUNT(order_id) as orders_count
FROM   orders
GROUP BY order_size
ORDER BY COUNT(order_id)

--6.16
--Разбейте пользователей из таблицы users на 4 возрастные группы. Посчитайте число пользователей, попавших в каждую возрастную группу. 
--В расчётах не учитывайте пользователей, у которых не указана дата рождения. Выведите наименования групп и число пользователей в них.
--Отсортируйте полученную таблицу по колонке с наименованием групп по возрастанию.
SELECT case when date_part('year', age(birth_date)) between 18 and 24 then '18-24'
when date_part('year', age(birth_date)) between 25 and 29 then '25-29'
when date_part('year', age(birth_date)) between 30 and 35 then '30-35'
when date_part('year', age(birth_date)) >=36 then  '36+'
end AS group_age,
COUNT(user_id) AS users_count
FROM users
WHERE birth_date IS NOT NULL
GROUP BY group_age
ORDER BY group_age

--6.17
--Рассчитайте средний размер заказа по выходным и будням. Группу с выходными днями (суббота и воскресенье) назовите «weekend», 
--а группу с будними днями (с понедельника по пятницу) — «weekdays». Средний размер заказа округлите до двух знаков после запятой.
--Результат отсортируйте по колонке со средним размером заказа — по возрастанию.
SELECT 
case
when (DATE_PART('dow', creation_time) IN (1, 2, 3, 4, 5)) then 'weekdays'
when (DATE_PART('dow', creation_time) IN (6, 0)) then 'weekend'
end AS week_part,
ROUND(AVG(array_length(product_ids, 1)), 2) AS avg_order_size
FROM orders
GROUP BY week_part
ORDER BY avg_order_size
