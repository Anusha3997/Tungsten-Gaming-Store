# 🎮 Tungsten Gaming Store – Retail Database System

A production-style PostgreSQL database designed for a gaming retail store to manage customers, products, orders, and inventory.

This project demonstrates **data modeling, schema design, constraints, indexing, and containerized deployment** — similar to real-world backend and data engineering systems.

---

## 🚀 Tech Stack
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen?style=for-the-badge)

- PostgreSQL 16
- Docker & Docker Compose
- SQL (DDL, DML, Constraints, Indexing)
- DBeaver
- dbdiagram.io (ERD design)

---

## 📐 Architecture

### Entity Relationship Diagram
![ERD](erd/ERD.png)

---

## 🗄️ Database Design Highlights

### ✅ Schema Design
- Normalized to **3NF**
- Separate tables for customers, products, orders, order_details, inventory
- Surrogate primary keys (SERIAL)

### ✅ Data Integrity
- NOT NULL constraints
- UNIQUE email enforcement
- Foreign key relationships
- CHECK constraints (price > 0, quantity ≥ 0)

### ✅ Performance
- Indexes on foreign keys and join columns
- Optimized for faster queries and analytics

### ✅ Deployment
- Dockerized PostgreSQL instance
- Auto-loads schema + seed data on startup

---

##
🎯 Lessons Learned
- Designed a normalized schema to reduce redundancy and improve data integrity
- Used Docker for reproducible and portable database setup
- Cleaned and standardized data before import to avoid loading issues
- Enforced data quality using primary keys, foreign keys, and constraints
- Added indexes to speed up joins and query performance
- Generated synthetic data to simulate real-world transactions for testing
- Validated the design using analytics queries (revenue, orders, inventory)

---

## ⚡ Quick Start (Run Locally)

``` 1. Clone repo
git clone https://github.com/Anusha3997/Tungsten-Gaming-Store.git
cd Tungsten-Gaming-Store

### 2. Start database
docker-compose up

### 3. Connect via DBeaver
Host: localhost
Port: 5432
Database: tungsten
User: admin
Password: admin
```

## Author
Anusha Nagula

