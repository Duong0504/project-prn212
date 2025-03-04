USE [projprn];
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Citizen', 'TrafficPolice')),
    Phone VARCHAR(15) NOT NULL,
    Address TEXT NULL
);
GO

CREATE TABLE Vehicles (
    VehicleID INT IDENTITY(1,1) PRIMARY KEY,
    PlateNumber VARCHAR(15) NOT NULL UNIQUE,
    OwnerID INT NOT NULL,
    Brand VARCHAR(50),
    Model VARCHAR(50),
    ManufactureYear INT, 
    FOREIGN KEY (OwnerID) REFERENCES Users(UserID)
);
GO

CREATE TABLE Reports (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReporterID INT NOT NULL,
    ViolationType VARCHAR(50) NOT NULL,
    Description TEXT NOT NULL,
    PlateNumber VARCHAR(15) NOT NULL,
    ImageURL TEXT,
    VideoURL TEXT,
    Location VARCHAR(255) NOT NULL,
    ReportDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Approved', 'Rejected')), 
    ProcessedBy INT NULL,
    FOREIGN KEY (ReporterID) REFERENCES Users(UserID),
    FOREIGN KEY (ProcessedBy) REFERENCES Users(UserID),
    FOREIGN KEY (PlateNumber) REFERENCES Vehicles(PlateNumber)
);
GO

-- B?ng Violations
CREATE TABLE Violations (
    ViolationID INT IDENTITY(1,1) PRIMARY KEY,
    ReportID INT NOT NULL,
    PlateNumber VARCHAR(15) NOT NULL,
    ViolatorID INT NULL,
    FineAmount DECIMAL(10,2) NOT NULL,
    FineDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaidStatus BIT DEFAULT 0, -- Thay BOOLEAN b?ng BIT
    FOREIGN KEY (ReportID) REFERENCES Reports(ReportID),
    FOREIGN KEY (PlateNumber) REFERENCES Vehicles(PlateNumber),
    FOREIGN KEY (ViolatorID) REFERENCES Users(UserID)
);
GO

CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Message TEXT NOT NULL,
    PlateNumber VARCHAR(15) NULL,
    SentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsRead BIT DEFAULT 0, 
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PlateNumber) REFERENCES Vehicles(PlateNumber)
);
GO
