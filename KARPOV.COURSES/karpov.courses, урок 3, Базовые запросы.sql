--3.1 
----Выведите все записи из таблицы products.
SELECT *
FROM products

--3.2
--Выведите все записи из таблицы products, отсортировав их по наименованиям товаров в алфавитном порядке, т.е. по возрастанию. 
--Для сортировки используйте оператор ORDER BY.
SELECT name,
       price,
       product_id
FROM products
ORDER BY name

--3.3
--Отсортируйте таблицу courier_actions сначала по колонке courier_id по возрастанию id курьера, 
--потом по колонке action (снова по возрастанию), а затем по колонке time, но уже по убыванию — от самого последнего действия к самому первому.
--Не забудьте включить в результат колонку order_id. Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
SELECT action,
       courier_id,
       order_id,
       time
FROM courier_actions
ORDER BY courier_id, action, time desc limit 1000

--3.4
--Используя операторы SELECT, FROM, ORDER BY и LIMIT, определите 5 самых дорогих товаров в таблице products, 
--которые доставляет наш сервис. Выведите их наименования и цену.
SELECT name,
       price
FROM products
ORDER BY price desc limit 5

--3.5
--Повторите запрос из предыдущего задания, но теперь колонки name и price переименуйте соответственно в product_name и product_price.
SELECT name as product_name,
       price as product_price
FROM products
ORDER BY price desc limit 5

--3.6
--Используя операторы SELECT, FROM, ORDER BY и LIMIT, а также функцию LENGTH, определите товар с самым длинным названием в таблице products. 
--Выведите его наименование, длину наименования в символах, а также цену этого товара. Колонку с длиной наименования в символах назовите name_length.
SELECT name,
       length(name) as name_length,
       price
FROM products
ORDER BY name_length desc limit 1

--3.7
--Примените последовательно функции UPPER и SPLIT_PART к колонке name и преобразуйте наименования товаров в таблице products так,
--чтобы от названий осталось только первое слово, записанное в верхнем регистре. Колонку с новым названием, состоящим из первого слова, назовите first_word.
--В результат включите исходные наименования товаров, новые наименования из первого слова, а также цену товаров. 
--Результат отсортируйте по возрастанию исходного наименования товара в колонке name.
SELECT upper(split_part(name,' ', 1)) as first_word,
       name,
       price
FROM products
ORDER BY name

--3.8
--Измените тип колонки price из таблицы products на VARCHAR. Выведите колонки с наименованием товаров, ценой в исходном формате и ценой в формате VARCHAR.
--Новую колонку с ценой в новом формате назовите price_char.
--Результат отсортируйте по возрастанию исходного наименования товара в колонке name. Количество выводимых записей не ограничивайте.
SELECT name,
       price,
       price :: varchar as price_char
FROM products
ORDER BY name

--3.9
--Для первых 200 записей из таблицы orders выведите информацию в следующем виде (обратите внимание на пробелы): Заказ № [id заказа] создан [дата]
--Полученную колонку назовите order_info.
SELECT concat('Заказ № ', order_id, ' создан ', creation_time::date) as order_info
FROM orders limit 200

--3.10
--Выведите id всех курьеров и их годы рождения из таблицы couriers.
--Год рождения необходимо получить из колонки birth_date. Новую колонку с годом назовите birth_year. 
--Результат отсортируйте сначала по убыванию года рождения курьера (т.е. от самых младших к самым старшим), затем по возрастанию id курьера.
SELECT courier_id,
       date_part ('year', birth_date) as birth_year
FROM couriers
ORDER BY birth_year desc, courier_id

--3.11
--Как и в предыдущем задании, снова выведите id всех курьеров и их годы рождения, только теперь к извлеченному году примените функцию COALESCE.
--Укажите параметры функции так, чтобы вместо NULL значений в результат попадало текстовое значение unknown. Названия полей оставьте прежними.
--Отсортируйте итоговую таблицу сначала по убыванию года рождения курьера, затем по возрастанию id курьера.
SELECT coalesce(cast(date_part('year', birth_date) as varchar),
                'unknown') as birth_year,
       courier_id
FROM couriers
ORDER BY birth_year desc, courier_id

--3.12
--повысить цену всех товаров в таблице products на 5%.
--Выведите id и наименования всех товаров, их старую и новую цену. Колонку со старой ценой назовите old_price, а колонку с новой — new_price.
--Результат отсортируйте сначала по убыванию новой цены, затем по возрастанию id товара.
SELECT name,
       product_id,
       price + ((price * 5)/100) as new_price,
       price as old_price
FROM products
ORDER BY new_price desc, product_id

--3.13
--повысьте цену всех товаров на 5%.
--Выведите id и наименования товаров, их старую цену, а также новую цену с округлением. Новую цену округлите до одного знака после запятой.
--Результат отсортируйте сначала по убыванию новой цены, затем по возрастанию id товара.
SELECT name,
       product_id,
       round(price + ((price * 5)/100), 1) as new_price,
       price as old_price
FROM products
ORDER BY new_price desc, product_id

--3.14
--Повысьте цену на 5% только на те товары, цена которых превышает 100 рублей. Цену остальных товаров оставьте без изменений. 
--Также не повышайте цену на икру, которая и так стоит 800 рублей. Выведите id и наименования всех товаров, их старую и новую цену. 
--Результат отсортируйте сначала по убыванию новой цены, затем по возрастанию id товара.
SELECT name,
       product_id,
       price as old_price,
       case when price <= 100 or name = 'икра' then price
            when price > 100 then price + ((price * 5)/100) 
       end as new_price
FROM products
ORDER BY new_price desc, product_id

--3.15
--Вычислите НДС каждого товара в таблице products и рассчитайте цену без учёта НДС.
--Выведите всю информацию о товарах, включая сумму налога и цену без его учёта.
--Колонки с суммой налога и ценой без НДС назовите соответственно tax и price_before_tax. 
--Округлите значения в этих колонках до двух знаков после запятой.
--Результат отсортируйте сначала по убыванию цены товара без учёта НДС, затем по возрастанию id товара.
SELECT product_id,
       name,
       price,
       round (price / 120 * 20, 2) as tax,
       round (price - (price / 120 * 20), 2) as price_before_tax
FROM products
ORDER BY price_before_tax desc, product_id