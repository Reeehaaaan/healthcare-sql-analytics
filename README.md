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

## 🧰 Tools Used

- **MySQL** for database management and querying
- **Python** (`Faker` library) for generating synthetic patient/lab data
- **Excel/CSV** for loading data

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

## 📈 Key SQL Insights

### 1. Top Diagnoses
- Most common medical conditions across all admissions

### 2. Doctor Performance
- Doctors ranked by number of admissions handled

### 3. Readmission Analysis
- Patients readmitted within 30 days, grouped by diagnosis and department
- Readmission rates by department and hospital average comparison

### 4. Lab Test Analytics
- Lab tests with highest average values
- Patient lab results deviating significantly from the test average

### 5. Advanced Insights
- Using CTEs and window functions to calculate:
  - Time between admissions
  - Rank of lab results per test
  - Tagging high-risk conditions based on repeat visits

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
