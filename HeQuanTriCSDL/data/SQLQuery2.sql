INSERT INTO PhongBan (TenPhong, MaQuanLy) VALUES (N'Phòng Kinh Doanh', NULL);
INSERT INTO PhongBan (TenPhong, MaQuanLy) VALUES (N'Phòng Kỹ Thuật', 1); -- Giả sử nhân viên có MaNhanVien = 1 là quản lý
INSERT INTO PhongBan (TenPhong, MaQuanLy) VALUES (N'Phòng Hành Chính', 1);
INSERT INTO PhongBan (TenPhong, MaQuanLy) VALUES (N'Phòng Marketing', 2); -- Giả sử nhân viên có MaNhanVien = 2 là quản lý

INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Nguyễn Văn A', 1, 1); -- Quản lý Phòng Kinh Doanh
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Trần Thị B', 0, 1); -- Nhân viên Phòng Kinh Doanh
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Lê Văn C', 1, 2); -- Quản lý Phòng Kỹ Thuật
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Phạm Văn D', 0, 2); -- Nhân viên Phòng Kỹ Thuật
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Nguyễn Thị E', 1, 3); -- Quản lý Phòng Hành Chính
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Trần Văn F', 0, 3); -- Nhân viên Phòng Hành Chính
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Lê Thị G', 1, 4); -- Quản lý Phòng Marketing
INSERT INTO NhanVien (TenNhanVien, LaQuanLy, MaPhong) VALUES (N'Nguyễn Văn H', 0, 4); -- Nhân viên Phòng Marketing

INSERT INTO DuAn (TenDuAn, MoTa, ThoiGianBatDau, ThoiGianKetThuc) VALUES (N'Dự án A', N'Mô tả dự án A', '2023-01-01', '2023-12-31');
INSERT INTO DuAn (TenDuAn, MoTa, ThoiGianBatDau, ThoiGianKetThuc) VALUES (N'Dự án B', N'Mô tả dự án B', '2023-02-01', '2023-11-30');
INSERT INTO DuAn (TenDuAn, MoTa, ThoiGianBatDau, ThoiGianKetThuc) VALUES (N'Dự án C', N'Mô tả dự án C', '2023-03-01', '2023-10-31');

INSERT INTO NhanVienDuAn (MaNhanVien, MaDuAn) VALUES (1, 1); -- Nguyễn Văn A tham gia Dự án A
INSERT INTO NhanVienDuAn (MaNhanVien, MaDuAn) VALUES (2, 1); -- Trần Thị B tham gia Dự án A
INSERT INTO NhanVienDuAn (MaNhanVien, MaDuAn) VALUES (3, 2); -- Lê Văn C tham gia Dự án B
INSERT INTO NhanVienDuAn (MaNhanVien, MaDuAn) VALUES (4, 2); -- Phạm Văn D tham gia Dự án B
INSERT INTO NhanVienDuAn (MaNhanVien, MaDuAn) VALUES (5, 3); -- Nguyễn Thị E tham gia Dự án C
INSERT INTO NhanVienDuAn (MaNhanVien, MaDuAn) VALUES (6, 3); -- Trần Văn F tham gia Dự án C

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


