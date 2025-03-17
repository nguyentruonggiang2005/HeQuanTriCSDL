select * from NhanVienDuAn
select * from DuAn
select * from NhanVien
select * from PhongBan
SELECT TenNhanVien, MaPhong FROM NhanVien; --lấy tên và phòng của tất cả nhân viên
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Nguyễn Văn I', 0, 1);-- thêm một nhân viên mới
UPDATE NhanVien SET TenNhanVien = N'Nguyễn Văn A1' WHERE MaNhanVien = 1;--cập nhật tên của nhân viên 
--lấy tên nhân viên cùng với phòng của
SELECT N.TenNhanVien, P.TenPhong
FROM NhanVien N
INNER JOIN PhongBan P ON N.MaPhong = P.MaPhong;
--đếm số lượng nhân viên trong mỗi phòng
SELECT MaPhong, COUNT(*) AS SoLuongNhanVien
FROM NhanVien
GROUP BY MaPhong;
--lấy các phòng có hơn 2 nhân viên 
SELECT MaPhong, COUNT(*) AS SoLuongNhanVien
FROM NhanVien
GROUP BY MaPhong
HAVING COUNT(*) > 2;
--lấy danh sách nhân viên cùng với dự án mà họ tham gia
SELECT N.TenNhanVien, D.TenDuAn
FROM NhanVien N
INNER JOIN NhanVienDuAn NDA ON N.MaNhanVien = NDA.MaNhanVien
INNER JOIN DuAn D ON NDA.MaDuAn = D.MaDuAn;

--Tạo 7- 10 view từ cơ bản đến nâng cao
--VIEW danh sách tất cả nhân viên
CREATE VIEW View_DanhSachNhanVien AS
SELECT * FROM NhanVien;
--view danh sách phòng ban
CREATE VIEW View_DanhSachPhongBan AS
SELECT * FROM PhongBan;
--view danh sách nhân viên là quản lý
CREATE VIEW View_QuanLy AS
SELECT * FROM NhanVien
WHERE LaQuanLy = 1;
--view danh sách nhân viên theo phòng
CREATE VIEW View_NhanVienTheoPhong AS
SELECT N.TenNhanVien, P.TenPhong
FROM NhanVien N
INNER JOIN PhongBan P ON N.MaPhong = P.MaPhong;
--view số lượng nhân viên trong mỗi phòng
CREATE VIEW View_SoLuongNhanVienTheoPhong AS
SELECT P.TenPhong, COUNT(N.MaNhanVien) AS SoLuongNhanVien
FROM PhongBan P
LEFT JOIN NhanVien N ON P.MaPhong = N.MaPhong
GROUP BY P.TenPhong;
--view danh sách nhân viên với dự án mà họ tham gia
CREATE VIEW View_NhanVienDuAn AS
SELECT N.TenNhanVien, D.TenDuAn
FROM NhanVien N
INNER JOIN NhanVienDuAn NDA ON N.MaNhanVien = NDA.MaNhanVien
INNER JOIN DuAn D ON NDA.MaDuAn = D.MaDuAn;
--view danh sách phòng có nhiều hơn 2 nhân viên
CREATE VIEW View_PhongCoNhieuNhanVien AS
SELECT P.TenPhong, COUNT(N.MaNhanVien) AS SoLuongNhanVien
FROM PhongBan P
LEFT JOIN NhanVien N ON P.MaPhong = N.MaPhong
GROUP BY P.TenPhong
HAVING COUNT(N.MaNhanVien) > 2;


