-- יצירת בסיס הנתונים אם לא קיים
CREATE DATABASE IF NOT EXISTS `exampleDb`;

-- הרשאות למשתמש flaskapp
CREATE USER IF NOT EXISTS 'flaskapp'@'%' IDENTIFIED BY 'flaskapp';
GRANT ALL PRIVILEGES ON `exampleDb`.* TO 'flaskapp'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- שימוש בבסיס הנתונים
USE exampleDb;

-- יצירת הטבלה people אם לא קיימת
CREATE TABLE IF NOT EXISTS `people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `address` varchar(100) NOT NULL,
  `workplace` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10001;

-- הכנסת נתוני דמו
INSERT INTO `people` (`firstName`, `lastName`, `age`, `address`, `workplace`) VALUES
('John', 'Doe', 30, '123 Main St, New York, NY 10030', 'Google'),
('Jane', 'Doe', 28, '123 Main St, New York, NY 10030', 'Microsoft'),
('Jack', 'Doe', 25, '123 Main St, New York, NY 10030', 'Amazon');
