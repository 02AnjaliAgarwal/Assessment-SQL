--Create a table for Patient with constraints.

CREATE Table Patient(
patient_id INT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(100)NOT NULL,
gender VARCHAR(20) NOT NULL,
date_of_birth DATE NOT NULL,
contact_number VARCHAR(15) NOT NULL
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_name VARCHAR(100),
    appointment_date DATE,
    department VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

--Alter the Appointment table to add a new column status VARCHAR(20).

ALTER TABLE Appointment ADD COLUMN status VARCHAR(20);

--Insert sample data into both tables for 5 patients and 5 appointments.

INSERT INTO Patient(patient_id,first_name,last_name,gender,date_of_birth,contact_number)
VALUES
(1,'Suhanika','verma','Female','2000-02-28',9998876543),
(2,'Daisy','Merchant','Femle','2002-02-27',9998876223),
(3,'Lucas','Uzumaki','male','2002-04-29',9998876443),
(4,'John','Doe','male','2000-05-16',9998876555),
(5,'John','Merchant','Male','2004-06-25',9998876547);

INSERT INTO Appointment(appointment_id,patient_id,doctor_name,appointment_date,department)
VALUES
(11,1,'Dr. Smith','2025-03-24','Cardiology'),
(12,2,'Dr. Alexa','2025-03-28','Homoeopathic'),
(13,3,'Dr. Smith','2025-03-30','Cardiology'),
(14,4,'Dr. Chandler','2025-04-10','Gynacologist'),
(15,5,'Dr. Amaya','2025-04-15','Neurology');

--Update the department of an appointment where appointment_id = 2 to 'Neurology'.

UPDATE Appointment set department = 'Neurology' where appointment_id =12;

--Delete the patient whose name = 'John Doe'.

DELETE FROM Appointment WHERE patient_id = 4;
DELETE FROM Patient WHERE first_name = 'John' AND last_name = 'Doe';


--Retrieve all patient names along with their appointment date and doctor name.
SELECT p.*,a.appointment_date,a.doctor_name from patient p
Join appointment a
ON p.patient_id = a.patient_id;

--List all patients who have appointments in the 'Cardiology' department.
SELECT p.*
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
WHERE a.department = 'Cardiology';

--Get patient details who have an appointment with doctor 'Dr. Smith'.
SELECT p.*
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
WHERE a.doctor_name = 'Dr. Smith';


--Display appointment details where the patient's age is greater than 60.

SELECT a.*
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
WHERE DATE_PART('year', AGE(CURRENT_DATE, p.date_of_birth)) > 60;


--Find patients who have more than one appointment (use GROUP BY and HAVING).

SELECT p.patient_id, p.first_name, p.last_name, COUNT(a.appointment_id) AS total_appointments
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(a.appointment_id) > 1;



--Find the patient(s) who have the most number of appointments.

select count(*) from appointment a
left join patient p
on a.patient_id = p.patient_id;


--List patients who do not have any appointments.
select * 
FROM patient WHERE (patient_id NOT IN (SELECT patient_id from appointment));

--Show the name and age of all patients (calculate age from date_of_birth).

SELECT 
  first_name,
  last_name,
  DATE_PART('year', AGE(CURRENT_DATE, date_of_birth)) AS age
FROM Patient;

--List appointments made in the last 30 days from today’s date.
SELECT *
FROM Appointment
WHERE appointment_date >= CURRENT_DATE - INTERVAL '30 days';



--Count the number of appointments per department.

select department, COUNT(*) as total_appointments
From appointment
GROUP BY department;



--Retrieve the patient(s) who had their first-ever appointment with doctor 'Dr. Smith'.

SELECT p.*
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
WHERE a.appointment_date = (
    SELECT MIN(a2.appointment_date)
    FROM Appointment a2
    WHERE a2.patient_id = p.patient_id
)
AND a.doctor_name = 'Dr. Smith';

--List the top 3 patients who have had the highest number of appointments.

select p.patient_id,p.first_name,p.last_name,COUNT(*) AS appointment_count
FROM Appointment a
JOIN Patient p on p.patient_id = a.patient_id
GROUP BY p.patient_id,p.first_name,p.last_name
ORDER BY appointment_count DESC
LIMIT 3;



