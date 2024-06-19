--5.1
--Выведите id всех уникальных пользователей из таблицы user_actions. Результат отсортируйте по возрастанию id.
SELECT DISTINCT user_id
FROM user_actions
ORDER BY user_id

--5.2
--Примените DISTINCT сразу к двум колонкам таблицы courier_actions и отберите уникальные пары значений courier_id и order_id.
--Результат отсортируйте сначала по возрастанию id курьера, затем по возрастанию id заказа.
SELECT DISTINCT courier_id, order_id
FROM courier_actions
ORDER BY courier_id, order_id 

--5.3
--Посчитайте максимальную и минимальную цены товаров в таблице products. Поля назовите соответственно max_price, min_price.
SELECT MAX(price) AS max_price, MIN(price) AS min_price
FROM products

--5.4
--Посчитайте в одном запросе количество всех записей в таблице и количество только тех записей, для которых в колонке birth_date указана дата рождения.
--Колонку с общим числом записей назовите dates, а колонку с записями без пропусков — dates_not_null.
SELECT COUNT(*) AS dates, COUNT (birth_date) AS dates_not_null
FROM users

--5.5
--Посчитайте количество всех значений в колонке user_id в таблице user_actions, а также количество уникальных значений в этой колонке.
--Колонку с первым полученным значением назовите users, а колонку со вторым — unique_users.
SELECT COUNT(user_id) AS users, COUNT(DISTINCT user_id) AS unique_users
FROM user_actions

--5.6
--Посчитайте количество курьеров женского пола в таблице couriers. Полученный столбец с одним значением назовите couriers.
SELECT COUNT(courier_id) AS couriers
FROM couriers
WHERE sex = 'female'

--5.7
--Рассчитайте время, когда были совершены первая и последняя доставки заказов в таблице courier_actions.
--Колонку с временем первой доставки назовите first_delivery, а колонку с временем последней — last_delivery.
SELECT MIN(time) AS first_delivery, MAX(time) AS last_delivery
FROM courier_actions
WHERE  action = 'deliver_order'

--5.8
--Один из пользователей сервиса сделал заказ, в который вошли одна пачка сухариков, одна пачка чипсов и один энергетический напиток. 
--Посчитайте стоимость такого заказа. Колонку с рассчитанной стоимостью заказа назовите order_price.
SELECT SUM(price) AS order_price
FROM products
WHERE name IN ('сухарики', 'чипсы', 'энергетический напиток')

--5.9
--Посчитайте количество заказов в таблице orders с девятью и более товарами. Для этого воспользуйтесь функцией array_length, 
--отфильтруйте данные по количеству товаров в заказе и проведите агрегацию. Полученный столбец назовите orders.
SELECT COUNT(order_id) AS orders
FROM orders
WHERE array_length(product_ids, 1) >= 9

--5.10
--рассчитайте возраст самого молодого курьера мужского пола в таблице couriers.
--Возраст выразите количеством лет, месяцев и дней (как в примере выше), переведя его в тип VARCHAR. 
--Полученную колонку со значением возраста назовите min_age.
SELECT MIN(AGE(birth_date):: VARCHAR) AS min_age
FROM couriers
WHERE sex = 'male'

--5.11
--Посчитайте стоимость заказа, в котором будут три пачки сухариков, две пачки чипсов и один энергетический напиток. 
--Колонку с рассчитанной стоимостью заказа назовите order_price.
SELECT SUM(
case
WHEN name = 'сухарики' THEN price*3
WHEN name = 'чипсы' THEN price*2
WHEN name = 'энергетический напиток' THEN price
ELSE  0
END) AS order_price
FROM products


--5.12
--Рассчитайте среднюю цену товаров в таблице products, в названиях которых присутствуют слова «чай» или «кофе». 
--Любым известным способом исключите из расчёта товары, содержащие в названии «иван-чай» или «чайный гриб».
--Среднюю цену округлите до двух знаков после запятой. Столбец с полученным значением назовите avg_price.
SELECT ROUND(AVG(price), 2) AS avg_price
FROM products
WHERE name LIKE 'чай %' OR name LIKE 'кофе %' 
AND name NOT LIKE 'иван-чай' 
AND name NOT LIKE 'чайный гриб' 

--5.13
--Рассчитайте разницу в возрасте между самым старым и самым молодым пользователями мужского пола в таблице users. 
--Разницу в возрасте выразите количеством лет, месяцев и дней, переведя её в тип VARCHAR. Колонку с посчитанным значением назовите age_diff.
SELECT AGE(MAX(birth_date), MIN(birth_date)):: VARCHAR AS age_diff
FROM users
WHERE sex = 'male'

--5.14
--Рассчитайте среднее количество товаров в заказах из таблицы orders, которые пользователи оформляли по выходным дням (суббота и воскресенье) 
в течение всего времени работы сервиса. Полученное значение округлите до двух знаков после запятой. Колонку с ним назовите avg_order_size.
SELECT ROUND(AVG(array_length(product_ids, 1)), 2) AS avg_order_size
FROM   orders
WHERE  date_part('dow', creation_time) in (6, 0)

--5.15
--Посчитайте количество уникальных пользователей сервиса, количество уникальных заказов, поделите одно на другое и выясните, 
--сколько заказов приходится на одного пользователя. Показатель числа заказов на пользователя округлите до двух знаков после запятой.
SELECT 
COUNT(DISTINCT user_id) AS unique_users,
COUNT(DISTINCT order_id) AS unique_orders,
ROUND(COUNT(DISTINCT order_id):: DECIMAL / COUNT(DISTINCT user_id), 2) AS orders_per_user
FROM user_actions

--5.16
--Посчитайте, сколько пользователей никогда не отменяли свой заказ. Для этого из общего числа всех уникальных пользователей 
--отнимите число уникальных пользователей, которые хотя бы раз отменяли заказ.
SELECT COUNT(DISTINCT user_id) - COUNT(DISTINCT user_id) FILTER (WHERE action = 'cancel_order') AS users_count
FROM user_actions

--5.17
--Посчитайте общее количество заказов в таблице orders, количество заказов с пятью и более товарами и
--найдите долю заказов с пятью и более товарами в общем количестве заказов.
--Долю заказов с пятью и более товарами в общем количестве товаров округлите до двух знаков после запятой.
SELECT 
COUNT(order_id) AS orders,
COUNT (order_id) FILTER (WHERE array_length(product_ids, 1) >= 5) AS large_orders,
ROUND (COUNT(order_id) FILTER (WHERE array_length(product_ids, 1) >= 5) :: DECIMAL / COUNT(order_id),2) AS large_orders_share
FROM orders
