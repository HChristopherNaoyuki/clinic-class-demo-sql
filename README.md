# Clinic Database Management System

## Overview

This database schema is designed for managing a clinic's patient, doctor, service, appointment, invoice, and payment information. 
It enables the efficient handling of patient details, doctor appointments, service bookings, invoices, and payments, with an organized 
structure for each entity involved in the process.

## Database Structure

### 1. **Clinic Database**

The primary database for the clinic is named `clinic_database`.

```sql
CREATE DATABASE clinic_database;
USE clinic_database;
```

### 2. **Tables**

#### a. **Patient Table**

This table stores personal information for each patient, including their medical aid number.

```sql
CREATE TABLE Patient (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_first_name VARCHAR(50) NOT NULL,
    patient_last_name VARCHAR(50) NOT NULL,
    patient_email VARCHAR(50) NOT NULL UNIQUE,
    patient_phone_number VARCHAR(50) NOT NULL,
    patient_date_of_birth DATE NOT NULL,
    patient_medical_aid_number VARCHAR(30) NULL
);
```

#### b. **Doctor Table**

This table stores details about the clinic's doctors, including their specialty and availability.

```sql
CREATE TABLE Doctor (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    doctor_first_name VARCHAR(50) NOT NULL,
    doctor_last_name VARCHAR(50) NOT NULL,
    doctor_speciality VARCHAR(50) NOT NULL,
    doctor_available BIT DEFAULT 1
);
```

#### c. **Service Table**

This table lists the different services offered by the clinic, including the description and fees.

```sql
CREATE TABLE Service (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    service_description VARCHAR(200) NOT NULL,
    service_fees DECIMAL(10, 2) NOT NULL
);
```

#### d. **Appointment Table**

This table records the appointments for patients, including details about the doctor, patient, service, appointment date, and time.

```sql
CREATE TABLE Appointment (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_description VARCHAR(200) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    doctor_id INT,
    patient_id INT,
    service_id INT,
    FOREIGN KEY (doctor_id) REFERENCES Doctor (doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient (patient_id),
    FOREIGN KEY (service_id) REFERENCES Service (service_id)
);
```

#### e. **Invoice Table**

This table stores invoice information for each patient based on the services rendered.

```sql
CREATE TABLE Invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_total DECIMAL(10, 2) NOT NULL,
    service_id INT,
    patient_id INT,
    FOREIGN KEY (service_id) REFERENCES Service (service_id),
    FOREIGN KEY (patient_id) REFERENCES Patient (patient_id)
);
```

#### f. **Payment Table**

This table records payments made by patients, including payment method and amount.

```sql
CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_method VARCHAR(20) CHECK (payment_method IN ('Cash', 'Credit', 'Debit', 'Online')),
    payment_amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    invoice_id INT,
    FOREIGN KEY (invoice_id) REFERENCES Invoice (invoice_id)
);
```

## Sample Data

The following is the sample data inserted into the tables:

### 1. **Insert Sample Data into Patient Table**

```sql
INSERT INTO Patient (patient_first_name, patient_last_name, patient_email, patient_phone_number, patient_date_of_birth, patient_medical_aid_number)
VALUES
('John', 'Doe', 'johndoe@example.com', '1234567890', '1985-07-15', 'MA123456'),
('Jane', 'Smith', 'janesmith@example.com', '0987654321', '1990-03-22', 'MA987654');
```

### 2. **Insert Sample Data into Doctor Table**

```sql
INSERT INTO Doctor (doctor_first_name, doctor_last_name, doctor_speciality)
VALUES
('Dr. Alice', 'Johnson', 'Cardiologist'),
('Dr. Bob', 'Williams', 'Dermatologist');
```

### 3. **Insert Sample Data into Service Table**

```sql
INSERT INTO Service (service_description, service_fees)
VALUES
('Consultation', 100.00),
('Blood Test', 50.00),
('Skin Treatment', 150.00);
```

### 4. **Insert Sample Data into Appointment Table**

