-- SQL in 10 minutes

#SELECT prod_name FROM Products LIMIT 1 OFFSET 0;
-- 在Products中选择prod_name的第0行开始共1行数据（行的编号从0开始）

#lesson3，ORDER
#SELECT prod_name FROM Products ORDER BY prod_name;
-- 默认按prod_name升序排列；

#SELECT prod_id, prod_price, prod_name FROM Products ORDER BY prod_price, prod_name;
-- 先后按照prod_price,prod_name升序排列；

#SELECT prod_id, prod_price, prod_name FROM Products ORDER BY prod_price DESC, prod_name DESC;
-- 按照prod_price和prod_name降序排列；

#lesson4, WHERE
#SELECT prod_name, prod_price FROM Products WHERE prod_price = 3.49;
-- 选择prod_price为3.49的行；

#SELECT prod_name, prod_price FROM Products WHERE prod_price = 3.49 ORDER BY prod_name;
-- 选择prod_price为3.49的行,并且按照prod_name 升序排列

#SELECT prod_name, prod_price FROM Products WHERE prod_price <10;
#SELECT prod_name, prod_price FROM Products WHERE prod_price BETWEEN 5 AND 10;
#SELECT prod_name FROM Products WHERE prod_price IS NULL;
#SELECT cust_name FROM Customers WHERE cust_email IS NULL;

#lesson5,高级过滤AND，OR，IN
#SELECT prod_id, prod_price, prod_name, vend_id FROM Products WHERE prod_price <10 AND vend_id='DLL01';
#SELECT prod_id, prod_price, prod_name, vend_id FROM Products WHERE prod_price <10 OR vend_id='DLL01';

#SELECT prod_id, prod_price, prod_name, vend_id FROM Products WHERE vend_id = 'DLL01' OR vend_id = 'BRS01' AND prod_price >=10;
#SELECT prod_id, prod_price, prod_name, vend_id FROM Products WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01') AND prod_price >=10;
-- 这两句表明AND的优先级高于OR，AND被先运算；

#SELECT prod_id, prod_price, prod_name, vend_id FROM Products WHERE vend_id IN ('DLL01','BRS01') ORDER BY prod_price;
#SELECT prod_id, prod_price, prod_name, vend_id FROM Products WHERE NOT vend_id = 'DLL01' ORDER BY prod_price;
-- NOT可以否定任何语句，比不等号用处更广，IN 其实隐含有OR的意思

#lesson6，通配符过滤
#SELECT prod_id, prod_name FROM PRoducts WHERE prod_name LIKE 'Fish%';
-- 匹配以Fish 开头的名字，区分大小写；

#SELECT prod_id, prod_name FROM Products WHERE prod_name LIKE '%bean bag%';
-- 匹配任何位置包含bean bag的值；
-- %可以匹配0个至任意个字符，但不能匹配NULL

#SELECT prod_id,prod_name FROM Products WHERE prod_name LIKE '__ inch teddy bear';
-- _只匹配单个字符；

#SELECT cust_contact FROM Customers WHERE cust_contact LIKE '[JM]%' ORDER BY cust_contact;
-- MySQL没有方括号通配符[]，这句不能执行；

#lesson7 创建计算字段
#SELECT concat(vend_name,'(',vend_country, ')') FROM vendors ORDER BY vend_name;

#SELECT concat(vend_name,'(',vend_country, ')') AS vend_title FROM vendors ORDER BY vend_name;
-- 组合字段并作为可供客户端使用的列

#SELECT order_num, prod_id, quantity, item_price, quantity*item_price AS expanded_price FROM OrderItems WHERE order_num = 20008;

#lesson8 使用函数
-- 文本处理
#SELECT vend_name, UPPER(vend_name) AS vend_name_upcase FROM Vendors ORDER BY vend_name;
-- 使用upper大写函数
#SELECT cust_name, cust_contact FROM Customers WHERE SOUNDEX(cust_contact) = SOUNDEx('Michael Green');
-- 提取发音相似的文本

-- 日期时间处理,MySQL 中似乎没有
#SELECT prod_name, prod_price, ABS(prod_price) as abs_price FROM Products ORDER BY prod_name;

#lesson9 汇总数据
-- 聚集函数
#SELECT AVG(prod_price) AS avg_price FROM Products;
#SELECT MAX(prod_price) AS max_price FROM Products;

#SELECT COUNT(cust_email) as num_cust FROM Customers;
#SELECT SUM(item_price*quantity) AS items_ordered FROM OrderItems WHERE order_num = 20005;
-- 不同值聚集函数,加了DISTINCT 只聚集一次
#SELECT AVG(prod_price) AS avg_price FROM Products WHERE vend_id = 'DLL01';
#SELECT AVG(DISTINCT prod_price) AS avg_price FROM Products WHERE vend_id = 'DLL01';
-- 多个聚集计算函数
#SELECT COUNT(*) AS num_items, MIN(prod_price) AS price_min, MAX(prod_price) AS price_max, AVG(prod_price) AS price_avg FROM Products;

