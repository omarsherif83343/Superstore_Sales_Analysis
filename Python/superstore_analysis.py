import mysql.connector as sql
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

connect = sql.connect(host = "localhost",user="root",password="omarahmed123@",database="superstore_db")
cursor = connect.cursor()
statement = "select * from customers"
cursor.execute(statement)
customer_fetch = cursor.fetchall()
customer_column = [col[0] for col in cursor.description]
customer_df = pd.DataFrame(customer_fetch,columns = customer_column)

#----------------------------------------------------------------------------------

statement2 = "select * from products"
cursor.execute(statement2)
product_fetch = cursor.fetchall()
product_column = [col[0] for col in cursor.description]
product_df = pd.DataFrame(product_fetch,columns = product_column)

#---------------------------------------------------------------------------------

statement3 = "select * from orders"
cursor.execute(statement3)
order_fetch = cursor.fetchall()
order_column = [col[0] for col in cursor.description]
order_df = pd.DataFrame(order_fetch,columns = order_column)

#--------------------------------------------------------------------------------

statement4 = "select * from sales"
cursor.execute(statement4)
sales_fetch = cursor.fetchall()
sales_column = [col[0] for col in cursor.description]
sales_df = pd.DataFrame(sales_fetch,columns = sales_column)

#--------------------------------------------------------------------------------

print(customer_df.info())
print(product_df.info())
print(order_df.info())
print(sales_df.info())

#--------------------------------------------------------------------------------

print(customer_df.isnull().sum())
print(product_df.isnull().sum())
print(order_df.isnull().sum())
print(sales_df.isnull().sum())

#-------------------------------------------------------------------------------

print(customer_df.describe(include="all"))
print(product_df.describe(include="all"))
print(order_df.describe(include="all"))
print(sales_df.describe(include="all"))

#------------------------------------------------------------------------------

#Data Cleaning

customer_df.drop_duplicates(inplace = True)
product_df.drop_duplicates(inplace = True)
order_df.drop_duplicates(inplace = True)
sales_df.drop_duplicates(inplace = True)

customer_df.dropna(inplace = True)
product_df.dropna(inplace = True)
order_df.dropna(inplace = True)
sales_df.dropna(inplace = True)


#------------------------------------------------------------------------------

#KPI'S

total_sales = sales_df["sales_amount"].sum()
total_profit = sales_df["profit"].sum()
total_orders = order_df["order_id"].count()
total_customers = customer_df["customer_id"].count()

print(total_sales)
print(total_profit)
print(total_orders)
print(total_customers)

#----------------------------------------------------------------------------

#Visualizations


product_orders_df = product_df.merge(order_df,on="product_id")
products_orders_sales_df = product_orders_df.merge(sales_df,on="order_id")
products_orders_sales_df["sales_amount"] = pd.to_numeric(products_orders_sales_df["sales_amount"])
full_data_df = products_orders_sales_df.merge(customer_df,on="customer_id")
top_products = products_orders_sales_df.groupby("product_Name")["sales_amount"].sum().sort_values(ascending = False)
plt.figure(figsize=(15,6))
top_products.plot(kind="bar")
plt.title("Top Products")

plt.xlabel("Product Name")
plt.xticks(rotation=0)
plt.ylabel("Sales Amount")
plt.savefig("top_products.png")
plt.show()




top_customers = full_data_df.groupby("customer_name")["sales_amount"].sum().sort_values(ascending = False)
plt.figure(figsize=(15,6))
top_customers.plot(kind="bar",color = "purple")
plt.title("Top Customers")
plt.xlabel("Customer Name")
plt.xticks(rotation=0)
plt.ylabel("Sales Amount")
#plt.savefig("top_customers.png")
plt.show()




sales_by_category = full_data_df.groupby("category")["sales_amount"].sum().sort_values(ascending = False)
plt.figure(figsize=(15,6))
sales_by_category.plot(kind="bar",color = "red")
plt.title("Sales by Category")
plt.xlabel("Category Name")
plt.xticks(rotation=0)
plt.ylabel("Sales Amount")
#plt.savefig("sales_by_category.png")
plt.show()




sales_by_region = full_data_df.groupby("region")["sales_amount"].sum().sort_values(ascending = False)
plt.figure(figsize=(15,6))
sales_by_region.plot(kind="bar",color = "pink")
plt.title("Sales by Region")
plt.xlabel("Region Name")
plt.xticks(rotation=0)
plt.ylabel("Sales Amount")
#plt.savefig("sales_by_region.png")
plt.show()




full_data_df["order_date"] = pd.to_datetime(full_data_df["order_date"])

full_data_df["month"] = full_data_df["order_date"].dt.month_name()
full_data_df["year"] = full_data_df["order_date"].dt.year
full_data_df["quarter"] = full_data_df["order_date"].dt.quarter

monthly_sales_trend = full_data_df.groupby("month")["sales_amount"].sum()
months_order = ["January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"]
monthly_sales_trend = monthly_sales_trend.reindex(months_order).dropna()
plt.figure(figsize=(15,6))
monthly_sales_trend.plot(kind="line",marker="o",linewidth=2)
plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Sales Amount")
plt.xticks(
    ticks=range(len(monthly_sales_trend.index)),
    labels=monthly_sales_trend.index,
    rotation=0
)
plt.grid(axis="y",linestyle="--",alpha=0.5)
#plt.savefig("monthly_sales_trend.png")
plt.show()




full_data_df["profit"] = pd.to_numeric(full_data_df["profit"])
monthly_profit_trend = full_data_df.groupby("month")["profit"].sum()
months_order_profit = ["January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"]
monthly_profit_trend = monthly_profit_trend.reindex(months_order_profit).dropna()
plt.figure(figsize=(15,6))
monthly_profit_trend.plot(kind="line",marker="o",linewidth=2)
plt.title("Monthly Profit Trend")
plt.xlabel("Month")
plt.ylabel("Profit Amount")
plt.xticks(
    ticks=range(len(monthly_profit_trend.index)),
    labels=monthly_profit_trend.index,
    rotation=0
)
plt.grid(axis="y",linestyle="--",alpha=0.5)
plt.savefig("profit_trend.png")
plt.show()



segment_by_sales = full_data_df.groupby("segment")["sales_amount"].sum()
plt.figure(figsize=(15,6))
plt.pie(segment_by_sales,autopct="%1.1f%%",startangle=90)
plt.title("Sales By Segment")
plt.legend(labels = segment_by_sales.index,title = "Segment",loc="best")
#plt.savefig("sales_by_segment.png")
plt.show()

full_data_df.to_excel("superstore.xlsx",index=False)