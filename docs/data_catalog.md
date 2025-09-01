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

