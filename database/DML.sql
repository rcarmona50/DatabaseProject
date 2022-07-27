
-- Populates Schedule form
SELECT appointments.appointment_id, appointments.date, appointments.time, appointments.end_time, 
CONCAT(clients.fname, ' ' ,clients.lname) AS Client, 
CONCAT(providers.fname, ' ' ,providers.lname) AS The_Providers
from appointments 
LEFT JOIN providers ON appointments.providers_provider_id = providers.provider_id 
LEFT JOIN clients ON appointments.clients_client_id = clients.client_id

-- Add Appoinment
INSERT INTO `appointments` (`clients_client_id`, `date`,`time`,`end_time`, 
`providers_provider_id`) VALUES 
(:clients_client_id, :date, :time, :endtime, :providers_provider_id);

-- Update Appoinments
UPDATE appointments 
SET client_id = :client_id_from_dropdown_Input, providers_provider_id = :course_id_from_dropdown_Input, date = :date,
end_time = :end_time
WHERE id= :appointment_id

-- Delete Appointment
DELETE FROM appointments 
WHERE appointment_id = :appointment_id

-- Search Client
SELECT appointments.appointment_id, 
CONCAT(clients.fname, ' ', clients.lname) AS Client, appointments.date, 
appointments.time, appointments.end_time, 
CONCAT(providers.fname, ' ', providers.lname) AS Provider
FROM appointments 
JOIN providers ON appointments.providers_provider_id = providers.provider_id
JOIN clients ON appointments.clients_client_id = clients.client_id
WHERE CONCAT(clients.fname, ' ', clients.lname) = :client_name;

-- Update Appointment show Names
SELECT appointments.appointment_id, 
CONCAT(clients.fname, ' ', clients.lname) AS Client, appointments.date, 
appointments.time, appointments.end_time, 
CONCAT(providers.fname, ' ', providers.lname) AS Provider
FROM appointments 
JOIN providers ON appointments.providers_provider_id = providers.provider_id
JOIN clients ON appointments.clients_client_id = clients.client_id
WHERE appointment_id = :appointment_id;;

-- Populates Clients form
SELECT client_id, fname, lname, insurance_num FROM clients;

-- Adds new client
INSERT INTO `clients` (`fname`, `lname`, `insurance_num`) VALUES
(:fname, :lname, :insurance_num);

-- Update clients
UPDATE clients 
SET client_id = :client_id_from_dropdown_Input, fname = :fname_from_Input, lname = :lname_from_Input,
insurance_num = :insurance_num_from_Input
WHERE id= :client_id

-- Delete Clients
DELETE FROM clients 
WHERE client_id = :client_id

-- get all Client IDs the Client dropdown
SELECT client_id FROM clients;

-- get all Provider names for provider dropdown
SELECT CONCAT(providers.fname, ' ', providers.lname) AS Provider FROM providers;

-- Add Provider
INSERT INTO `providers` (`fname`, `lname`, `credentials`) VALUES
(:fname, :lname, :credentials);

-- Delete Provider
DELETE FROM providers 
WHERE provider_id = :provider_id

-- Populates Behaviors form
SELECT 'behavior_id', 'name', 'definition', 'clients_client_id' FROM `problem_behaviors`;

-- Adds new behavior
INSERT INTO `problem_behaviors` (`name`, `definition`, 'clients_client_id') VALUES
(:name, :definition, :clients_client_id);

-- Update Behavior
UPDATE `problem_behaviors`
SET behavior_id = :behavior_id_from_dropdown_Input, name = :name_from_Input, definition = :definition_from_Input,
clients_client_id = :client_id_from_Input
WHERE id= :clients_client_id

-- Delete Behavior
DELETE FROM `problem_behaviors`
WHERE behavior_id = :behavior_id

-- get all Behavior IDs the behavior dropdown
SELECT behavior_id FROM `problem_behaviors`;

-- Populates skills form
SELECT 'behavior_id', 'name', 'description', 'pass_condition', 'clients_client_id' FROM `skills`;

-- Adds new skill
INSERT INTO `skills` (`name`, 'description', 'pass_condition', 'clients_client_id') VALUES
(:name, :description, :pass_condition, :clients_client_id);

-- Update skill
UPDATE `skills`
SET skill_id = :skill_id_from_dropdown_Input, name = :name_from_Input, description = :description_from_Input,
clients_client_id = :client_id_from_Input
WHERE id= :clients_client_id

-- Delete skill
DELETE FROM `skills`
WHERE skill_id = :skill_id

-- get all skill IDs the skill dropdown
SELECT skill_id FROM `skills`;

-- Search function
SELECT appointments.appointment_id, clients.client_id,
CONCAT(clients.fname, ' ', clients.lname) AS Client, appointments.date, 
appointments.time, appointments.end_time, 
CONCAT(providers.fname, ' ', providers.lname) AS Provider
FROM appointments 
JOIN providers ON appointments.providers_provider_id = providers.provider_id
JOIN clients ON appointments.clients_client_id = clients.client_id
WHERE appointments.clients_client_id = :client_id;

-- client sessions add_skills
INSERT INTO skill_trials (prompt, passed, appointments_appointment_id, skills_skills_id) VALUES (:prompt, :passed, :appointment_id, :id)

-- client sessions add behaviours
INSERT INTO behaviors (time, end_time, ocurrences, appointments_appointment_id, problem_behaviors_behavior_id) VALUES (:time, :end_time, :occurrences, :appointment_id, :ids)

-- get appt data
SELECT appointment_id, date, time, end_time, providers_provider_id, clients_client_id FROM appointments where appointment_id =%s % (:appointment_id)

-- get skill_trial_id data
SELECT skill_trial_id, prompt, passed, appointments_appointment_id, skills_skills_id FROM skill_trials where appointments_appointment_id =%s % (:appointment_id)

-- get behavior_event_id data
SELECT behavior_event_id, time, end_time, ocurrences, appointments_appointment_id, problem_behaviors_behavior_id FROM behaviors WHERE appointments_appointment_id =%s % (:appointment_id)

-- get client_id data
SELECT client_id, fname, lname, insurance_num FROM clients

-- get behavior_id data
SELECT behavior_id, name, definition, clients_client_id FROM problem_behaviors

-- get skills_id data
SELECT skills_id, name, definition, pass_condition, clients_client_id FROM skills