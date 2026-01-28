# Design Decisions – Tungsten Gaming Store Database

## Database Choice
PostgreSQL was chosen over Oracle to provide:
- Open source deployment
- Docker compatibility
- Industry-standard usage in data engineering and backend systems

## Schema Design
- Normalized to 3NF to reduce redundancy
- Separate tables for customers, products, orders, order_details, and inventory
- Surrogate primary keys (SERIAL) used for simplicity and performance

## Constraints
Added strict constraints to ensure data integrity:
- NOT NULL for mandatory fields
- UNIQUE on customer email
- FOREIGN KEYS to enforce relationships
- CHECK constraints for price > 0 and quantity >= 0

## Indexing Strategy
Indexes added on:
- Foreign keys
- Frequently joined columns

Purpose:
- Faster joins
- Avoid full table scans
- Improve analytics query performance

## Dockerization
Database runs inside Docker to:
- Ensure reproducibility
- Simplify setup for reviewers/recruiters
- Simulate production-style deployment

## Seed Data
Small sample dataset included to:
- Test queries
- Demonstrate relationships
- Enable analytics examples

## Analytics Support
Designed to support:
- Revenue reporting
- Inventory monitoring
- Customer insights
- Sales trends

## Future Improvements
- REST API with FastAPI
- ETL pipeline
- Dashboard (Streamlit/Metabase)
- Stored procedures and triggers
