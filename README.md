# 📊 Netflix Insights – SQL Project

This project involves a comprehensive analysis of Netflix's Movies and TV Shows dataset using SQL. The goal is to extract valuable insights and answer various business questions based on the data.

---

## 🎯 Objectives

- Analyze the distribution of content types (Movies vs TV Shows)
- Identify the most common ratings for Movies and TV Shows
- List and analyze content based on release years, countries, and durations
- Explore and categorize content based on specific criteria and keywords

---

### 🧱 Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
