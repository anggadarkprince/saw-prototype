-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2014 at 10:40 AM
-- Server version: 5.6.16
-- PHP Version: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `saw`
--

-- --------------------------------------------------------

--
-- Table structure for table `kriteria`
--

CREATE TABLE IF NOT EXISTS `kriteria` (
  `id_kriteria` int(11) NOT NULL AUTO_INCREMENT,
  `kriteria` varchar(30) NOT NULL,
  PRIMARY KEY (`id_kriteria`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `kriteria`
--

INSERT INTO `kriteria` (`id_kriteria`, `kriteria`) VALUES
(1, 'tofl'),
(2, 'iq'),
(3, 'ipk');

-- --------------------------------------------------------

--
-- Table structure for table `kriteria_lowongan`
--

CREATE TABLE IF NOT EXISTS `kriteria_lowongan` (
  `id_kriteria_lowongan` int(11) NOT NULL AUTO_INCREMENT,
  `id_kriteria` int(11) NOT NULL,
  `id_lowongan` int(11) NOT NULL,
  `atribut` enum('BENEFIT','COST') NOT NULL,
  `bobot` double NOT NULL,
  PRIMARY KEY (`id_kriteria_lowongan`),
  KEY `id_kriteria` (`id_kriteria`),
  KEY `id_lowongan` (`id_lowongan`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `kriteria_lowongan`
--

INSERT INTO `kriteria_lowongan` (`id_kriteria_lowongan`, `id_kriteria`, `id_lowongan`, `atribut`, `bobot`) VALUES
(1, 1, 1, 'BENEFIT', 0.6),
(2, 2, 1, 'BENEFIT', 0.25),
(3, 3, 1, 'COST', 0.15);

-- --------------------------------------------------------

--
-- Table structure for table `lowongan`
--

CREATE TABLE IF NOT EXISTS `lowongan` (
  `id_lowongan` int(11) NOT NULL AUTO_INCREMENT,
  `kategori` varchar(30) NOT NULL,
  PRIMARY KEY (`id_lowongan`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `lowongan`
--

INSERT INTO `lowongan` (`id_lowongan`, `kategori`) VALUES
(1, 'akuntansi'),
(2, 'manajemen'),
(3, 'OB');

-- --------------------------------------------------------

--
-- Table structure for table `pilihan`
--

CREATE TABLE IF NOT EXISTS `pilihan` (
  `id_pilihan` int(11) NOT NULL AUTO_INCREMENT,
  `id_user_lowongan` int(11) NOT NULL,
  `id_sub` int(11) NOT NULL,
  PRIMARY KEY (`id_pilihan`),
  KEY `id_user` (`id_user_lowongan`),
  KEY `id_sub` (`id_sub`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `pilihan`
--

INSERT INTO `pilihan` (`id_pilihan`, `id_user_lowongan`, `id_sub`) VALUES
(1, 1, 2),
(2, 1, 8),
(3, 1, 11),
(4, 2, 3),
(5, 2, 6),
(6, 2, 11),
(7, 3, 3),
(8, 3, 7),
(9, 3, 11);

-- --------------------------------------------------------

--
-- Table structure for table `subnilai`
--

CREATE TABLE IF NOT EXISTS `subnilai` (
  `id_sub` int(11) NOT NULL AUTO_INCREMENT,
  `id_kriteria` int(11) NOT NULL,
  `nama_sub` varchar(30) NOT NULL,
  `bobot` double NOT NULL,
  PRIMARY KEY (`id_sub`),
  KEY `id_kriteria` (`id_kriteria`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `subnilai`
--

INSERT INTO `subnilai` (`id_sub`, `id_kriteria`, `nama_sub`, `bobot`) VALUES
(1, 1, '301-400', 0),
(2, 1, '401-500', 0.3),
(3, 1, '501-600', 0.67),
(4, 1, '>600', 1),
(5, 2, '71-80', 0),
(6, 2, '81-90', 0.25),
(7, 2, '91-100', 0.5),
(8, 2, '101-120', 0.75),
(9, 2, '>120', 1),
(10, 3, '2.8-3.5', 0),
(11, 3, '3.5-4', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(30) NOT NULL,
  PRIMARY KEY (`id_user`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama`) VALUES
(1, 'angga'),
(2, 'ryan'),
(3, 'roni');

-- --------------------------------------------------------

--
-- Table structure for table `user_lowongan`
--

CREATE TABLE IF NOT EXISTS `user_lowongan` (
  `id_user_lowongan` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_lowongan` int(11) NOT NULL,
  PRIMARY KEY (`id_user_lowongan`),
  KEY `id_user` (`id_user`),
  KEY `id_lowongan` (`id_lowongan`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `user_lowongan`
--

INSERT INTO `user_lowongan` (`id_user_lowongan`, `id_user`, `id_lowongan`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kriteria_lowongan`
--
ALTER TABLE `kriteria_lowongan`
  ADD CONSTRAINT `kriteria_lowongan_ibfk_2` FOREIGN KEY (`id_lowongan`) REFERENCES `lowongan` (`id_lowongan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `kriteria_lowongan_ibfk_1` FOREIGN KEY (`id_kriteria`) REFERENCES `kriteria` (`id_kriteria`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pilihan`
--
ALTER TABLE `pilihan`
  ADD CONSTRAINT `pilihan_ibfk_4` FOREIGN KEY (`id_sub`) REFERENCES `subnilai` (`id_sub`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pilihan_ibfk_3` FOREIGN KEY (`id_user_lowongan`) REFERENCES `user_lowongan` (`id_user_lowongan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `subnilai`
--
ALTER TABLE `subnilai`
  ADD CONSTRAINT `subnilai_ibfk_1` FOREIGN KEY (`id_kriteria`) REFERENCES `kriteria` (`id_kriteria`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_lowongan`
--
ALTER TABLE `user_lowongan`
  ADD CONSTRAINT `user_lowongan_ibfk_2` FOREIGN KEY (`id_lowongan`) REFERENCES `lowongan` (`id_lowongan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_lowongan_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
