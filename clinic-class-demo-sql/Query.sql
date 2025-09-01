-- STEP 01: Create Database & Table(s).

-- Create the Clinic Database
CREATE DATABASE clinic_database;
USE clinic_database;

-- Patient Table
CREATE TABLE Patient (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_first_name VARCHAR(50) NOT NULL,
    patient_last_name VARCHAR(50) NOT NULL,
    patient_email VARCHAR(50) NOT NULL UNIQUE,
    patient_phone_number VARCHAR(50) NOT NULL,
    patient_date_of_birth DATE NOT NULL,
    patient_medical_aid_number VARCHAR(30) NULL
);

-- Doctor Table
CREATE TABLE Doctor (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    doctor_first_name VARCHAR(50) NOT NULL,
    doctor_last_name VARCHAR(50) NOT NULL,
    doctor_speciality VARCHAR(50) NOT NULL,
    doctor_available BIT DEFAULT 1
);

-- Service Table
CREATE TABLE Service (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    service_description VARCHAR(200) NOT NULL,
    service_fees DECIMAL(10, 2) NOT NULL
);

-- Appointment Table
CREATE TABLE Appointment (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_description VARCHAR(200) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    doctor_id INT,
    patient_id INT,
    service_id INT,

    -- Foreign Key(s) Constraints
    FOREIGN KEY (doctor_id) REFERENCES Doctor (doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient (patient_id),
    FOREIGN KEY (service_id) REFERENCES Service (service_id)
);

-- Invoice Table
CREATE TABLE Invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_total DECIMAL(10, 2) NOT NULL,
    service_id INT,
    patient_id INT,

    -- Foreign Key(s) Constraints
    FOREIGN KEY (service_id) REFERENCES Service (service_id),
    FOREIGN KEY (patient_id) REFERENCES Patient (patient_id)
);

-- Payment Table with Enum for payment_method
CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_method VARCHAR(20) CHECK (payment_method IN ('Cash', 'Credit', 'Debit', 'Online')),
    payment_amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    invoice_id INT,

    -- Foreign Key(s) Constraints
    FOREIGN KEY (invoice_id) REFERENCES Invoice (invoice_id)
);

-- STEP 02: Populate Table(s).

-- Insert Sample Data into Patient Table
INSERT INTO Patient (patient_first_name, patient_last_name, patient_email, patient_phone_number, patient_date_of_birth, patient_medical_aid_number)
VALUES
('John', 'Doe', 'johndoe@example.com', '1234567890', '1985-07-15', 'MA123456'),
('Jane', 'Smith', 'janesmith@example.com', '0987654321', '1990-03-22', 'MA987654');

-- Insert Sample Data into Doctor Table
INSERT INTO Doctor (doctor_first_name, doctor_last_name, doctor_speciality)
VALUES
('Dr. Alice', 'Johnson', 'Cardiologist'),
('Dr. Bob', 'Williams', 'Dermatologist');

-- Insert Sample Data into Service Table
INSERT INTO Service (service_description, service_fees)
VALUES
('Consultation', 100.00),
('Blood Test', 50.00),
('Skin Treatment', 150.00);

-- Insert Sample Data into Appointment Table
INSERT INTO Appointment (appointment_description, appointment_date, appointment_time, doctor_id, patient_id, service_id)
VALUES
('Consultation for heart checkup', '2025-09-10', '10:00:00', 1, 1, 1),
('Skin check-up and treatment', '2025-09-12', '14:00:00', 2, 2, 3);

-- Insert Sample Data into Invoice Table
INSERT INTO Invoice (invoice_total, service_id, patient_id)
VALUES
(100.00, 1, 1),
(150.00, 3, 2);

-- Insert Sample Data into Payment Table
INSERT INTO Payment (payment_method, payment_amount, invoice_id)
VALUES
('Credit', 100.00, 1),
('Debit', 150.00, 2);

-- STEP 03: Use JOINs Query & Display

-- Join Query to Retrieve All Relevant Data
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