#lesson 10 过滤分组
#SELECT COUNT(*) AS num_prods FROM Products WHERE vend_id = 'DLL01';
#SELECT vend_id, COUNT(*) AS num_prods FROM Products GROUP BY vend_id;

-- HAVING是先分组再过滤
#SELECT cust_id, COUNT(*) AS orders FROM Orders GROUP BY cust_id;
#SELECT cust_id, COUNT(*) AS orders FROM Orders GROUP BY cust_id  HAVING COUNT(*) >=2;

#SELECT vend_id, prod_price,COUNT(*) AS num_prods FROM Products  GROUP BY vend_id HAVING COUNT(*) >=2;
#SELECT vend_id, prod_price,COUNT(*) AS num_prods FROM Products WHERE prod_price >=4 GROUP BY vend_id HAVING COUNT(*) >=2;

#SELECT order_num FROM OrderItems WHERE prod_id = 'RGAN01';
#SELECT cust_id FROM Orders WHERE order_num IN (20007,20008);

#lesson11 子查询
/*
SELECT cust_id
FROM orders
WHERE order_num IN (SELECT order_num
					FROM OrderItems
                    WHERE prod_id = 'RGAN01');*/

/*
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (SELECT cust_id
				  FROM orders
                  WHERE order_num IN (SELECT order_num
									  FROM orderitems
                                      WHERE prod_id='RGAN01'));*/

 -- 计算字段的子查询
 /*
SELECT cust_name,
	   cust_state,
       (SELECT COUNT(*)
       FROM orders 
       WHERE orders.cust_id = customers.cust_id) AS orders
FROM customers
ORDER BY cust_name;*/

#lesson12 创建联结
-- 创建两个表对应的列的联结
#SELECT vend_name,prod_name,prod_price FROM vendors,products WHERE vendors.vend_id=products.vend_id;

#SELECT vend_name,prod_name,prod_price FROM vendors,products
-- 返回笛卡尔积，

/*
-- 内联结方式
SELECT vend_name, prod_name, prod_price 
FROM vendors INNER JOIN products
ON vendors.vend_id=products.vend_id*/

-- 联结多个表
/*
SELECT prod_name, vend_name, prod_price, quantity
FROM OrderItems, Products, Vendors
WHERE Products.vend_id = vendors.vend_id
 AND orderitems.prod_id =  products.prod_id
 AND order_num = 20007; */
 
 #lesson13
 -- 相当于利用多个表查找，从customers中找到prod_id是BGAN01的行
 /*
 SELECT cust_name, cust_contact
 FROM customers AS C, orders AS O, OrderItems AS OI
 WHERE C.cust_id = O.cust_id
  AND OI.order_num=O.order_num
  AND prod_id='RGAN01';*/
 
 -- 选择与Jim Jones同一公司的顾客的id name等信息
 -- 使用子查询
/*SELECT cust_id,cust_name,cust_contact
  FROM customers
  WHERE cust_name = (SELECT cust_name
					 FROM customers
                     WHERE cust_contact='Jim Jones');*/

-- 使用内联结
/*
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM customers as c1, customers as c2
WHERE c1.cust_name = c2.cust_name
 AND c2.cust_contact = 'Jim Jones';*/
 
-- 使用自然联结
-- 选择customers的所有列以及 O的两列和 OI的三列；过滤条件是 通过prod_id 为RGAN01找到对应的订单号，在找到对应的消费者id,然后输出对应的行和组合的列
/*
SELECT C.*, O.order_num, O.order_date, 
		OI.prod_id, OI.quantity, OI.item_price
FROM customers AS C, orders AS O, orderitems AS OI
WHERE C.cust_id = O.cust_id
 AND OI.order_num = O.order_num
 AND prod_id = 'RGAN01'; */

-- 外联结，包含满足条件的行和没有关联行的那些行
/* 
SELECT customers.cust_id, orders.order_num
FROM customers INNER JOIN orders
  ON customers.cust_id = orders.cust_id;

/*SELECT customers.cust_id, orders.order_num
FROM customers LEFT OUTER JOIN orders
  ON customers.cust_id = orders.cust_id;*/

-- 返回每个顾客和每个顾客的下单数  
/*SELECT customers.cust_id,
       COUNT(orders.order_num) AS num_ord
FROM customers INNER JOIN orders
ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_id;*/

#lesson14 组合查询
-- 组合查询，本条语句相当于WHERE OR的效果
/*SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_state IN('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_name = 'Fun4ALL' 
ORDER BY cust_name, cust_contact;*/

