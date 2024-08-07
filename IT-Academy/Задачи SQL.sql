--1. 
--Выбрать все строки из таблицы с перевозчиками
SELECT * FROM Shippers;

--2.
--Выбрать первые три строки из таблицы с сотрудниками
SELECT * FROM Employees
Limit 3;

--3.
--Выбрать дни рождения, имена, фамилии из таблицы с сотрудниками, кол-во строк ограничить 3-мя
SELECT BirthDate, FirstName, LastName 
FROM Employees
Limit 3;

--4.
--Имена и фамилии сотрудников, родившихся в 1958г
SELECT FirstName, LastName
FROM Employees
WHERE BirthDate >= '1958-01-01' AND BirthDate <= '1958-12-31';

--5. 
--Все товары с ценой от 23 до 25
SELECT * FROM Products
WHERE Price BETWEEN 23 AND 25;

--6.
--Товар с минимальной ценой
SELECT * FROM Products
WHERE Price = (SELECT MIN(Price) FROM Products);

--7.
--Товар с максимальной ценой
SELECT * FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products);

--8.
--Товары у которых Unit '10 pkgs.'
SELECT * FROM Products
WHERE Unit = '10 pkgs.';

--9.
--Адреса поставщиков, которые проживают в одном из городов: Tokyo, Frankfurt, Osaka
SELECT Address
FROM Shippers
WHERE City IN ('Tokyo', 'Frankfurt', 'Osaka');

--10.
--Название товаров начинающихся с "G", у которых цена больше 37
SELECT ProductName
FROM Products
WHERE ProductName LIKE 'G%'
AND Price > 37;

--11.
--Список стран начинающихся на "S" и состоящих из 5 букв, из которых есть поставщики
SELECT Country
FROM Shippers
WHERE Country LIKE 'S____';

--12.
--Сумму всех товаров, в название которых есть "od", назвать Summ
SELECT SUM(Price) AS Summ
FROM Products
WHERE ProductName LIKE '%od%';

--13.
--Среднюю сумму товаров в бутылках, окгуглить до 2-х знаков после запятой, назвать Summ
SELECT ROUND(AVG(Price),2) AS Summ
FROM Products
WHERE Unit LIKE '%bottle%';

--14.
--Кол-во клиентов, которые не проживают в Франции и Германии, назвать Countt
SELECT COUNT(*)
FROM Customers
WHERE Country IS NOT ('France', 'Germany');

--15.
--Имена сотрудников, родившихся после 01.01.1968г. Отсортировать по имени
SELECT FirstName
FROM Employees
WHERE BirthDate > '1968-01-01'
ORDER BY FirstName;

--16.
--Названия товаров, где цена = 13 или 15. Отсортировать по возрастанию.
--Использовать Select команды с объединением результатов через Union
SELECT ProductName
FROM Products
WHERE Price = '13'
UNION SELECT ProductName
FROM Products
WHERE Price = '15'
ORDER BY ProductName;

--17.
--Имена товаров, в которых 3-я буква "m" и названия их поставщиков
SELECT ProductName, SupplierName
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID
WHERE ProductName LIKE '__m%';

--18.
--Имена и фамилии сотрудника, который оформил заказ 1996-11-27
--Написать 2-мя способами: через INNER JOIN и используя подзапрос
SELECT FirstName, LastName
FROM Employees
INNER JOIN Orders
ON Employees.EmployeeID = Orders.EmployeeID
WHERE OrderDate = '1996-11-27';

SELECT FirstName, LastName
FROM Employees
WHERE EmployeeID IN (SELECT EmployeeID FROM Orders WHERE OrderDate = '1996-11-27');

--19.
--Все товары, у которых поставщик "Grandma Kelly's Homestead" и цена > 27
SELECT ProductName, Price, SupplierName
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID
WHERE SupplierName LIKE 'Grandma%' AND Price > '27';

--20.
--Суммарное кол-во продукта "Queso Cabrales" (назвать Sumn), отправленного всем покупателям
--Написать 2-мя способами: через INNER JOIN и используя подзапрос
SELECT SUM(Quantity) AS Summ
FROM OrderDetails
INNER JOIN Products
ON OrderDetails.ProductID = Products.ProductID
WHERE ProductName LIKE 'Queso Cabrales';

SELECT SUM(Quantity) AS Summ
FROM OrderDetails
WHERE ProductID IN (SELECT ProductID FROM Products WHERE ProductName LIKE 'Queso Cabrales');

--21.
--Все заказы, которые были отправлены по адресу "Ekergatan 24" с их заказчиками и сотрудниками.
SELECT OrderID, CustomerName, FirstName, LastName
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Address LIKE 'Ekergatan 24';

--22.
--Преобразовать предыдущий запрос, чтобы LastName и FirstName выводилось в одну колонку.
SELECT OrderID, CustomerName, CONCAT (FirstName, ' ', LastName) AS EmployeeName
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Address LIKE 'Ekergatan 24';

--23
--Все продукты, в заказах 1997г и в название которых менее 5 букв
SELECT OD.OrderDate, ProductName
FROM OrderDetails OD
INNER JOIN Products
ON OD.ProductID = Products.ProductID
INNER JOIN Orders
ON OD.OrderID = Orders.OrderID
WHERE OrderDate >= '1997-01-01' AND OrderDate  <= '1997-01-30' 
AND ProductName LIKE '____';

--24
--Продукты и их категории, которые используются в заказах от заказчика Blondel pere et fils и категории которых состоят минимум из 2-х слов
SELECT CategoryName, ProductName
FROM Products
INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
INNER JOIN OrderDetails
ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders
ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.CustomerID IN (SELECT CustomerID FROM Customers WHERE CustomerName LIKE 'Blondel%')
AND CategoryName LIKE '_% _%';
