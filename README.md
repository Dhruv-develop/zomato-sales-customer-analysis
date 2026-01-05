# 🍽️ Zomato Sales & Customer Behavior Analysis (SQL Project)

## 📌 Project Overview
This project focuses on analyzing **sales performance, customer behavior, and restaurant insights**
using a Zomato-like food delivery dataset.  
The analysis is completely done using **SQL (MySQL)** and aims to extract meaningful
business insights from raw transactional data.

The project simulates a **real-world food delivery / e-commerce platform** similar to Zomato or Swiggy.

---

## 🗂️ Dataset Information
- **Source:** Kaggle  
- **Dataset Name:** Zomato Database  
- **Link:** https://www.kaggle.com/datasets/anas123siddiqui/zomato-database

The dataset contains structured relational data representing users, restaurants, menus,
food items, and orders.

---

## 🏗️ Database Schema
The database consists of **5 main tables**:

### 1. Users
Stores customer demographic information.
- user_id (PK)
- name, age, gender
- marital_status, occupation
- education, monthly_income
- family_size

### 2. Restaurants
Stores restaurant-level details.
- id (PK)
- name, city
- rating, rating_count
- cost, cuisine
- address

### 3. Food
Contains food item details.
- f_id (PK)
- item
- veg_or_non_veg

### 4. Menu
Maps food items to restaurants.
- menu_id (PK)
- r_id (FK)
- f_id (FK)
- cuisine
- price

### 5. Orders
Stores transactional order data.
- order_id (PK)
- order_date
- sales_qty
- sales_amount
- currency
- user_id (FK)
- r_id (FK)

---

## 🛠️ Tools & Technologies
- **Database:** MySQL
- **Language:** SQL
- **Concepts Used:**
  - Joins
  - Group By & Aggregations
  - Subqueries
  - Window Functions
  - CTE (WITH clause)
  - CASE statements
  - Date & time analysis

---

## 📊 Key Analysis Performed
- Total revenue and total orders
- City-wise and restaurant-wise sales
- Top cuisines by revenue
- Customer repeat rate analysis
- Age group spending behavior
- Monthly and yearly sales trends
- High-rating but low-sales restaurant identification

---

## 🔍 Key Insights
- Total revenue generated: **₹135.85 Million**
- Highest spending age group: **18–25 years**
- Top-performing cuisines: **North Indian & Chinese**
- Peak sales year: **2018**
- Certain restaurants show high repeat customer loyalty

---

## 💡 Business Recommendations
- Focus marketing campaigns on younger customers
- Promote high-performing cuisines more aggressively
- Improve visibility of high-rated but low-sales restaurants
- Introduce loyalty programs to increase repeat customers

---

## 👤 Author
**Dhruv Rapariya**  
SQL | Data Analytics | Student Project
