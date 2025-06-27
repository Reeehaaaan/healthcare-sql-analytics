SELECT * FROM admissions;

SELECT * FROM diagnoses;

SELECT * FROM doctors;

SELECT * FROM labs;

SELECT * FROM patients;



-- Finding out how many patients are from each region.

SELECT region , COUNT(*) AS patients_per_region 
FROM patients 
GROUP BY region
ORDER BY patients_per_region DESC;


-- Analyzing which departments have the highest readmission rates (patients readmitted within 30 days).

SELECT department, ROUND(AVG(readmitted_within_30_days)*100,2) AS readmit_rate
FROM admissions
GROUP BY department
ORDER BY readmit_rate DESC
;

--  Top 10 most common diagnoses across all patienTS

SELECT  diagnosis_description , COUNT(*) AS total_cases
FROM diagnoses
GROUP BY diagnosis_description
ORDER BY total_cases DESC
LIMIT 10
;

-- top 10 doctors who handled the most admissions with each doctor name.

SELECT a.doctor_id,d.name, COUNT(*) AS total_admissions
FROM admissions AS a
JOIN doctors AS d
	ON a.doctor_id = d.doctor_id
GROUP BY doctor_id
ORDER BY total_admissions DESC 
LIMIT 10
;

-- For each test_name, calculate: AVG value, MIN value, MAX value

SELECT test_name , ROUND(AVG(test_value),2) AS avg_value , ROUND(MIN(test_value),2) AS min_value, ROUND(MAX(test_value),2) AS max_value
FROM labs
GROUP BY test_name
ORDER BY max_value DESC
;


-- Showing monthly trends of admissions over time.

SELECT DATE_FORMAT(admission_date, '%y - %m') AS month, COUNT(*) AS total_admissions
FROM admissions
GROUP BY month
ORDER BY month
;

-- Checking which doctors have the highest readmission rates — this could indicate high-risk cases, poor discharge planning, or complex patients.

SELECT d.doctor_id, d.name, ROUND(AVG(readmitted_within_30_days)*100,2) AS readmit_avg
FROM admissions AS a
JOIN doctors AS d
	ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id
ORDER BY readmit_avg DESC
;


-- For each lab test, ranking patients within each test name by their test_value (highest to lowest).

SELECT a.patient_id,l.test_name,l.test_value,
RANK() OVER (PARTITION BY l.test_name ORDER BY l.test_value DESC) AS value_rank
FROM labs AS l
JOIN admissions AS a
	ON l.admission_id = a.admission_id
;

-- For each patient, calculating the number of days since their previous admission.

SELECT patient_id, admission_id, admission_date, 
LAG(admission_date) OVER (PARTITION BY patient_id ORDER BY admission_date) AS previous_date,
DATEDIFF(admission_date, LAG(admission_date) OVER (PARTITION BY patient_id ORDER BY admission_date)) AS days_since_last_admit
FROM admissions
;

-- Finding patients whose number of admissions is greater than the average number of admissions per patient.

SELECT patient_id , total_admission
FROM (SELECT p.patient_id, COUNT(*) AS total_admission
	  FROM patients AS p 
	  JOIN admissions AS a 
		ON p.patient_id = a.patient_id
	  GROUP BY patient_id ) AS patitent_count
WHERE total_admission > (SELECT AVG(total_admission)
						 FROM (SELECT COUNT(*) AS total_admission
							   FROM admissions
							   GROUP BY patient_id )AS avg_count
                         );


-- Identifying departments whose average 30-day readmission rate is above the overall hospital average.

SELECT department,
ROUND(AVG(readmitted_within_30_days) * 100, 2) AS dept_readmit_rate
FROM admissions
GROUP BY department
HAVING AVG(readmitted_within_30_days) > (
    SELECT AVG(readmitted_within_30_days)
    FROM admissions)
ORDER BY dept_readmit_rate DESC;


-- Classify patients into risk categories based on their age.

SELECT patient_id, age, gender, region, 
CASE
	WHEN age < 30 THEN 'Low Risk'
    WHEN age BETWEEN 30 AND 60 THEN 'Medium Risk'
    ELSE 'High Risk'
END AS risk_level
FROM patients
;

