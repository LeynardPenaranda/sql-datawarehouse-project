# 📊 Data Warehouse and Analytics Project  

First and foremost, I want to give credit to **Sir Baraa Khatib Salkini** for this wonderful course. 🙏  

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution — from building a data warehouse to generating actionable insights.  

It’s designed as a **portfolio project** that highlights industry best practices in **Data Engineering** and **Analytics**.  

---

## 📌 Project Requirements  

### ⚙️ Building the Data Warehouse (Data Engineering)  

**🎯 Objective**  
Develop a modern data warehouse using **SQL Server** to consolidate sales data, enabling analytical reporting and informed decision-making.  

**📝 Specifications**  
- 📂 **Data Sources**: Import data from two source systems (ERM and CRM) provided as CSV files.  
- 🧹 **Data Quality**: Cleanse and resolve data quality issues prior to analysis.  
- 🔗 **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.  
- 🎯 **Scope**: Focus on the latest dataset only (historization of data is not required).  
- 📖 **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.  

---

### 📊 BI: Analytics & Reporting (Data Analytics)  

**🎯 Objective**  
Develop SQL-based analytics to deliver detailed insights into:  
- 👥 **Customer Behavior**  
- 📦 **Product Performance**  
- 💰 **Sales Trends**  

These insights empower stakeholders with **key business metrics**, enabling strategic decision-making.  

---

## 🛡️ License  
This project is licensed under the **MIT License**.  
You are free to use and modify this project with proper attribution.  

---

## 🙋 About Me  

Hi there! 👋  
I'm **Leynard M. Peñaranda**, a student passionate about **Data Engineering** and eager to keep learning, building, and growing. 🌱  

---

# 🏗️ Data Architecture  

The data architecture for this project follows the **Medallion Architecture** with **Bronze, Silver, and Gold layers**:  

![Data Architecture](https://github.com/LeynardPenaranda/sql-datawarehouse-project/blob/main/docs/Data%20Architecture.png?raw=true)  

- 🥉 **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into SQL Server.  
- 🥈 **Silver Layer**: Cleansing, standardization, and normalization processes prepare data for analysis.  
- 🥇 **Gold Layer**: Houses business-ready data modeled into a **star schema** for reporting and analytics.  

---

# 🔄 Data Integration  

To understand the data integration between the different tables and see their relationships, the following model illustrates the architecture:  

![Integration Data Model](https://github.com/LeynardPenaranda/sql-datawarehouse-project/blob/main/docs/Integration%20Data%20Model.png?raw=true)  

---

# 🗄️ Sales Data Mart Model  

After creating the **Bronze Layer** (raw data) and the **Silver Layer** (transformed data), the **Gold Layer** models the data into a **star schema** with fact and dimension tables.  

📌 **Data Mart Model**:  
![Sales Data Mart Model](https://github.com/LeynardPenaranda/sql-datawarehouse-project/blob/main/docs/Sales%20Data%20Mart%20Model.png?raw=true)  

📌 **Data Flow Diagram**:  
![Data Flow Diagram](https://github.com/LeynardPenaranda/sql-datawarehouse-project/blob/main/docs/Data%20Flow%20Diagram.png?raw=true)  
