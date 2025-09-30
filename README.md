# 📡 JIO Problem – SQL Analysis Project

This project simulates a real-world telecom data environment inspired by Jio, one of India's largest telecom providers. The goal is to analyze customer behavior, data usage, and recharge patterns using SQL. It includes 3 connected datasets and 20 default + tricky SQL questions to practice intermediate and advanced query techniques.

---

## 📁 Project Structure

📦 JIO_Problem_SQL_Project/
├── jio_customers.csv # Customer details
├── jio_data_usage.csv # Daily data usage logs
├── jio_recharges.csv # Recharge history  
├── Jio_analysis_sql.sql # All 20 solved SQL queries   
├── README.md # Project documentation



---

## 📊 Datasets Overview

### 1. `customers`
Customer details with device type, SIM type, city, and referral info.  

| Column Name   | Description                      |
|---------------|----------------------------------|
| customer_id   | Unique ID for each customer      |
| name          | Full name                        |
| gender        | Male/Female/Other                |
| age           | Age in years                     |
| city          | City name                        |
| sim_type      | Prepaid/Postpaid                 |
| join_date     | SIM activation date              |
| is_active     | Boolean - active user or not     |
| device_type   | Android / iOS / Feature phone    |
| referred_by   | Referral customer ID (nullable)  |

### 2. `data_usager`
Daily usage tracking including GB consumed and app used.

| Column Name   | Description                       |
|----------------|-----------------------------------|
| usage_id       | Record ID                         |
| customer_id    | Linked customer                   |
| date           | Usage date                        |
| gb_used        | Data used in GB                   |
| app_most_used  | YouTube, WhatsApp, etc.           |
| is_roaming     | Whether roaming was used          |
| download_speed | Download speed in Mbps            |
| upload_speed   | Upload speed in Mbps              |
| data_pack_type | Daily / Unlimited / Booster       |

### 3. `recharges`
Recharge and plan information.

| Column Name     | Description                     |
|------------------|---------------------------------|
| recharge_id      | Unique recharge record ID       |
| customer_id      | Linked customer                 |
| recharge_date    | Date of recharge                |
| recharge_amount  | ₹ amount of recharge            |
| plan_type        | Monthly / Quarterly / Annual    |
| plan_name        | Example: ₹239 Plan, ₹2999 Plan  |
| validity_days    | Number of days valid            |
| has_discount     | Promo used: True/False          |
| payment_method   | UPI, Card, Wallet, etc.         |

---

## ✅ Key SQL Concepts Used

- JOINs (INNER, LEFT)
- Aggregation (`SUM()`, `AVG()`, `COUNT()`)
- CTEs (Common Table Expressions)
- Window Functions (`RANK()`, `ROW_NUMBER()`)
- Filtering (`WHERE`, `HAVING`)
- Subqueries
- Date-based grouping and analysis

---

## ❓ Sample SQL Questions Solved

- Total active users and city-wise user count
- Most common apps used by heavy data consumers
- Customers who never recharged but used data
- GB usage exceeding average plan validity
- Multi-level referral detection
- Monthly recharge behavior by plan type and discount usage
- Top spenders vs top data users
- Plan-wise revenue and preference

All questions are solved inside the `Jio_analysis_sql.sql` file.

---

## 📌 Objective

To replicate a realistic SQL project involving customer and usage behavior in the telecom sector and to demonstrate skills in writing optimized and business-relevant SQL queries.

---

## 📬 Contact

**Pushpkar Roy**  
📧 Email: [pushpkarroy880@gmail.com](mailto:pushpkarroy880@gmail.com)  
🔗 LinkedIn: [https://www.linkedin.com/in/pushpkar-roy/](https://www.linkedin.com/in/pushpkar-roy/)  
💻 GitHub: [https://github.com/PushpkarRoy](https://github.com/PushpkarRoy)

---

## 🏁 Status

✅ SQL logic complete  
🔜 Optional: Power BI dashboard and visual insights


