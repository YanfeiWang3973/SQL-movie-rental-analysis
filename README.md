# 🎬 Movie Rental Analysis (Sakila Database)

## 📖 Overview
This project explores and analyzes the **Sakila Movie Rental** database — a sample dataset provided by MySQL that simulates a video rental business.  
Using **SQL (MySQL dialect)**, I performed real-world business analysis tasks focusing on customer behavior, inventory levels, and revenue insights.  

Each query answers a business-style question a store manager might ask — from identifying top-performing staff to spotting under-rented films that could be sold or replaced.

---

## ⚙️ Tools & Environment
- **Database:** MySQL (Sakila Sample Database)
- **IDE:** JetBrains DataGrip  
- **Language:** SQL  
- **Dataset Source:** [MySQL Sakila Sample DB](https://dev.mysql.com/doc/sakila/en/)

---

## 🧩 Project Structure

| File | Description |
|------|--------------|
| `sakila-mv-schema.sql` | Creates all tables and constraints for the Sakila database |
| `sakila-mv-data.sql` | Populates tables with sample data |
| `Yanfie_Wang_Movie_Rental.sql` | Contains all analysis queries and solutions |

---

## 🔍 Key Analysis Tasks

### 1️⃣ Data Exploration
- Listed all tables and previewed datasets (`film`, `actor`, `rental`, `inventory`, `category`, `payment`).
- Verified relationships and key joins.

### 2️⃣ Film Segmentation
Created a temporary **derived column** using `CASE WHEN` to classify films by length:
```sql
SELECT 
  CASE
    WHEN length < 60 THEN 'short'
    WHEN length < 120 THEN 'standard'
    ELSE 'long'
  END AS film_length,
  COUNT(film_id) AS film_count
FROM film
GROUP BY film_length;