```sql
INSERT INTO Appointment (appointment_description, appointment_date, appointment_time, doctor_id, patient_id, service_id)
VALUES
('Consultation for heart checkup', '2025-09-10', '10:00:00', 1, 1, 1),
('Skin check-up and treatment', '2025-09-12', '14:00:00', 2, 2, 3);
```

### 5. **Insert Sample Data into Invoice Table**

```sql
INSERT INTO Invoice (invoice_total, service_id, patient_id)
VALUES
(100.00, 1, 1),
(150.00, 3, 2);
```

### 6. **Insert Sample Data into Payment Table**

```sql
INSERT INTO Payment (payment_method, payment_amount, invoice_id)
VALUES
('Credit', 100.00, 1),
('Debit', 150.00, 2);
```

## Query: Retrieve Data Using JOINs

The following query joins multiple tables to retrieve comprehensive details about appointments, patients, doctors, services, invoices, and payments.

```sql
SELECT 
    p.patient_first_name AS "Patient First Name", 
    p.patient_last_name AS "Patient Last Name", 
    p.patient_email AS "Patient Email", 
    d.doctor_first_name AS "Doctor First Name", 
    d.doctor_last_name AS "Doctor Last Name", 
    d.doctor_speciality AS "Doctor Specialty", 
    s.service_description AS "Service Description", 
    s.service_fees AS "Service Fees", 
    a.appointment_date AS "Appointment Date", 
    a.appointment_time AS "Appointment Time", 
    i.invoice_total AS "Invoice Total", 
    pmt.payment_method AS "Payment Method", 
    pmt.payment_amount AS "Payment Amount", 
    pmt.payment_date AS "Payment Date"
FROM 
    Appointment a
JOIN 
    Patient p ON a.patient_id = p.patient_id
JOIN 
    Doctor d ON a.doctor_id = d.doctor_id
JOIN 
    Service s ON a.service_id = s.service_id
JOIN 
    Invoice i ON i.patient_id = p.patient_id AND i.service_id = s.service_id
JOIN 
    Payment pmt ON pmt.invoice_id = i.invoice_id
ORDER BY 
    a.appointment_date, a.appointment_time;
```

This query retrieves and displays the following data for each appointment:

* Patient's First and Last Name, Email
* Doctor's First and Last Name, Specialty
* Service Description and Fees
* Appointment Date and Time
* Invoice Total
* Payment Method and Amount
* Payment Date

## Conclusion

This database structure allows for efficient management of the clinic's operations, from patient registration to appointment scheduling, 
invoicing, and payment processing. By using foreign keys and ensuring referential integrity, the schema ensures that all data is accurately linked and easily queried.

## DISCLAIMER

UNDER NO CIRCUMSTANCES SHOULD IMAGES OR EMOJIS BE INCLUDED DIRECTLY 
IN THE README FILE. ALL VISUAL MEDIA, INCLUDING SCREENSHOTS AND IMAGES 
OF THE APPLICATION, MUST BE STORED IN A DEDICATED FOLDER WITHIN THE 
PROJECT DIRECTORY. THIS FOLDER SHOULD BE CLEARLY STRUCTURED AND NAMED 
ACCORDINGLY TO INDICATE THAT IT CONTAINS ALL VISUAL CONTENT RELATED TO 
THE APPLICATION (FOR EXAMPLE, A FOLDER NAMED IMAGES, SCREENSHOTS, OR MEDIA).

I AM NOT LIABLE OR RESPONSIBLE FOR ANY MALFUNCTIONS, DEFECTS, OR ISSUES 
THAT MAY OCCUR AS A RESULT OF COPYING, MODIFYING, OR USING THIS SOFTWARE. 
IF YOU ENCOUNTER ANY PROBLEMS OR ERRORS, PLEASE DO NOT ATTEMPT TO FIX THEM 
SILENTLY OR OUTSIDE THE PROJECT. INSTEAD, KINDLY SUBMIT A PULL REQUEST 
OR OPEN AN ISSUE ON THE CORRESPONDING GITHUB REPOSITORY, SO THAT IT CAN 
BE ADDRESSED APPROPRIATELY BY THE MAINTAINERS OR CONTRIBUTORS.

---
