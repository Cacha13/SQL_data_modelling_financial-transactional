# SQL_data_modelling_financial-transactional

Database Schema Documentation
For this project I used PostgreSQL

Overview

This database is designed for managing financial transactions related to product purchases and sales. It follows a star schema approach, separating dimensional and fact tables for efficient querying and analysis. The schema consists of two primary sections:

Fact and Dimension Tables (dim_fact)
Staging Tables (stage)

In the last updated, I created 2 procedures for the tables fact_purchase and fact_sales with the arguments (year, month).
Also created I procedure to insert new clients in the dim_client and a function_trigger to everytime that is inserted a new client in the table client trigger the procedure to insert in the new_client in the dim_client.
