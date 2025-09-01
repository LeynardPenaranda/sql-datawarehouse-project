# 📊 Data Catalog

This document describes the datasets available in the project.

---

# Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables**
and **fact tables** for specific business metrics.

<hr style="border: 2px solid black;" />

**1. gold.dim_customers**
 - **Purpose**: Stores customer details enriched with demographic and geographic data.
 - **Columns**:

| Column Name    | Data Type | Description |
|----------------|-----------|-------------|
| customer_key   | INT       | Surrogate key used as the primary identifier in the dimension table. It is system-generated (not from source data) and ensures uniqueness of each record. |
| customer_id    | INT       | Business or operational identifier for the customer, typically coming from the source system. Used for integration with other systems. |
| customer_number| NVARCHAR(50)   | Alphanumeric customer number often used in reports, invoices, or external references. |
| first_name     | NVARCHAR(50)   | The given name of the customer. |
| last_name      | NVARCHAR(50)   | The family or surname of the customer. |
| country        | NVARCHAR(50)   | The country where the customer resides or is registered.(e.g 'Australia') |
| marital_status | NVARCHAR(50)   | The marital status of the customer (e.g., Single, Married, Divorced). |
| gender         | NVARCHAR(50)   | The gender of the customer (e.g., Male, Female, Non-binary). |
| birthdate      | DATE      | The date of birth of the customer, useful for age-based analytics. (e.g '1971-10-06')|
| create_date    | DATE      | The date when the customer record was first created in the system. Often used for tracking data freshness or customer onboarding date. |


**2. gold.dim_products**
 - **Purpose**: Stores product details, including categorization, cost, and lifecycle information. This dimension is used to analyze sales, profitability, and product performance across categories and time periods.
 - **Columns**:

| Column Name    | Data Type     | Description |
|----------------|---------------|-------------|
| product_key    | INT           | Surrogate key used as the primary identifier in the dimension table. It is system-generated to uniquely identify each product record. |
| product_id     | INT           | Business or operational identifier for the product, typically coming from the source system. |
| product_number | NVARCHAR(50)  | Alphanumeric product number often used in catalogs, invoices, or ERP systems. |
| product_name   | NVARCHAR(100) | The name of the product as shown in listings, catalogs, or reports. |
| category_id    | INT           | Identifier linking the product to its category. Useful for joining with category-related tables. |
| category       | NVARCHAR(50)  | The main category the product belongs to (e.g., Electronics, Apparel). |
| subcategory    | NVARCHAR(50)  | A more specific grouping within the category (e.g., Smartphones under Electronics). |
| maintenance    | NVARCHAR(50)  | Indicates whether the product requires ongoing maintenance or has a service plan (e.g., 'Yes', 'No'). |
| product_cost   | INT | The cost of producing or procuring the product, often used for margin and profitability calculations. |
| product_line   | NVARCHAR(50)  | A higher-level grouping that represents a collection of related products (e.g., 'Road, Mountain'). |
| start_date     | DATE          | The date when the product became available or active in the system. Useful for product lifecycle tracking. |

**3. gold.fact_sales**
 - **Purpose**: Stores transactional sales data at the order line level. This fact table links products and customers through surrogate keys and provides the measures necessary for sales performance, revenue, and profitability analysis.
 - **Columns**:

| Column Name    | Data Type     | Description |
|----------------|---------------|-------------|
| order_number   | NVARCHAR(50)  | The unique business identifier for the sales order. Can be used to group multiple line items belonging to the same order. |
| product_key    | INT (FK)      | Foreign key referencing **gold.dim_products**. Identifies the product being sold. |
| customer_key   | INT (FK)      | Foreign key referencing **gold.dim_customers**. Identifies the customer who placed the order. |
| order_date     | DATE          | The date when the order was created or confirmed. Used for trend and time-series analysis. |
| shipping_date  | DATE          | The date when the order was shipped to the customer. Useful for logistics and delivery performance analysis. |
| due_date       | DATE          | The date by which the order is expected to be delivered or fulfilled. Useful for SLA and commitment tracking. |
| sales_amount   | DECIMAL(18,2) | The total monetary value of the sale (quantity × price). Used as the primary revenue measure. |
| quantity       | INT           | The number of units sold for the given product line item. |
| price          | INT | The unit price of the product at the time of sale. Helps derive discounts, margins, and average selling prices. |

