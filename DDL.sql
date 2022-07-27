SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

--
-- Table structure for table `appointments`
--
DROP TABLE IF EXISTS `appointments`;
DROP TABLE IF EXISTS `behaviors`;
DROP TABLE IF EXISTS `clients`;
DROP TABLE IF EXISTS `problem_behaviors`;
DROP TABLE IF EXISTS `providers`;
DROP TABLE IF EXISTS `skills`;
DROP TABLE IF EXISTS `skill_trials`;

CREATE OR REPLACE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `end_time` time NOT NULL,
  `providers_provider_id` int(11) NULL,
  `clients_client_id` int(11) NOT NULL,
  PRIMARY KEY (`appointment_id`),
  KEY `fk_appointments_providers_idx` (`providers_provider_id`),
  KEY `fk_appointments_clients1_idx` (`clients_client_id`),
    CONSTRAINT `fk_appointments_clients1` 
    FOREIGN KEY (`clients_client_id`) 
    REFERENCES `clients` (`client_id`) 
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `date`, `time`, `end_time`, `providers_provider_id`, `clients_client_id`) VALUES
(24, '2022-04-02', '01:30:00', '14:30:00', 1, 10),
(25, '2022-03-15', '02:00:00', '18:00:00', 2, 11),
(26, '2022-01-05', '02:30:00', '14:30:00', 3, 10),
(27, '2022-04-22', '03:00:00', '18:00:00', 4, 11),
(28, '2022-02-16', '03:30:00', '14:30:00', 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `behaviors`
--

CREATE OR REPLACE TABLE  `behaviors` (
  `behavior_event_id` int(11) NOT NULL AUTO_INCREMENT,
  `time` time NOT NULL,
  `end_time` time NOT NULL,
  `ocurrences` int(11) DEFAULT NULL,
  `appointments_appointment_id` int(11) NOT NULL,
  `problem_behaviors_behavior_id` int(11) NOT NULL,
  PRIMARY KEY (`behavior_event_id`),
  KEY `fk_behaviors_appointments1_idx` (`appointments_appointment_id`),
  KEY `fk_behaviors_problem_behaviors1_idx` (`problem_behaviors_behavior_id`),
  CONSTRAINT `fk_behaviors_appointments1` 
    FOREIGN KEY (`appointments_appointment_id`) 
    REFERENCES `appointments` (`appointment_id`) 
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table `behaviors`
--

INSERT INTO `behaviors` (`behavior_event_id`, `time`, `end_time`, `ocurrences`, `appointments_appointment_id`, `problem_behaviors_behavior_id`) VALUES
(66, '00:00:00', '00:00:00', 4, 24, 38),
(67, '12:45:00', '12:55:00', NULL, 24, 39),
(68, '00:00:00', '00:00:00', 15, 24, 40),
(69, '00:00:00', '00:00:00', 3, 25, 41),
(70, '00:00:00', '00:00:00', 4, 25, 42);

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE OR REPLACE TABLE  `clients` (
  `client_id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `insurance_num` int(20) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`client_id`, `fname`, `lname`, `insurance_num`) VALUES
(10, 'Bart', 'Simpson', 123456789),
(11, 'Nelson', 'Muntz', 234567891),
(12, 'Malcolm', 'Wilkerson', 345678912),
(13, 'Reese', 'Wilkerson', 456789132),
(14, 'Dewey', 'Wilkerson', 331131311);

-- --------------------------------------------------------
--
-- Table structure for table `problem_behaviors`
--

CREATE OR REPLACE TABLE  `problem_behaviors` (
  `behavior_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `definition` varchar(255) NOT NULL,
  `clients_client_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`behavior_id`),
  KEY `fk_problem_behaviors_clients1_idx` (`clients_client_id`),
  CONSTRAINT `fk_problem_behaviors_clients1` 
    FOREIGN KEY (`clients_client_id`) 
    REFERENCES `clients` (`client_id`) 
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `problem_behaviors`
--

INSERT INTO `problem_behaviors` (`behavior_id`, `name`, `definition`, `clients_client_id`) VALUES
(38, 'Defacing Property', 'Bart will write on surfaces that are not intended for writing', 10),
(39, 'Eloping', 'Bart will leave the area where his responsible adult is without consent', 10),
(40, 'Hitting', 'Nelson hits his peers when he becomes frustrated', 11),
(41, 'Kicking', 'Nelson kicks his peers when he loses games', 11),
(42, 'Name calling', 'Nelson calls others hurtful names', 11);

-- --------------------------------------------------------

--
-- Table structure for table `providers`
--

CREATE OR REPLACE TABLE  `providers` (
  `provider_id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `credentials` varchar(255) NOT NULL,
  PRIMARY KEY (`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `providers`
--

INSERT INTO `providers` (`provider_id`, `fname`, `lname`, `credentials`) VALUES
(1, 'Edna', 'Krabappel', 'BS.IS.'),
(2, 'Seymore', 'Skinner', 'MA.IP.'),
(3, 'Miss', 'Wormwood', 'BS.IS.'),
(4, 'Valerie', 'Frizzle', 'PhD.IP.'),
(5, 'Dewey', 'Finn', 'BS.IS.');

-- --------------------------------------------------------
--
-- Table structure for table `skills`
--

CREATE OR REPLACE TABLE  `skills` (
  `skills_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `definition` varchar(255) NOT NULL,
  `pass_condition` varchar(255) NOT NULL,
  `clients_client_id` int(11) NOT NULL,
  PRIMARY KEY (`skills_id`),
  KEY `fk_skills_clients1_idx` (`clients_client_id`),
  CONSTRAINT `fk_skills_clients1` 
    FOREIGN KEY (`clients_client_id`) 
    REFERENCES `clients` (`client_id`) 
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`skills_id`, `name`, `definition`, `pass_condition`, `clients_client_id`) VALUES
(52, 'Practice coping skills', 'When Bart becomes frustrated, he will write or draw in a journal rather than on other surfaces\r\n\r\n', '1', 10),
(53, 'Speaking respectfully to adults', 'When Bart is given a contrived scenario, he will demonstrate a respectful comment to an adult', '1', 10),
(54, 'Wearing safety equipment when skateboarding', 'Bart will wear a helmet when riding his skateboard', '1', 10),
(55, 'Verbalizing his needs', 'Nelson will tell an adult when he needs something such as when he is hungry', '1', 11),
(56, 'Practice coping skills', 'Nelson will ask to take a break when he becomes frustrated', '1', 11);

-- --------------------------------------------------------
--
-- Table structure for table `skill_trials`
--

CREATE OR REPLACE TABLE `skill_trials` (
  `skill_trial_id` int(11) NOT NULL AUTO_INCREMENT,
  `prompt` varchar(20) DEFAULT NULL,
  `passed` tinyint(4) DEFAULT NULL,
  `appointments_appointment_id` int(11) NOT NULL,
  `skills_skills_id` int(11) NOT NULL,
  PRIMARY KEY (`skill_trial_id`),
  KEY `fk_skill_trials_appointments1_idx` (`appointments_appointment_id`),
  KEY `fk_skill_trials_skills1_idx` (`skills_skills_id`),
  CONSTRAINT `fk_skill_trials_appointments1` 
    FOREIGN KEY (`appointments_appointment_id`) 
    REFERENCES `appointments` (`appointment_id`) 
  ON DELETE CASCADE,
  CONSTRAINT `fk_skill_trials_skills1` 
    FOREIGN KEY (`skills_skills_id`) 
    REFERENCES `skills` (`skills_id`) 
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `skill_trials`
--

INSERT INTO `skill_trials` (`skill_trial_id`, `prompt`, `passed`, `appointments_appointment_id`, `skills_skills_id`) VALUES
(80, 'direct_verbal', NULL, 24, 52),
(81, 'model', NULL, 24, 53),
(82, 'refuse', NULL, 24, 54),
(83, NULL, 0, 25, 55),
(84, 'indirect_verbal', NULL, 25, 56);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

--
-- Table structure for table `appointments`
--
DROP TABLE IF EXISTS `appointments`;
DROP TABLE IF EXISTS `behaviors`;
DROP TABLE IF EXISTS `clients`;
DROP TABLE IF EXISTS `problem_behaviors`;
DROP TABLE IF EXISTS `providers`;
DROP TABLE IF EXISTS `skills`;
DROP TABLE IF EXISTS `skill_trials`;

CREATE OR REPLACE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `end_time` time NOT NULL,
  `providers_provider_id` int(11) NULL,
  `clients_client_id` int(11) NOT NULL,
  PRIMARY KEY (`appointment_id`),
  KEY `fk_appointments_providers_idx` (`providers_provider_id`),
  KEY `fk_appointments_clients1_idx` (`clients_client_id`),
    CONSTRAINT `fk_appointments_clients1`
    FOREIGN KEY (`clients_client_id`)
    REFERENCES `clients` (`client_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `date`, `time`, `end_time`, `providers_provider_id`, `clients_client_id`) VALUES
(24, '2022-04-02', '01:30:00', '14:30:00', 1, 10),
(25, '2022-03-15', '02:00:00', '18:00:00', 2, 11),
(26, '2022-01-05', '02:30:00', '14:30:00', 3, 10),
(27, '2022-04-22', '03:00:00', '18:00:00', 4, 11),
(28, '2022-02-16', '03:30:00', '14:30:00', 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `behaviors`
--

CREATE OR REPLACE TABLE  `behaviors` (
  `behavior_event_id` int(11) NOT NULL AUTO_INCREMENT,
  `time` time NOT NULL,
  `end_time` time NOT NULL,
  `ocurrences` int(11) DEFAULT NULL,
  `appointments_appointment_id` int(11) NOT NULL,
  `problem_behaviors_behavior_id` int(11) NOT NULL,
  PRIMARY KEY (`behavior_event_id`),
  KEY `fk_behaviors_appointments1_idx` (`appointments_appointment_id`),
  KEY `fk_behaviors_problem_behaviors1_idx` (`problem_behaviors_behavior_id`),
  CONSTRAINT `fk_behaviors_appointments1`
    FOREIGN KEY (`appointments_appointment_id`)
    REFERENCES `appointments` (`appointment_id`)
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table `behaviors`
--

INSERT INTO `behaviors` (`behavior_event_id`, `time`, `end_time`, `ocurrences`, `appointments_appointment_id`, `problem_behaviors_behavior_id`) VALUES
(66, '00:00:00', '00:00:00', 4, 24, 38),
(67, '12:45:00', '12:55:00', NULL, 24, 39),
(68, '00:00:00', '00:00:00', 15, 24, 40),
(69, '00:00:00', '00:00:00', 3, 25, 41),
(70, '00:00:00', '00:00:00', 4, 25, 42);

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE OR REPLACE TABLE  `clients` (
  `client_id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `insurance_num` int(20) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`client_id`, `fname`, `lname`, `insurance_num`) VALUES
(10, 'Bart', 'Simpson', 123456789),
(11, 'Nelson', 'Muntz', 234567891),
(12, 'Malcolm', 'Wilkerson', 345678912),
(13, 'Reese', 'Wilkerson', 456789132),
(14, 'Dewey', 'Wilkerson', 331131311);

-- --------------------------------------------------------
--
-- Table structure for table `problem_behaviors`
--

CREATE OR REPLACE TABLE  `problem_behaviors` (
  `behavior_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `definition` varchar(255) NOT NULL,
  `clients_client_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`behavior_id`),
  KEY `fk_problem_behaviors_clients1_idx` (`clients_client_id`),
  CONSTRAINT `fk_problem_behaviors_clients1`
    FOREIGN KEY (`clients_client_id`)
    REFERENCES `clients` (`client_id`)
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `problem_behaviors`
--

INSERT INTO `problem_behaviors` (`behavior_id`, `name`, `definition`, `clients_client_id`) VALUES
(38, 'Defacing Property', 'Bart will write on surfaces that are not intended for writing', 10),
(39, 'Eloping', 'Bart will leave the area where his responsible adult is without consent', 10),
(40, 'Hitting', 'Nelson hits his peers when he becomes frustrated', 11),
(41, 'Kicking', 'Nelson kicks his peers when he loses games', 11),
(42, 'Name calling', 'Nelson calls others hurtful names', 11);

-- --------------------------------------------------------

--
-- Table structure for table `providers`
--

CREATE OR REPLACE TABLE  `providers` (
  `provider_id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `credentials` varchar(255) NOT NULL,
  PRIMARY KEY (`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `providers`
--

INSERT INTO `providers` (`provider_id`, `fname`, `lname`, `credentials`) VALUES
(1, 'Edna', 'Krabappel', 'BS.IS.'),
(2, 'Seymore', 'Skinner', 'MA.IP.'),
(3, 'Miss', 'Wormwood', 'BS.IS.'),
(4, 'Valerie', 'Frizzle', 'PhD.IP.'),
(5, 'Dewey', 'Finn', 'BS.IS.');

-- --------------------------------------------------------
--
-- Table structure for table `skills`
--

CREATE OR REPLACE TABLE  `skills` (
  `skills_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `definition` varchar(255) NOT NULL,
  `pass_condition` varchar(255) NOT NULL,
  `clients_client_id` int(11) NOT NULL,
  PRIMARY KEY (`skills_id`),
  KEY `fk_skills_clients1_idx` (`clients_client_id`),
  CONSTRAINT `fk_skills_clients1`
    FOREIGN KEY (`clients_client_id`)
    REFERENCES `clients` (`client_id`)
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`skills_id`, `name`, `definition`, `pass_condition`, `clients_client_id`) VALUES
(52, 'Practice coping skills', 'When Bart becomes frustrated, he will write or draw in a journal rather than on other surfaces\r\n\r\n', '1', 10),
(53, 'Speaking respectfully to adults', 'When Bart is given a contrived scenario, he will demonstrate a respectful comment to an adult', '1', 10),
(54, 'Wearing safety equipment when skateboarding', 'Bart will wear a helmet when riding his skateboard', '1', 10),
(55, 'Verbalizing his needs', 'Nelson will tell an adult when he needs something such as when he is hungry', '1', 11),
(56, 'Practice coping skills', 'Nelson will ask to take a break when he becomes frustrated', '1', 11);

-- --------------------------------------------------------
--
-- Table structure for table `skill_trials`
--

CREATE OR REPLACE TABLE `skill_trials` (
  `skill_trial_id` int(11) NOT NULL AUTO_INCREMENT,
  `prompt` varchar(20) DEFAULT NULL,
  `passed` tinyint(4) DEFAULT NULL,
  `appointments_appointment_id` int(11) NOT NULL,
  `skills_skills_id` int(11) NOT NULL,
  PRIMARY KEY (`skill_trial_id`),
  KEY `fk_skill_trials_appointments1_idx` (`appointments_appointment_id`),
  KEY `fk_skill_trials_skills1_idx` (`skills_skills_id`),
  CONSTRAINT `fk_skill_trials_appointments1`
    FOREIGN KEY (`appointments_appointment_id`)
    REFERENCES `appointments` (`appointment_id`)
  ON DELETE CASCADE,
  CONSTRAINT `fk_skill_trials_skills1`
    FOREIGN KEY (`skills_skills_id`)
    REFERENCES `skills` (`skills_id`)
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `skill_trials`
--

INSERT INTO `skill_trials` (`skill_trial_id`, `prompt`, `passed`, `appointments_appointment_id`, `skills_skills_id`) VALUES
(80, 'direct_verbal', NULL, 24, 52),
(81, 'model', NULL, 24, 53),
(82, 'refuse', NULL, 24, 54),
(83, NULL, 0, 25, 55),
(84, 'indirect_verbal', NULL, 25, 56);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;