--tạo index cho bảng nhân viên( cột mã phòng)
CREATE INDEX IDX_NhanVien_MaPhong ON NhanVien(MaPhong);
--tạo index cho bảng phòng ban( cột mã quản lý)
CREATE INDEX IDX_PhongBan_MaQuanLy ON PhongBan(MaQuanLy);
--tạo index cho bảng hoạt động( cột mã phòng)
CREATE INDEX IDX_HoatDong_MaPhong ON HoatDong(MaPhong);
--tạo index cho bảng dự án( cột tên dự án)
CREATE INDEX IDX_DuAn_TenDuAn ON DuAn(TenDuAn);
--tạo index cho bảng nhân viên dự án
--( cột mã dự án)
CREATE INDEX IDX_NhanVienDuAn_MaDuAn ON NhanVienDuAn(MaDuAn);
--(cột mã nhân viên)
CREATE INDEX IDX_NhanVienDuAn_MaNhanVien ON NhanVienDuAn(MaNhanVien);

--Hàm tính số lượng nhân viên trong một phòng
CREATE FUNCTION dbo.CountEmployeesInRoom(@MaPhong INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaPhong = @MaPhong;
    RETURN @Count;
END;
 --Hàm kiểm tra xem một nhân viên có phải là quản lý không
 CREATE FUNCTION dbo.IsManager(@MaNhanVien INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;
    SELECT @Result = CASE WHEN LaQuanLy = 1 THEN 1 ELSE 0 END
    FROM NhanVien WHERE MaNhanVien = @MaNhanVien;
    RETURN @Result;
END;
--Hàm lấy tên phòng theo mã phòng
CREATE FUNCTION dbo.GetRoomName(@MaPhong INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @TenPhong NVARCHAR(255);
    SELECT @TenPhong = TenPhong FROM PhongBan WHERE MaPhong = @MaPhong;
    RETURN @TenPhong;
END;
--Hàm tính tổng số dự án
CREATE FUNCTION dbo.CountTotalProjects()
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    SELECT @Total = COUNT(*) FROM DuAn;
    RETURN @Total;
END;
--Hàm lấy tên nhân viên theo mã nhân viên
CREATE FUNCTION dbo.GetEmployeeName(@MaNhanVien INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @TenNhanVien NVARCHAR(255);
    SELECT @TenNhanVien = TenNhanVien FROM NhanVien WHERE MaNhanVien = @MaNhanVien;
    RETURN @TenNhanVien;
END;
--Hàm lấy danh sách nhân viên theo phòng
CREATE FUNCTION dbo.GetEmployeesByRoom(@MaPhong INT)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM NhanVien WHERE MaPhong = @MaPhong
);
--Hàm lấy danh sách nhân viên là quản lý
CREATE FUNCTION dbo.GetManagers()
RETURNS TABLE
AS
RETURN (
    SELECT * FROM NhanVien WHERE LaQuanLy = 1
);

--bảo mật và quản trị
--tạo login
CREATE LOGIN Phong1 WITH PASSWORD = 'Phong2005';
--tạo user
USE QLNhanSu; -- Chọn cơ sở dữ liệu
CREATE USER Phong2 FOR LOGIN Phong1;
--cấp quyền truy cập cơ bản
ALTER ROLE db_owner ADD MEMBER Phong2;
--cấp quyền select
GRANT SELECT ON dbo.NhanVien TO Phong2;
GRANT INSERT ON dbo.NhanVien TO Phong2;
GRANT UPDATE ON dbo.NhanVien TO Phong2;
GRANT DELETE ON dbo.NhanVien TO Phong2;
--cấp quyền cho bảng phòng ban
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PhongBan TO Phong2;
--cấp quyền cho view
GRANT SELECT ON dbo.View_DanhSachNhanVien TO Phong2;


--tạo vai trò

CREATE ROLE Role_QuanLy;
-- Gán quyền cho vai trò QuanLy
GRANT SELECT, INSERT, UPDATE, DELETE ON PhongBan TO Role_QuanLy;
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO Role_QuanLy;
GRANT SELECT, INSERT, UPDATE, DELETE ON HoatDong TO Role_QuanLy;
GRANT SELECT, INSERT, UPDATE, DELETE ON DuAn TO Role_QuanLy;
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVienDuAn TO Role_QuanLy;

-- Gán người dùng vào vai trò
EXEC sp_addrolemember 'Role_QuanLy', 'Phong2';
--Sao lưu 
BACKUP DATABASE QLNhanSu
TO DISK = 'C:\saoluu\QLNS.bak'
WITH FORMAT, INIT;
--Phục hồi
RESTORE DATABASE QLNhanSu
FROM DISK = 'C:\saoluu\QLNS.bak'
WITH REPLACE;
---------------------------------------------------------------------Tạo trigger-------------------------------------------------------------------------------
 --Trigger kiểm tra dữ liệu trước khi chèn
CREATE TRIGGER trg_CheckTenNhanVien
ON NhanVien
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE TenNhanVien IS NULL OR TenNhanVien = '')
    BEGIN
        RAISERROR('Tên nhân viên không được để trống.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong)
        SELECT TenNhanVien, LaQuanLy, MaPhong FROM inserted;
    END
END;
--Trigger ghi lại lịch sử thay đổi
CREATE TABLE LichSuThayDoi (
    MaLichSu INT PRIMARY KEY IDENTITY(1,1),
    MaNhanVien INT,
    ThayDoi NVARCHAR(255),
    ThoiGian DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_GhiLichSuThayDoi
ON NhanVien
AFTER UPDATE
AS
BEGIN
    INSERT INTO LichSuThayDoi (MaNhanVien, ThayDoi)
    SELECT MaNhanVien, 'Cập nhật thông tin nhân viên' FROM inserted;
END;
--Trigger ngăn chặn xóa nhân viên quản lý
CREATE TRIGGER trg_NganChanXoaQuanLy
ON NhanVien
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM deleted WHERE LaQuanLy = 1)
    BEGIN
        RAISERROR('Không thể xóa nhân viên là quản lý.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        DELETE FROM NhanVien
        WHERE MaNhanVien IN (SELECT MaNhanVien FROM deleted);
    END
END;
--Trigger tự động cập nhật ngày sửa đổi
ALTER TABLE NhanVien ADD NgayCapNhat DATETIME;

CREATE TRIGGER trg_CapNhatNgayCapNhat
ON NhanVien
AFTER UPDATE
AS
BEGIN
    UPDATE NhanVien
    SET NgayCapNhat = GETDATE()
    FROM NhanVien n
    INNER JOIN inserted i ON n.MaNhanVien = i.MaNhanVien;
END;
---------------------------------------Xây dựng 10 Stored Procedure---------------------------------------------------
 --Lấy danh sách tất cả nhân viên.
CREATE PROCEDURE sp_GetAllEmployees
AS
BEGIN
    SELECT * FROM NhanVien;
END;
--Lấy thông tin nhân viên theo mã nhân viên
CREATE PROCEDURE sp_GetEmployeeById
    @MaNhanVien INT
AS
BEGIN
    SELECT * FROM NhanVien WHERE MaNhanVien = @MaNhanVien;
END;
-- Lấy danh sách các phòng ban.
CREATE PROCEDURE sp_GetAllDepartments
AS
BEGIN
    SELECT * FROM PhongBan;
END;
-- Thêm một nhân viên mới.
CREATE PROCEDURE sp_AddEmployee
    @TenNhanVien NVARCHAR(255),
    @LaQuanLy BIT,
    @MaPhong INT
AS
BEGIN
    INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong)
    VALUES (@TenNhanVien, @LaQuanLy, @MaPhong);
END;
--  Lấy danh sách các dự án.
CREATE PROCEDURE sp_GetAllProjects
AS
BEGIN
    SELECT * FROM DuAn;
END;
--   Xóa một nhân viên theo mã nhân viên.
CREATE PROCEDURE sp_DeleteEmployee
    @MaNhanVien INT
AS
BEGIN
    DELETE FROM NhanVien WHERE MaNhanVien = @MaNhanVien;
END;
--    Lấy danh sách nhân viên theo phòng
CREATE PROCEDURE sp_GetEmployeesByDepartment
    @MaPhong INT
AS
BEGIN
    SELECT * FROM NhanVien WHERE MaPhong = @MaPhong;
END;