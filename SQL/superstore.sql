CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100) NOT NULL,
segment VARCHAR(50) NOT NULL,
city VARCHAR(100) NOT NULL,
state VARCHAR(100) NOT NULL,
region VARCHAR(50) NOT NULL
);

CREATE TABLE products (
product_id INT PRIMARY KEY,
product_Name VARCHAR(150) NOT NULL,
category VARCHAR(100) NOT NULL,
sub_category VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
order_id INT PRIMARY KEY,
order_date DATE NOT NULL,
customer_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
unit_Price DECIMAL(10,2) NOT NULL,
discount DECIMAL(5,2) DEFAULT 0,

FOREIGN KEY (customer_id)
REFERENCES customers(customer_id),

FOREIGN KEY (product_id)
REFERENCES products(product_id)

);

create table sales(
sale_id int primary key,
order_id int references orders(order_id),
sales_amount decimal(10,2),
profit decimal(10,2)
);

INSERT INTO customers VALUES
(1,'Ahmed Ali','Consumer','Cairo','Cairo','North'),
(2,'Sara Mohamed','Corporate','Giza','Giza','North'),
(3,'Omar Hassan','Home Office','Alexandria','Alexandria','West'),
(4,'Mona Adel','Consumer','Mansoura','Dakahlia','East'),
(5,'Youssef Samy','Corporate','Tanta','Gharbia','East'),
(6,'Nour Ahmed','Consumer','Luxor','Luxor','South'),
(7,'Ali Mahmoud','Home Office','Aswan','Aswan','South'),
(8,'Salma Khaled','Consumer','Cairo','Cairo','North'),
(9,'Mostafa Hassan','Corporate','Alexandria','Alexandria','West'),
(10,'Aya Ibrahim','Home Office','Giza','Giza','North');

INSERT INTO products VALUES
(101,'Laptop','Technology','Computers'),
(102,'Mouse','Technology','Accessories'),
(103,'Keyboard','Technology','Accessories'),
(104,'Office Chair','Furniture','Chairs'),
(105,'Office Desk','Furniture','Tables'),
(106,'Printer','Technology','Machines'),
(107,'Notebook','Office Supplies','Paper'),
(108,'Pen Set','Office Supplies','Art'),
(109,'Monitor','Technology','Computers'),
(110,'Bookshelf','Furniture','Storage');

INSERT INTO orders
(order_id,order_date,customer_id,
product_id,quantity,unit_price,discount) VALUES
(1001,'2024-01-05',1,101,1,1200,0.10),
(1002,'2024-01-08',2,104,2,300,0.05),
(1003,'2024-01-10',3,107,5,20,0.00),
(1004,'2024-01-12',4,102,3,25,0.05),
(1005,'2024-01-15',5,105,1,450,0.10),
(1006,'2024-01-18',6,109,2,350,0.15),
(1007,'2024-01-20',7,103,4,50,0.00),
(1008,'2024-01-22',8,108,6,15,0.05),
(1009,'2024-01-25',9,106,1,500,0.10),
(1010,'2024-01-28',10,110,1,250,0.00),
(1011,'2024-02-02',1,102,2,25,0.00),
(1012,'2024-02-05',2,109,1,350,0.05),
(1013,'2024-02-08',3,104,1,300,0.10),
(1014,'2024-02-10',4,107,10,20,0.00),
(1015,'2024-02-12',5,101,1,1200,0.15),
(1016,'2024-02-15',6,105,2,450,0.10),
(1017,'2024-02-18',7,108,8,15,0.00),
(1018,'2024-02-20',8,106,1,500,0.05),
(1019,'2024-02-22',9,103,3,50,0.00),
(1020,'2024-02-25',10,110,2,250,0.10);


INSERT INTO sales VALUES
(1,1001,1080.00,250.00),
(2,1002,570.00,120.00),
(3,1003,100.00,25.00),
(4,1004,71.25,15.00),
(5,1005,405.00,90.00),
(6,1006,595.00,110.00),
(7,1007,200.00,40.00),
(8,1008,85.50,20.00),
(9,1009,450.00,95.00),
(10,1010,250.00,60.00),
(11,1011,50.00,10.00),
(12,1012,332.50,70.00),
(13,1013,270.00,55.00),
(14,1014,200.00,50.00),
(15,1015,1020.00,220.00),
(16,1016,810.00,180.00),
(17,1017,120.00,25.00),
(18,1018,475.00,100.00),
(19,1019,150.00,35.00),
(20,1020,450.00,90.00);


select round(sum(sales_amount)) as sum_of_sales from sales;
select round(avg(sales_amount)) as avg_of_sales from sales;
select count(*) as total_orders from orders;


SELECT c.customer_name, sum(s.sales_amount) as sum_of_sales_amount
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN sales s
    ON o.order_id = s.order_id
    group by c.customer_name
    order by sum_of_sales_amount desc;
    

select p.product_name,sum(s.sales_amount) as total_sales 
from products p join orders o
on p.product_id = o.product_id 
join sales s 
on o.order_id = s.order_id group by p.product_name
order by total_sales desc; 

select p.category,sum(s.sales_amount) as total_sales
from products p join orders o 
on p.product_id = o.product_id
join sales s
on s.order_id = o.order_id
group by p.category
order by total_sales desc;

select c.region,sum(s.sales_amount) as total_sales
from customers c join orders o
on c.customer_id = o.customer_id
join sales s
on s.order_id = o.order_id
group by c.region
order by total_sales desc;

select c.region,sum(s.profit) as total_profit
from customers c join orders o
on c.customer_id = o.customer_id
join sales s
on o.order_id = s.order_id
group by c.region
order by total_profit desc;


select date_format(o.order_date,'%M') as month,
sum(s.sales_amount) as total_sales
from orders o join sales s
on o.order_id = s.order_id
group by date_format(o.order_date,'%M')
order by total_sales desc;

select p.sub_category,sum(s.sales_amount) as total_sales
from products p join orders o
on p.product_id = o.product_id
join sales s
on o.order_id = s.order_id
group by p.sub_category
order by total_sales desc;

select date_format(o.order_date,'%M') as month,
sum(s.profit) as total_profit from orders o join sales s
on o.order_id = s.order_id
group by date_format(o.order_date,'%M')
order by total_profit desc;

select c.segment,sum(s.sales_amount) as total_sales
from customers c join orders o
on c.customer_id = o.customer_id
join sales s 
on o.order_id = s.order_id
group by c.segment
order by total_sales desc;

select c.state,sum(s.sales_amount) as total_sales
from customers c join orders o
on c.customer_id = o.customer_id
join sales s
on o.order_id = s.order_id
group by c.state
order by total_sales desc;