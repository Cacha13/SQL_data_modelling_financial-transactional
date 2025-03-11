create schema stage;

create table stage.country(
id serial PRIMARY KEY,
country varchar(100),
Constraint unique_country UNIQUE (id, country)
);

create table stage.city(
id serial PRIMARY KEY,
city varchar(100),
country_id integer,
Constraint unique_city UNIQUE (city, country_id),
Constraint fk_city_country Foreign key (country_id) References stage.country(id)
);

create table stage.client(
id serial PRIMARY KEY,
company VARCHAR(150),
first_name varchar(100),
last_name varchar(100),
email varchar(150),
phone_number varchar(25),
city_id integer,
Constraint unique_client UNIQUE (company, email),
Constraint fk_client_city Foreign key (city_id) REFERENCES stage.city(id)
);

create table stage.seller(
id serial PRIMARY KEY,
first_name varchar(100),
last_name varchar(100),
email varchar(150),
phone_number varchar(25),
Constraint unique_seller UNIQUE (email)
);

create table stage.product_group(
id serial PRIMARY KEY,
name varchar(100),
Constraint unique_product_group UNIQUE (name)
);

create table stage.product_subgroup(
id serial PRIMARY KEY,
name varchar(100),
group_id integer,
Constraint unique_subgroup UNIQUE (name, group_id),
CONSTRAINT fk_product_subgroup FOREIGN KEY (group_id) REFERENCES stage.product_group(id)
);

create table stage.product(
id serial PRIMARY KEY,
id_product varchar(30),
description varchar(200),
unit varchar(5),
sub_group_id integer,
Constraint unique_product UNIQUE (id_product, sub_group_id),
CONSTRAINT fk_product_subgroup FOREIGN KEY (sub_group_id) REFERENCES stage.product_subgroup(id)
);

create table stage.supplier(
id serial PRIMARY KEY,
company VARCHAR(150),
first_name varchar(100),
last_name varchar(100),
email varchar(150),
phone_number varchar(25),
city_id integer,
Constraint unique_supplier UNIQUE (company, email),
Constraint fk_supplier_city Foreign key (city_id) References stage.city(id)
);

create table stage.purchase_orders(
id serial PRIMARY key,
product_id integer,
badge_number varchar(30),
supplier_id integer,
price DECIMAL(10,2),
quantity decimal (10,2),
purchase_date date,
expire_date date,
Constraint fk_purchase_product Foreign key (product_id) References stage.product(id),
Constraint fk_purchase_supplier Foreign key (supplier_id) References stage.supplier(id)
);

create table stage.sales_orders(
id serial PRIMARY key,
product_id integer,
badge_number varchar(30),
client_id integer,
seller_id integer,
price DECIMAL(10,2),
quantity decimal (10,2),
sale_date date,
expire_date date,
Constraint fk_purchase_product Foreign key (product_id) References stage.product(id),
Constraint fk_purchase_client Foreign key (client_id) References stage.client(id),
Constraint fk_purchase_seller Foreign key (seller_id) References stage.seller(id)
);

create table stage.stock(
product_id integer,
purchase_id integer,
badge_number varchar(30),
expire_date date,
quantity decimal(10,2),
Constraint unique_stock_badge_number UNIQUE (product_id, badge_number),
Constraint fk_stock_product Foreign key (product_id) References stage.product(id),
Constraint fk_stock_purchase Foreign key (purchase_id) References stage.purchase_orders(id)
);


create schema dim_fact;

create table dim_fact.dim_city(
id serial PRIMARY KEY,
city varchar(100),
country_id integer,
country varchar(100),
Constraint fk_dim_city Foreign key (id) REFERENCES stage.city(id),
Constraint fk_dim_city_country Foreign key (country_id) References stage.country(id)
);

create table dim_fact.dim_client(
id serial PRIMARY KEY,
company VARCHAR(150),
city_id integer,
Constraint fk_dim_client Foreign key (id) References stage.client(id),
Constraint fk_dim_client_city Foreign key (city_id) REFERENCES dim_fact.dim_city(id)
);

create table dim_fact.dim_product(
id serial PRIMARY KEY,
id_product varchar(30),
description varchar(200),
sub_group_id integer,
sub_group varchar(100),
group_id integer,
category varchar(100),
Constraint fk_dim_product FOREIGN KEY (id) REFERENCES stage.product(id),
CONSTRAINT fk_dim_product_subgroup FOREIGN KEY (sub_group_id) REFERENCES stage.product_subgroup(id),
CONSTRAINT fk_dim_product_group FOREIGN KEY (group_id) REFERENCES stage.product_subgroup(id)
);

create table dim_fact.dim_seller(
id serial PRIMARY KEY,
first_name varchar(100),
last_name varchar(100),
Constraint fk_dim_seller Foreign key (id) References stage.seller(id)
);

create table dim_fact.dim_supplier(
id serial PRIMARY KEY,
company VARCHAR(150),
city_id integer,
Constraint fk_dim_supplier Foreign key (id) References stage.supplier(id),
Constraint fk_dim_supplier_city Foreign key (city_id) REFERENCES dim_fact.dim_city(id)
);

create table dim_fact.dim_time(
id serial PRIMARY KEY,
year_month date,
CONSTRAINT unique_dim_time UNIQUE (year_month)
);

create table dim_fact.fact_purchase(
product_id integer,
supplier_id integer,
time_id integer,
total_purchase_money decimal(10,2),
total_purchase_quantity decimal(12,2),
primary key (product_id, supplier_id, time_id),
Constraint fk_fact_purchase_product FOREIGN KEY (product_id) REFERENCES dim_fact.dim_product(id),
Constraint fk_fact_purchase_supplier FOREIGN KEY (supplier_id) REFERENCES dim_fact.dim_supplier(id),
Constraint fk_fact_purchase_time FOREIGN KEY (time_id) REFERENCES dim_fact.dim_time(id)
);

create table dim_fact.fact_sales(
product_id integer,
client_id integer,
seller_id integer,
time_id integer,
total_purchase_money decimal(10,2),
total_purchase_quantity decimal(12,2),
primary key (product_id, client_id, seller_id, time_id),
Constraint fk_fact_sales_product FOREIGN KEY (product_id) REFERENCES dim_fact.dim_product(id),
Constraint fk_fact_sales_client FOREIGN KEY (client_id) REFERENCES dim_fact.dim_client(id),
Constraint fk_fact_sales_seller FOREIGN KEY (seller_id) REFERENCES dim_fact.dim_seller(id),
Constraint fk_fact_sales_time FOREIGN KEY (time_id) REFERENCES dim_fact.dim_time(id)
);