CREATE DATABASE QLNhanSu;
USE QLNhanSu;
-- Tạo bảng PhongBan
CREATE TABLE PhongBan (
    MaPhong INT PRIMARY KEY IDENTITY(1,1),
    TenPhong NVARCHAR(255) NOT NULL,
    MaQuanLy INT,
    FOREIGN KEY (MaQuanLy) REFERENCES NhanVien(MaNhanVien)
);

-- Tạo bảng NhanVien
CREATE TABLE NhanVien (
    MaNhanVien INT PRIMARY KEY IDENTITY(1,1),
    TenNhanVien NVARCHAR(255) NOT NULL,
    LaQuanLy BIT NOT NULL,
    MaPhong INT
);

-- Tạo bảng HoatDong
CREATE TABLE HoatDong (
    MaHoatDong INT PRIMARY KEY IDENTITY(1,1),
    TenHoatDong NVARCHAR(255) NOT NULL,
    MaPhong INT,
    FOREIGN KEY (MaPhong) REFERENCES PhongBan(MaPhong)
);

-- Tạo bảng DuAn
CREATE TABLE DuAn (
    MaDuAn INT PRIMARY KEY IDENTITY(1,1),
    TenDuAn NVARCHAR(255) NOT NULL,
    MoTa NVARCHAR(MAX),
    ThoiGianBatDau DATE,
    ThoiGianKetThuc DATE
);

-- Tạo bảng NhanVienDuAn
CREATE TABLE NhanVienDuAn (
    MaNhanVien INT,
    MaDuAn INT,
    PRIMARY KEY (MaNhanVien, MaDuAn),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaDuAn) REFERENCES DuAn(MaDuAn)
);