#lesson15 插入
-- 插入完整的行
/*
INSERT INTO customers
VALUES('1000000006' ,
       'Toy Land' ,
       '123 Any Street', 
       'New York',
       'NY',
       '11111',
       'USA', 
       NULL, 
       NULL);*/
-- 插入部分行
/*
INSERT INTO customers(cust_id,
					  cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip,
                      cust_country)
VALUES('1000000007',
       'Joel Wang',
       'Friendship Street',
       'Xian',
       'SX',
       '55555',
       'CN');*/
#SELECT * FROM customers;

#CREATE TABLE custcopy AS SELECT * FROM customers;
#SELECT * FROM custcopy;

#lesson16 更新和删除数据
-- 更新
/*
UPDATE customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id='1000000005';

SELECT * FROM customers;*/

/*
UPDATE customers
SET cust_contact = 'Sam Roberts',
    cust_email = 'sam@toyland.com'
WHERE cust_id = '1000000006';

SELECT * FROM customers;*/

-- 删除
/*
DELETE FROM customers
WHERE cust_id = '1000000006';
SELECT * FROM customers;*/

#lesson17 创建操作表
-- 创建表
-- 创建products2
/*
CREATE TABLE tmp
(
    prod_id			CHAR(10)		NOT NULL,
    vend_id			CHAR(10)		NOT NULL,
    prod_name		CHAR(254)		NOT NULL,
    prod_price		DECIMAL(8,2)	NOT NULL,
    prod_desc		VARCHAR(1000)	NULL
);
SELECT * FROM tmp;*/
/*
CREATE TABLE products2
(
    prod_id			CHAR(10)		NOT NULL,
    vend_id			CHAR(10)		NOT NULL,
    prod_name		CHAR(254)		NOT NULL,
    prod_price		DECIMAL(8,2)	NOT NULL,
    prod_desc		VARCHAR(1000)	NULL
);
SELECT * FROM products2;*/

-- 创建orders2
/*
CREATE TABLE orders2
(
	order_num		INTEGER		NOT NULL,
    order_date		DATETIME	NOT NULL,
    cust_id			CHAR(10)	NOT NULL
);
SELECT * FROM orders2;*/

-- 创建vendors2
/*
CREATE TABLE vendors2
(
	vend_id			CHAR(10)		NOT NULL,
    vend_name		CHAR(50)		NOT NULL,
    vend_address	CHAR(50)		,
    vend_city		CHAR(50)		,
    vend_state		CHAR(5)			,
    vend_zip		CHAR(10)		,
    vend_country	CHAR(50)		
);
SELECT * FROM vendors2;*/

-- 创建orderitems2
/*
CREATE TABLE orderitems2
(
	order_num		INTEGER			NOT NULL,
    order_item		INTEGER			NOT NULL,
    prod_id			CHAR(10)		NOT NULL,
    quantity		INTEGER			NOT NULL		DEFAULT 1,
    item_price		DECIMAL(8,2)	NOT NULL
);
SELECT * FROM orderitems2;*/

-- vendors2增加vend_phone列
#SELECT * FROM vendors2;
/*
ALTER TABLE vendors2
ADD vend_phone CHAR(20);
SELECT * FROM vendors2;*/
/*
ALTER TABLE vendors2
DROP COLUMN vend_phone;
SELECT * FROM vendors2;*/

#lesson18 视图
-- 创建视图
/*
CREATE VIEW ProductsCustomers AS
SELECT cust_name, cust_contact, prod_id
FROM customers,orders,orderitems
WHERE customers.cust_id = orders.cust_id
AND orderitems.order_num = orders.order_num;*/

#SELECT * FROM productscustomers;

/*SELECT cust_name, cust_contact
FROM ProductsCustomers
WHERE prod_id = 'RGAN01';*/

-- 视图过滤
/*
CREATE VIEW CustomerEmailList AS
SELECT cust_id,cust_name, cust_email
FROM customers
WHERE cust_email IS NOT NULL;
SELECT * FROM customeremailList;*/

-- 视图与计算字段
/*
CREATE VIEW OrderItemsExpanded AS
SELECT prod_id,
	   quantity,
       item_price,
       quantity*item_price AS expanded_price
FROM orderitems
WHERE order_num=20008;
SELECT *FROM orderitemsexpanded;*/

#lesson19 存储过程
#MySQL 似乎不能直接执行；
/*EXECUTE AddNewProduct('JTS01'
					  'Stuffed Eiffel Tower',
                      6.49,
                      'Plush stuffed toy with the text La Tour Eiffel in red white and blue');
#SELECT * FROM products;*/

#lesson 20 控制事物处理
#MySQL 似乎不能直接执行；
/*DROP TABLE orders2;*/
#DROP TABLE vendors2;
#ROLLBACK;

/*SET TRANSACTION
DELETE orderitems2 WHERE order_num = 12345;
COMMIT;*/
