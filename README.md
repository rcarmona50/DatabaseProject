Name: Rafael Carmona & John Jensen
Description: Therapist application. Code Name: Jellyfish

DATABASE Project

Tech Used: MySQL, Flask, Python

Description: 
    - A web application designed for database administrators. 
    - ER Diagrams
    - Data Defintion Quieries
    - Normalized Schema + DDL with Sample Data 
    - Design HTML interface + DML SQL
    - Full CRUD functionality
 
Overview 

Behavior intervention therapists provide services for children with various diagnoses and challenges. Each client’s care is personalized to fit their needs and must be adjusted as the client masters new skills and problem behaviors are reduced. This involves recording data reporting their progress each session and regular monitoring to adjust the goals to ensure the best possible care is being given. The traditional method of recording this data has been writing it on paper, admin staff manually entering it, and then a supervisor graphing and interpreting it. This causes a whole host of problems and has recently been replaced in most settings by Electronic Health Record (EHR) software with varying degrees of success. Implementing these tools has been primary done at a corporate level for larger agencies as EHR software is often costly to implement. Few options exist for independent providers and small agencies. Project Code Name Jellyfish will be the first tool in a suite of tools intended to meet the needs of these unincorporated entities providing ABA (applied behavior analysis) or adjacent services modularly. 

A provider in this field will typically interact with 2-3 clients per day, 5 days a week. These interactions will usually be with the same caseload of 2-6 individuals. Each case will have 3-5 skills they are working to develop and may also have 1 or 2 problem behaviors that are monitored for frequency, duration, or both. Each of these skills or behaviors will have 1-10 trials recorded for the purpose of monitoring progress. Meaning these provider will create a rough average of 350 new datapoints a week. A small agency may have 5-10 provider on staff entering 1750-3500 datapoints a week for their 62-125 appointments a week for 10-60 clients. Large agencies multiply this drastically and often also provide additional services that have similar data needs. All of this does not even account for the plethora of treatment plans, assessments, and authorizations on file for each participant required by insurance and state agencies. 

Project Jellyfish will form the backbone of daily data entry for skill trials performed by the provider with the client. 
 
Database outline 
• providers
    o Primary Key - provider_id int(11) NOT NULL AUTO_INCREMENT
    o fname varchar(255) NOT NULL
    o lname varchar(255) NOT NULL
    o credentials varchar(255) NOT NULL
    o This entity represents the therapy provider. They have a M:M relationship via appointments with clients.

• clients 
    o Primary Key - client_id int (11) NOT NULL AUTO_INCREMENT o fname varchar(255) NOT NULL
    o lname varchar(255) NOT NULL
    o insurance_num int(20) NOT NULL
    o This entity represents the children receiving the therapy. They have a 1:M relationship with their skills and problem_behaviors.
    o They have a M:M relationship via appointments with providers.

• appointments 
    o Primary Key - appointment_id int (11) NOT NULL AUTO_INCREMENT  
    o date date NOT NULL
    o time time(0) NOT NULL
    o end_time time time(0) NOT NULL
    o These are the appointments that link the providers and clients via M:1 relationships with each; therefore, they use the provider_id and client_id foreign keys.
    o Appointments also have a M:M relationship with skills and problem_behaviors since it is during the appointments that these things are addressed. This is implemented with join tables representing the occurrences of behaviors and skill_trials during the session.

• problem_behaviors 
    o Primary Key - behavior_id int (11) NOT NULL AUTO_INCREMENT
    o name varchar(255) NOT NULL
    o definition varchar(255) NOT NULL
    o Behaviors are typically tracked, if they decrease it is used as evidence of the efficacy of the skill goals. They have a M:M relationship to the appointments via the related data taken by the provider. These data are recorded in the behaviors table. They have a 1:m relationship with behaviors, the occurrences of the problem behavior.
    o These problem_behaviors are linked to the client that exhibits them, the client_id is used to do this.

• skills 
    o Primary Key - skill_id int(11) NOT NULL AUTO_INCREMENT
    o name varchar(255) NOT NULL
    o definition varchar(255) NOT NULL
    o pass_conditon varchar(255) NOT NULL – There is always a predefined condition that the goal will be considered passed such as ’80% successful trials for 3 consecutive sessions’
    o Skill goals are assigned to each child and tracked each appointment to monitor progress. They have a M:M relationship to the appointments via the data kept in the skill_trials table. The skills have a 1:M relationship to the skill_trials.
    o These skills are linked to the client that is working on them, the client_id is used to do this as a foreign key.

• behaviors
    o Primary Key - behavior_event_id int(11) NOT NULL AUTO_INCREMENT
    o time time(0) - some behaviors are monitored by how long they last
    o end_time time time(0)
    o occurrences int – some behaviors are monitored by how many times they occur in a given period of time such as
    o This represents the actual data entries performed by providers.
    o behaviors have a M:1 relationship with problem_behaviors and appointments and reference behavior_id and appointment_id as foreign keys.

• skill_trials
    o Primary Key - skill_trial_id int(11) NOT NULL AUTO_INCREMENT o prompt varchar(20) - refusal, full_physical, partial_physical, model, direct_verbal,  indirect_verbal, gesture, independent – each trial is often marked for how much support was provided to complete a task successfully.
    o passed bool – pass fail data is sometimes taken in leu of monitoring support level
    o This represents the actual data entries performed by providers.
    o Skill_trials have a M:1 relationship with skills and appointments and reference skill_id and appointment_id as foreign keys.

    