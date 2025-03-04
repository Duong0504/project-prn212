-- Xóa bảng nếu đã tồn tại để tránh lỗi trùng lặp
DROP TABLE IF EXISTS Violations;
DROP TABLE IF EXISTS Reports;
DROP TABLE IF EXISTS Vehicles;
DROP TABLE IF EXISTS Notifications;
DROP TABLE IF EXISTS Users;

-- Tạo bảng Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Citizen', 'TrafficPolice')),
    Phone NVARCHAR(15) NOT NULL,
    Address NVARCHAR(MAX)
);

-- Tạo bảng Vehicles
CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY IDENTITY(1,1),
    PlateNumber NVARCHAR(15) NOT NULL UNIQUE,
    OwnerID INT NOT NULL,
    Brand NVARCHAR(50),
    Model NVARCHAR(50),
    ManufactureYear INT CHECK (ManufactureYear >= 1900 AND ManufactureYear <= YEAR(GETDATE())),
    FOREIGN KEY (OwnerID) REFERENCES Users(UserID)
);

-- Tạo bảng Reports
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    ReporterID INT NOT NULL,
    ViolationType NVARCHAR(50) NOT NULL,
    Description TEXT NOT NULL,
    PlateNumber NVARCHAR(15) NOT NULL,
    ImageURL NVARCHAR(MAX),
    VideoURL NVARCHAR(MAX),
    Location NVARCHAR(255) NOT NULL,
    ReportDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Approved', 'Rejected')),
    ProcessedBy INT NULL,

    FOREIGN KEY (ReporterID) REFERENCES Users(UserID),
    FOREIGN KEY (ProcessedBy) REFERENCES Users(UserID),
    FOREIGN KEY (PlateNumber) REFERENCES Vehicles(PlateNumber)
);

-- Tạo bảng Violations
CREATE TABLE Violations (
    ViolationID INT PRIMARY KEY IDENTITY(1,1),
    ReportID INT NOT NULL,
    PlateNumber NVARCHAR(15) NOT NULL,
    ViolatorID INT NULL,
    FineAmount DECIMAL(10,2) NOT NULL,
    FineDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaidStatus BIT DEFAULT 0,

    FOREIGN KEY (ReportID) REFERENCES Reports(ReportID),
    FOREIGN KEY (PlateNumber) REFERENCES Vehicles(PlateNumber),
    FOREIGN KEY (ViolatorID) REFERENCES Users(UserID)
);

-- Tạo bảng Notifications
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Message TEXT NOT NULL,
    PlateNumber NVARCHAR(15),
    SentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsRead BIT DEFAULT 0,

    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PlateNumber) REFERENCES Vehicles(PlateNumber)
);

-- Thêm dữ liệu mẫu vào bảng Users
INSERT INTO Users (FullName, Email, Password, Role, Phone, Address)
VALUES 
    ('Nguyen Van A', 'nguyenvana@example.com', 'password123', 'Citizen', '0123456789', 'Hanoi'),
    ('Dinh Xuan Duong', 'duongkoi0504@example.com', 'admin123', 'TrafficPolice', '023456789', N'ThanhHoa');

-- Xác nhận dữ liệu đã thêm thành công
SELECT * FROM Users;

IF NOT EXISTS (SELECT 1 FROM Vehicles WHERE PlateNumber = '30A-6789')
BEGIN
    INSERT INTO Vehicles (PlateNumber, OwnerID)
    VALUES ('30A-6789', 1);
END

INSERT INTO Notifications (UserID, Message, PlateNumber, SentDate, IsRead)
VALUES (1, 'Violations', '30A-6789', '2025-04-03 00:00:00', 0);
SELECT * FROM Notifications;