-- Classify lab test values as 'Low', 'Normal', or 'High' based on test-specific reference ranges.

WITH test_ranges AS (
  SELECT test_name, MIN(test_value) AS min_val, MAX(test_value) AS max_val
  FROM labs
  GROUP BY test_name
)
SELECT a.patient_id, l.test_name, l.test_value, r.min_val, r.max_val,
  CASE 
    WHEN l.test_value < r.min_val THEN 'Low'
    WHEN l.test_value > r.max_val THEN 'High'
    ELSE 'Normal'
  END AS value_category
FROM labs l
JOIN admissions a ON l.admission_id = a.admission_id
JOIN test_ranges r ON l.test_name = r.test_name;

-- the top 5 longest hospital stays across all patients.

WITH stay_duration AS 
(
	SELECT patient_id,admission_id,doctor_id, department, 
    DATEDIFF(discharge_date, admission_date) AS stay_days
    FROM admissions
)
SELECT s.patient_id, s.admission_id, d.name AS doctor_name, s.department, s.stay_days
FROM stay_duration AS s
JOIN doctors AS d
	ON s.doctor_id = d.doctor_id
;   
    
-- For each patient, finding their most recent admission and calculate how many days since the previous admission.  
  
WITH admission AS 
(
	SELECT patient_id, admission_id, admission_date, 
    LAG(admission_date) OVER (PARTITION BY patient_id ORDER BY admission_date) AS previous_date
    FROM admissions
)
SELECT patient_id, admission_id, admission_date,previous_date,
DATEDIFF(admission_date, previous_date) AS days_between
FROM admission
WHERE previous_date IS NOT NULL
ORDER BY days_between DESC
;

-- For each diagnosis, showing the total number of patients, how many were readmitted within 30 days, and the readmission rate (%).

SELECT diagnosis_description, COUNT(DISTINCT patient_id) AS total_patients,
SUM(readmitted_within_30_days) AS readmitted_patients,
CONCAT(ROUND(SUM(readmitted_within_30_days) * 100 / COUNT(DISTINCT a.patient_id), 2), '%') AS readmit_rate
FROM diagnoses AS d
JOIN admissions AS a	
	ON d.admission_id = a.admission_id
GROUP BY diagnosis_description
ORDER BY readmit_rate DESC
;


-- For each patient, identifying the lab test result that deviates the most from that test’s average value across all patients. Then, classifying the severity

WITH test_with_avg AS 
(
	SELECT patient_id, AVG(test_value) OVER (PARTITION BY test_name) AS test_avg,
    ABS(test_value - AVG(test_value) OVER (PARTITION BY test_name)) AS deviation
    FROM labs AS l
    JOIN admissions AS a
		ON l.admission_id = a.admission_id
),
ranked_tests AS 
(
	SELECT *,
    ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY deviation DESC) AS deviation_rank
	FROM test_with_avg
)
SELECT patient_id, ROUND(test_avg, 2) AS test_avg, ROUND(deviation, 2) AS deviation,
CASE 
	WHEN deviation >= 50 THEN 'Critical'
    WHEN deviation >= 20 THEN 'High'
    ELSE 'Mild'
END AS sevirity
FROM ranked_tests
WHERE deviation_rank = 1
ORDER BY deviation DESC
;


-- Identifying patients with multiple readmissions for the same diagnosis and calculating their average time between admissions.

WITH admission_by_diagonses AS 
(
	SELECT patient_id, diagnosis_description, admission_date,
    LAG(admission_date) OVER (PARTITION BY patient_id, diagnosis_description ORDER BY admission_date) AS previous_date
    FROM admissions AS a
    JOIN diagnoses AS d
		ON a.admission_id = d.admission_id
)
SELECT patient_id,diagnosis_description, COUNT(*) AS total_readmissions, 
ROUND(AVG(DATEDIFF(admission_date, previous_date)),2) AS avg_gap_days,
CASE 
  WHEN COUNT(*) >= 3 THEN 'Chronic'
  WHEN COUNT(*) = 2 THEN 'Frequent'
  ELSE 'Stable'
END AS risk_tag
FROM admission_by_diagonses
WHERE previous_date IS NOT NULL
GROUP BY patient_id, diagnosis_description
;