# Healthcare SQL Analytics Project

This project explores a synthetic healthcare dataset using advanced SQL queries to extract meaningful insights related to patient admissions, diagnoses, lab tests, and hospital readmission trends.

---

## 📌 Objectives

- Analyze hospital data to understand readmission patterns, lab test trends, and doctor performance.
- Apply complex SQL techniques such as:
  - Subqueries
  - Common Table Expressions (CTEs)
  - Window Functions
  - Aggregate & conditional logic
- Showcase strong SQL data analytics skills using a real-world inspired schema.

---

## 🧰 Tools & Technologies

- **Database:** MySQL
- **Languages:** SQL, Python (optional for visualization)
- **Libraries:** pandas, seaborn, matplotlib, SQLAlchemy
- **Data Source:** Synthetic data generated using Faker

---

## 🗃️ Dataset Overview

The dataset is composed of 5 relational tables:

| Table Name   | Description                          | Row Count |
|--------------|--------------------------------------|-----------|
| `patients`   | Patient demographic and health data  | 10,000    |
| `doctors`    | Hospital doctors and departments     | 500       |
| `admissions` | Patient admission records            | 50,000    |
| `diagnoses`  | Diagnoses per admission              | 75,000    |
| `labs`       | Lab test results linked to admissions| 1,00,000  |

---

## 🧠 Schema Design

All data is normalized and joined via foreign key relationships.  
See `schema/ERD.png` for a full database relationship diagram.

---

## 📊 Key SQL Insights

1. Patients by region
2. Top diagnoses
3. Readmission rates by department
4. Monthly admission trends
5. Doctor-wise admission load
6. Lab test stats (avg/min/max)
7. Risk tagging by diagnosis
8. Ranking patients by lab value
9. Days since last admission
10. Deviation from average test value
11. Lab test severity classification
12. Readmission behavior by diagnosis
13. Patient admission vs hospital avg
14. Lab trends over time
15. Patient-wise test average
16. Chronic diagnosis tracking
17. Department performance benchmarking
18. Risk profile (Chronic / Frequent / Stable)

> 📌 All queries are stored in `query/insights.sql`.

---

## 📈 Python Visualizations 

- Visualizations for SQL insight using `matplotlib` and `seaborn`
- script/healthcare_viz.py

  ---

## 🐍 Synthetic Data Generation

The dataset was created using Python's `Faker` library to simulate:
- Global patient demographics
- Admission timelines
- Doctor assignments
- Lab test results and diagnoses

See [`scripts/generate_synthetic_data.py`](./scripts/generate_synthetic_data.py) for the full data generation process.

---

## ✅ What I Learned

- How to structure and analyze a normalized healthcare database
- Writing efficient and complex SQL using real-world logic
- Data storytelling using SQL only (without frontend visualization)

---

## 🧾 Folder Structure

healthcare-sql-analytics/
├── data/ # Raw CSV data
├── queries/ # All SQL queries
├── schema/ # ERD + CREATE TABLE scripts
├── scripts/ # Python data generator

*Created by Rehan Ahmed Rikati*
