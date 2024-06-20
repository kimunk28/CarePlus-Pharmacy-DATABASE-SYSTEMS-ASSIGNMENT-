

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";




--
-- Database: `hms`
--

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `SSN` INT(10) NOT NULL AUTO_INCREMENT,
  `last_name` VARCHAR(15),
  `first_name` VARCHAR(15),
  `speciality` VARCHAR(20),
  `years_of_experience` INT,
  PRIMARY KEY (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`SSN`, `last_name`, `first_name`, `speciality`, `years_of_experience`) VALUES
(1, 'Chomba', 'Gloria', 'Neurology', 10),
(2, 'Goma', 'Yes', 'Pediatrics', 5);

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `SSN` int(11) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `birth_date` date NOT NULL,
  `primary_doctorSSN` int(11) NOT NULL,
  PRIMARY KEY (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`SSN`, `last_name`, `first_name`, `city`, `address`, `birth_date`, `primary_doctorSSN`) VALUES
(25778987, 'Mbewe', 'Richard', 'Ndola', 'CBU', '2020-02-02', 1),
(25743211, 'Gary', 'Nelson', 'Kitwe', 'Plot No. 334', '2005-06-05', 2);

--
-- Triggers `patients`
--
DELIMITER $$
CREATE TRIGGER `PatientDelete` BEFORE DELETE ON `patients` FOR EACH ROW INSERT INTO trigr VALUES(null,OLD.SSN,OLD.last_name,OLD.first_name,'PATIENT DELETED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `PatientUpdate` AFTER UPDATE ON `patients` FOR EACH ROW INSERT INTO trigr VALUES(null,NEW.SSN,NEW.last_name,NEW.first_name,'PATIENT UPDATED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `patientinsertion` AFTER INSERT ON `patients` FOR EACH ROW INSERT INTO trigr VALUES(null,NEW.SSN,NEW.last_name,NEW.first_name,'PATIENT INSERTED',NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

CREATE TABLE `test` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `email` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `test`
--

INSERT INTO `test` (`id`, `name`, `email`) VALUES
(1, 'ANEES', 'ARK@GMAIL.COM'),
(2, 'test', 'test@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `trigr`
--

CREATE TABLE `trigr` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `trigr`
--

INSERT INTO `trigr` (`tid`, `pid`, `email`, `name`, `action`, `timestamp`) VALUES
(1, 12, 'anees@gmail.com', 'ANEES', 'PATIENT INSERTED', '2020-12-02 16:35:10'),
(2, 11, 'anees@gmail.com', 'anees', 'PATIENT INSERTED', '2020-12-02 16:37:34'),
(3, 10, 'anees@gmail.com', 'anees', 'PATIENT UPDATED', '2020-12-02 16:38:27'),
(4, 11, 'anees@gmail.com', 'anees', 'PATIENT UPDATED', '2020-12-02 16:38:33'),
(5, 12, 'anees@gmail.com', 'ANEES', 'PATIENT DELETED', '2020-12-02 16:40:40'),
(6, 11, 'anees@gmail.com', 'anees', 'PATIENT DELETED', '2020-12-02 16:41:10'),
(7, 13, 'testing@gmail.com', 'testing', 'PATIENT INSERTED', '2020-12-02 16:50:21'),
(8, 13, 'testing@gmail.com', 'testing', 'PATIENT UPDATED', '2020-12-02 16:50:32'),
(9, 13, 'testing@gmail.com', 'testing', 'PATIENT DELETED', '2020-12-02 16:50:57'),
(10, 14, 'aneeqah@gmail.com', 'aneeqah', 'PATIENT INSERTED', '2021-01-22 15:18:09'),
(11, 14, 'aneeqah@gmail.com', 'aneeqah', 'PATIENT UPDATED', '2021-01-22 15:18:29'),
(12, 14, 'aneeqah@gmail.com', 'aneeqah', 'PATIENT DELETED', '2021-01-22 15:41:48'),
(13, 15, 'khushi@gmail.com', 'khushi', 'PATIENT INSERTED', '2021-01-22 15:43:02'),
(14, 15, 'khushi@gmail.com', 'khushi', 'PATIENT UPDATED', '2021-01-22 15:43:11'),
(15, 16, 'khushi@gmail.com', 'khushi', 'PATIENT INSERTED', '2021-01-22 15:43:37'),
(16, 16, 'khushi@gmail.com', 'khushi', 'PATIENT UPDATED', '2021-01-22 15:43:49'),
(17, 17, 'aneeqah@gmail.com', 'aneeqah', 'PATIENT INSERTED', '2021-01-22 15:44:41'),
(18, 17, 'aneeqah@gmail.com', 'aneeqah', 'PATIENT UPDATED', '2021-01-22 15:44:52'),
(19, 17, 'aneeqah@gmail.com', 'aneeqah', 'PATIENT UPDATED', '2021-01-22 15:44:59');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `usertype` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `usertype`, `email`, `password`) VALUES
(13, 'anees', 'Doctor', 'anees@gmail.com', 'pbkdf2:sha256:150000$xAKZCiJG$4c7a7e704708f86659d730565ff92e8327b01be5c49a6b1ef8afdf1c531fa5c3'),
(14, 'aneeqah', 'Patient', 'aneeqah@gmail.com', 'pbkdf2:sha256:150000$Yf51ilDC$028cff81a536ed9d477f9e45efcd9e53a9717d0ab5171d75334c397716d581b8'),
(15, 'khushi', 'Patient', 'khushi@gmail.com', 'pbkdf2:sha256:150000$BeSHeRKV$a8b27379ce9b2499d4caef21d9d387260b3e4ba9f7311168b6e180a00db91f22');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `doctors`
--

--
-- Indexes for table `patients`
--

--
-- Indexes for table `test`
--

--
-- Indexes for table `trigr`
--

--
-- Indexes for table `user`
--

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `SSN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `SSN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `test`
--
ALTER TABLE `test`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `trigr`
--
ALTER TABLE `trigr`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
