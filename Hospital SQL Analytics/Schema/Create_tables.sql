# Creates table patients

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    gender VARCHAR(10),
    age INT,
    region VARCHAR(50),
    chronic_conditions TEXT
);

ALTER TABLE patients
MODIFY chronic_conditions TEXT;


# Creates table admissions

CREATE TABLE admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT,
    admission_date DATE,
    discharge_date DATE,
    department VARCHAR(50),
    readmitted_within_30_days BOOLEAN,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

ALTER TABLE admissions
ADD COLUMN doctor_id INT,
ADD CONSTRAINT fk_doctor
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id);


# Creates table diagnoses

CREATE TABLE diagnoses (
    diagnosis_id INT PRIMARY KEY,
    admission_id INT,
    diagnosis_code VARCHAR(10),
    diagnosis_description TEXT,
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);



# Creates table labs

CREATE TABLE labs (
    lab_id INT PRIMARY KEY,
    admission_id INT,
    test_name VARCHAR(50),
    test_value FLOAT,
    test_date DATE,
    FOREIGN KEY (admission_id)
        REFERENCES admissions (admission_id)
);


# Creates table doctor

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    experience_years INT
);






