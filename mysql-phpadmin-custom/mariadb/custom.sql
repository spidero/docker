-- PASSWORD=pass
GRANT USAGE ON *.* TO `users`@`%` IDENTIFIED BY PASSWORD '*196BDEDE2AE4F84CA44C47D54D78478C7E2BD7B7';

GRANT ALL PRIVILEGES ON `users`.* TO `users`@`%`;

CREATE DATABASE IF NOT EXISTS `users` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `login` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


INSERT INTO `users` (`id`, `login`, `name`, `description`) VALUES
(1, 'admin', 'John Doe', 'admin user'),
(2, 'user', 'Joe Doe', 'user');