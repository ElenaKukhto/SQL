--4.1
--Напишите SQL-запрос к таблице products и выведите всю информацию о товарах, цена которых не превышает 100 рублей. 
--Результат отсортируйте по возрастанию id товара.
SELECT *
FROM products
WHERE price <= 100
ORDER BY product_id

--4.2
--Отберите пользователей женского пола из таблицы users. Выведите только id этих пользователей. Результат отсортируйте по возрастанию id.
--Добавьте в запрос оператор LIMIT и выведите только 1000 первых id из отсортированного списка.
SELECT user_id
FROM users
WHERE sex = 'female'
ORDER BY user_id limit 1000

--4.3
--Отберите из таблицы user_actions все действия пользователей по созданию заказов, которые были совершены ими после полуночи 6 сентября 2022 года.
--Выведите колонки с id пользователей, id созданных заказов и временем их создания. Результат должен быть отсортирован по возрастанию id заказа.
SELECT user_id,
       order_id,
       time
FROM user_actions
WHERE action = 'create_order' AND time > '2022-09-06'
ORDER BY order_id

--4.4
--Назначьте скидку 20% на все товары из таблицы products и отберите те, цена на которые с учётом скидки превышает 100 рублей. 
--Выведите id товаров, их наименования, прежнюю цену и новую цену с учётом скидки. Колонку со старой ценой назовите old_price, с новой — new_price.
--Результат должен быть отсортирован по возрастанию id товара.
SELECT product_id,
       name,
       price - (price * 20 / 100) as new_price,
       price as old_price
FROM products
WHERE price - (price * 20 / 100) > 100
ORDER BY product_id

--4.5
--Отберите из таблицы products все товары, названия которых либо начинаются со слова «чай», либо состоят из пяти символов. 
--Выведите две колонки: id товаров и их наименования. Результат должен быть отсортирован по возрастанию id товара.
SELECT product_id,
       name
FROM products
WHERE split_part(name, ' ', 1) = 'чай' OR length(name) = 5
ORDER BY product_id

--4.6
--Отберите из таблицы products все товары, содержащие в своём названии последовательность символов «чай» (без кавычек). 
--Выведите две колонки: id продукта и его название. Результат должен быть отсортирован по возрастанию id товара.
SELECT product_id, name 
FROM products
WHERE name LIKE '%чай%'
ORDER BY product_id

--4.7
--Выберите из таблицы products id и наименования только тех товаров, названия которых начинаются на букву «с» и содержат только одно слово.
--Результат должен быть отсортирован по возрастанию id товара.
SELECT product_id, name
FROM products
WHERE name LIKE 'с%' AND name NOT LIKE '% %'
ORDER BY product_id

--4.8
--Составьте SQL-запрос, который выбирает из таблицы products все чаи стоимостью больше 60 рублей и вычисляет для них цену со скидкой 25%.
--Скидку в % указать в отдельном столбце в формате текста. Столбцы со скидкой и новой ценой назовите соответственно discount и new_price.
--Также необходимо любым известным способом избавиться от «чайного гриба». Результат должен быть отсортирован по возрастанию id товара.
SELECT product_id, name, price, price - (price * 25 / 100) AS new_price, '25%' AS discount
FROM products
WHERE name LIKE '%чай %' AND name NOT LIKE  'чайный гриб' AND price > 60
ORDER BY product_id

--4.9
--Из таблицы user_actions выведите всю информацию о действиях пользователей с id 170, 200 и 230 за период с 25 августа по 4 сентября 2022 года включительно.
--Результат отсортируйте по убыванию id заказа — то есть от самых поздних действий к самым первым.
  SELECT action, order_id, time, user_id
  FROM user_actions
  WHERE user_id IN (170, 200, 230) AND  time BETWEEN '2022-08-25' AND '2022-09-05'
  ORDER BY order_id DESC

--4.10
--Напишите SQL-запрос к таблице couriers и выведите всю информацию о курьерах, у которых не указан их день рождения.
--Результат должен быть отсортирован по возрастанию id курьера.
SELECT birth_date, courier_id, sex
FROM couriers
WHERE birth_date IS null
ORDER BY courier_id

--4.11
--Определите id и даты рождения 50 самых молодых пользователей мужского пола из таблицы users. 
--Не учитывайте тех пользователей, у которых не указана дата рождения.
SELECT user_id, birth_date
FROM users
WHERE sex = 'male' AND birth_date IS NOT null
ORDER BY birth_date DESC
LIMIT 50

--4.12
--Узнать id и время доставки последних 10 заказов, доставленных курьером с id 100.

SELECT order_id, time
FROM courier_actions
WHERE action = 'deliver_order' AND courier_id = 100
ORDER BY time DESC
LIMIT 10

--4.13
--Получите id всех заказов, сделанных пользователями сервиса в августе 2022 года. Результат отсортируйте по возрастанию id заказа.
SELECT order_id
FROM user_actions
WHERE action = 'create_order' AND  date_part('month', time) = 8 AND date_part('year', time) = 2022
ORDER BY order_id

--4.14
--Отберите id всех курьеров, родившихся в период с 1990 по 1995 год включительно. Результат отсортируйте по возрастанию id курьера.
SELECT courier_id
FROM couriers
WHERE DATE_PART('year', birth_date) BETWEEN '1990' AND '1995'
ORDER BY courier_id

--4.15
--Получите информацию о всех отменах заказов, которые пользователи совершали в течение августа 2022 года по средам с 12:00 до 15:59.
--Результат отсортируйте по убыванию id отменённых заказов.
SELECT action, order_id, time, user_id
FROM user_actions
WHERE action = 'cancel_order' 
AND 
DATE_PART('month', time) = 8 
AND 
DATE_PART('YEAR', time) = 2022
AND 
DATE_PART('dow', time) = 3 
AND
date_part('hour', time) BETWEEN 12 AND 15
ORDER BY order_id desc

--4.16
--SELECT product_id,
       name,
       price,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 
    'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 
    'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 
    'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 
    'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') 
    then round(price/110*10, 2)
    else round(price/120*20, 2)
    end as tax                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    2)else round(price/120*20, 2) end as tax,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное',
    'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка',
    'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 
    'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка',
    'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка',
    'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') 
    then round(price - price/110*10, 2)
    else round(price - price/120*20, 2) 
    end as price_before_tax
FROM products
ORDER BY price_before_tax desc, product_id