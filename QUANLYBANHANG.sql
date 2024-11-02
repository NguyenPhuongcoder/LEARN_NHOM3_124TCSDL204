-- Kiểm tra xem có data xem đã có hay chưa và xóa, khi ta cần chạy lại tất cả code để tránh sung đột
IF EXISTS (SELECT * From SYS.DATABASES WHERE NAME = 'Tuan5_Nhom3_124TCSDL204' )
BEGIN
-- su dung database master de xoa database tren
	use master
-- dong tat ca cac ket noi den co so, du lieu chuyen sang che do simggle use
	alter database Tuan5_Nhom3_124TCSDL204 set single_user with rollback immediate
	drop database Tuan5_Nhom3_124TCSDL204;
END
-- Tạo database
CREATE DATABASE Tuan5_Nhom3_124TCSDL204
GO
-- Dùng database
USE Tuan5_Nhom3_124TCSDL204
----------------------------------------------------------CREATE, ALTER, CONSTRAINT,-----------------------------------------------------------------
-- Vì thuộc tính DIACHI vi phạm dạng chuẩn 1NF nên thêm các bảng sau:
-- Bổ sung thêm bảng
CREATE TABLE QuocGia  
(  
    MaQG CHAR(10) PRIMARY KEY,  
    TenQG NVARCHAR(30) NOT NULL  
) 
-- tạo bảng tỉnh thành phố
CREATE TABLE TinhThanhPho  
(  
    MaTTP CHAR(10) PRIMARY KEY,  
    TenTTP NVARCHAR(30) NOT NULL,  
    MaQGNo CHAR(10), 
	CONSTRAINT FK_TinhThanhPho_MaQGNo FOREIGN KEY(MaQGNo) REFERENCES QuocGia(MaQG)  
        ON DELETE 
			CASCADE  
        ON UPDATE 
			CASCADE  
)  
--tạo bảng quận huyện
CREATE TABLE QuanHuyen  
(  
    MaQH CHAR(10) PRIMARY KEY,  
    TenQH NVARCHAR(30) NOT NULL,  
    MaTTPNo CHAR(10),
	CONSTRAINT FK_QuanHuyen_MaTTPNo FOREIGN KEY (MaTTPNo) REFERENCES TinhThanhPho(MaTTP)  
        ON DELETE 
			CASCADE  
        ON UPDATE 
			CASCADE  
)  
--tạo bảng Phường xã
CREATE TABLE PhuongXa  
(  
    MaPX CHAR(10) PRIMARY KEY,  
    TenPX NVARCHAR(30) NOT NULL,  
    MaQHNo CHAR(10),
	CONSTRAINT FK_PhuongXa_MaQHNo FOREIGN KEY (MaQHNo) REFERENCES QuanHuyen(MaQH)  
        ON DELETE 
			CASCADE  
        ON UPDATE 
			CASCADE  
) 

-- Kết thúc bổ xung
--Tạo bảng loại hàng
CREATE TABLE LOAIHANG
(
	MALOAIHANG 	CHAR(10) PRIMARY KEY,
	TENLOAIHANG 	NVARCHAR(50)
)
--tạo bảng khách hàng
CREATE TABLE KHACHHANG
(
	MAKHACHHANG 	CHAR(10) PRIMARY KEY,
	TENCONGTY	NVARCHAR(50),
	NGUOIDAIDIEN	NVARCHAR(30),
	TENGIAODICH 	NVARCHAR (50) NOT NULL,
	DIACHI 	NVARCHAR (50) NOT NULL,
	EMAIL	VARCHAR (40)  UNIQUE,
	DIENTHOAI	VARCHAR(11) NOT NULL UNIQUE,
	FAX 	VARCHAR(10) UNIQUE
)
-- Xóa Cột diaChiKH
ALTER TABLE KHACHHANG
	DROP 
		COLUMN DIACHI
/*
- Thêm cột só nhà tên đường
- Thêm cột MaPXNo và set khóa ngoại mượn từ bảng PhuongXa
- Ràng buộc dữ liệu SDT nhap vao 10 số hoặc 11 số
- Ràng buộc Email 
*/
ALTER TABLE KHACHHANG
	ADD  
		SoNhaTenDuong NVARCHAR(50) NOT NULL,
		MaPXNo CHAR(10) NOT NULL,
		CONSTRAINT FK_KhachHang_MaPXNo 
			FOREIGN KEY (MAPXNo) REFERENCES  PhuongXa(MaPX) 
     			ON DELETE 
					NO ACTION  
				ON UPDATE 
					NO ACTION,
		CONSTRAINT CK_KhachHang_SDT
			CHECK (DIENTHOAI LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
				   DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		CONSTRAINT CK_KhachHang_Email
			CHECK(EMAIL Like'[a-z]%@%_')
-- sửa dữ liệu
ALTER TABLE KHACHHANG
	ALTER COLUMN DIENTHOAI VARCHAR(20)
ALTER TABLE KHACHHANG
	ALTER COLUMN DIENTHOAI VARCHAR(20)
CREATE TABLE NHANVIEN
(
	MANHANVIEN		CHAR(10) PRIMARY KEY ,
	HO				NVARCHAR(20) NOT NULL,
	TEN 			NVARCHAR(10) NOT NULL,
	NGAYSINH 		DATE,
	NGAYLAMVIEC 	DATE NOT NULL,
	DIACHI 			NVARCHAR(50),
	DIENTHOAI 		VARCHAR(11) UNIQUE,
	LUONGCOBAN		MONEY NOT NULL,
	PHUCAP			MONEY,
)
-- Xóa Cột diaChi
ALTER TABLE NHANVIEN
	DROP 
		COLUMN DIACHI
/*
- Thêm cột só nhà tên đường
- Thêm cột MaPXNo và set khóa ngoại mượn từ bảng PhuongXa
- Ràng buộc dữ liệu SDT nhap vao 10 số hoặc 11 số 
*/
ALTER TABLE NHANVIEN
	ADD  
		SoNhaTenDuong NVARCHAR(50) NOT NULL,
		MaPXNo CHAR(10) NOT NULL,
		CONSTRAINT FK_NHANVIEN_MaPXNo 
			FOREIGN KEY (MAPXNo) REFERENCES  PhuongXa(MaPX) 
     			ON DELETE 
					CASCADE  
				ON UPDATE 
					CASCADE,
		CONSTRAINT CK_NHANVIEN_SDT
			CHECK (DIENTHOAI LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
				   DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
-- sửa dữ liệu
ALTER TABLE NHANVIEN
	ALTER COLUMN DIENTHOAI VARCHAR(20)
ALTER TABLE NHANVIEN
	ALTER COLUMN LUONGCOBAN DECIMAL(10,2)
ALTER TABLE NHANVIEN
	ALTER COLUMN PHUCAP DECIMAL(10,2)
-- ràng buộc tuổi cho cột ngày sinh của bảng nhân vien
ALTER TABLE NHANVIEN
	ADD
		CONSTRAINT CK_NHANVIEN_NGAYSINH
		CHECK(DATEDIFF(DAY,NGAYSINH,GETDATE())/365>=18 AND DATEDIFF(DAY,NGAYSINH,GETDATE())/365 <= 60 )
-- Tạo bảng nhà cung câp
CREATE TABLE NHACUNGCAP
(
		
		MACONGTY			CHAR(10) PRIMARY KEY,
		TENCONGTY 			NVARCHAR(50) NOT NULL,
		TENGIAODICH 		NVARCHAR(50) NOT NULL,
 		DIACHI  			NVARCHAR(50) NOT NULL,
		DIENTHOAI 			VARCHAR(11) NOT NULL UNIQUE,
 		FAX 				NVARCHAR(10) NOT NULL,
 		EMAIL 				VARCHAR(50) UNIQUE
		)
-- Xóa Cột diaChi
ALTER TABLE NHACUNGCAP
	DROP 
		COLUMN DIACHI
/*
- Thêm cột só nhà tên đường
- Thêm cột MaPXNo và set khóa ngoại mượn từ bảng PhuongXa
- Ràng buộc dữ liệu SDT nhap vao 10 số hoặc 11 số
- Ràng buộc Email 
*/
ALTER TABLE NHACUNGCAP
	ADD  
		SoNhaTenDuong NVARCHAR(50) NOT NULL,
		MaPXNo CHAR(10) NOT NULL,
		CONSTRAINT FK_NHACUNGCAP_MaPXNo 
			FOREIGN KEY (MAPXNo) REFERENCES  PhuongXa(MaPX) 
     			ON DELETE 
					NO ACTION  
				ON UPDATE 
					NO ACTION,
		CONSTRAINT CK_NHACUNGCAP_SDT
			CHECK (DIENTHOAI LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
				   DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		CONSTRAINT CK_NHACUNGCAP_Email
			CHECK(EMAIL Like'[a-z]%@%_')
-- sửa dữ liệu
ALTER TABLE NHACUNGCAP
	ALTER COLUMN DIENTHOAI VARCHAR(20)
CREATE TABLE MATHANG 
(	
	
		MAMATHANG 	CHAR(10) PRIMARY KEY,
		TENHANG 	NVARCHAR(50),
		MACONGTY 	CHAR(10) NOT NULL,
		MALOAIHANG 	CHAR(10) NOT NULL,
		SOLUONG 	INT,
		DONVITINH 	NVARCHAR(50),
		GIAHANG 	INT,
		FOREIGN KEY (MACONGTY) REFERENCES NHACUNGCAP(MACONGTY)
			ON DELETE 
				CASCADE
			ON UPDATE 
				CASCADE,
		FOREIGN KEY(MALOAIHANG)REFERENCES LOAIHANG(MALOAIHANG)
			ON DELETE	
				CASCADE
			ON UPDATE
				CASCADE
)
-- sửa dữ liệu
ALTER TABLE MATHANG
	ALTER COLUMN GIAHANG DECIMAL(10,2)
-- Tạo bảng đơn đặt hàng
CREATE TABLE DONDATHANG
(
		SOHOADON 	INT IDENTITY PRIMARY KEY,
		MAKHACHHANG 	CHAR(10) NOT NULL,	
		MANHANVIEN	CHAR(10) NOT NULL,	
		NGAYDATHANG 	DATE NOT NULL,	
		NGAYGIAOHANG 	DATE,	
		NGAYCHUYENHANG 	DATE,	
		NOIGIAOHANG 	NVARCHAR(64) NOT NULL,
		FOREIGN KEY (MAKHACHHANG) REFERENCES KHACHHANG (MAKHACHHANG)
			ON DELETE 
				CASCADE
			ON UPDATE 
				CASCADE,
		FOREIGN KEY (MANHANVIEN) REFERENCES NHANVIEN (MANHANVIEN)
			ON DELETE 
				CASCADE
			ON UPDATE 
				CASCADE
)
-- Xóa Cột diaChi
ALTER TABLE DONDATHANG
	DROP 
		COLUMN NOIGIAOHANG
/*
- Thêm cột só nhà tên đường
- Thêm cột MaPXNo và set khóa ngoại mượn từ bảng PhuongXa
*/
ALTER TABLE DONDATHANG
	ADD  
		SoNhaTenDuong NVARCHAR(50) NOT NULL,
		MaPXNo CHAR(10) NOT NULL,
		CONSTRAINT FK_DONDATHANG_MaPXNo 
			FOREIGN KEY (MAPXNo) REFERENCES  PhuongXa(MaPX) 
     			ON DELETE 
					NO ACTION  
				ON UPDATE 
					NO ACTION
-- ràng buộc dữ liệu cho bảng đơn đặt hàng
ALTER TABLE DONDATHANG
	ADD
		CONSTRAINT DK_DONDATHANG_NGAYDATHANG
		DEFAULT GETDATE() FOR NGAYDATHANG,
		CONSTRAINT FK_DONDATHANG_NGAYGIAOHANG
		CHECK (NGAYGIAOHANG>=NGAYDATHANG),
		CONSTRAINT FK_DONDATHANG_NGAYCHUYENHANG
		CHECK (NGAYCHUYENHANG>=NGAYGIAOHANG)
--Tạo bảng chi tiết đặt hàng
CREATE TABLE CHITIETDATHANG
(
  		SOHOADON 		INT,
  		MAHANG 			CHAR(10),
		GIABAN			MONEY,
		SOLUONG			INT,
		MUCGIAMGIA		FLOAT,
 		PRIMARY KEY (SOHOADON, MAHANG),
		FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAMATHANG)
			ON DELETE 
				CASCADE
			ON UPDATE 
				CASCADE,
		FOREIGN KEY (SOHOADON) REFERENCES DONDATHANG(SOHOADON)	
			ON DELETE 
				CASCADE
			ON UPDATE 
				CASCADE
)
-- sửa dữ liệu
ALTER TABLE CHITIETDATHANG
	ALTER COLUMN GIABAN DECIMAL(10,2)
ALTER TABLE CHITIETDATHANG
    ALTER COLUMN MUCGIAMGIA DECIMAL(5,2)
-- Cài đặt mặc định 1 cho cột số lượng
ALTER TABLE CHITIETDATHANG
	ADD
		CONSTRAINT DF_CHITIETDATHANG_SOLUONG
		DEFAULT 1 FOR SOLUONG,
		CONSTRAINT DF_CHITIETDATHANG_MUCGIAMGIA
		DEFAULT 0 FOR MUCGIAMGIA
---------- Bổ sung tuần 6
--Phương : thêm not nul cho cột ngày sinh của bảng Nhân viên
ALTER TABLE NHANVIEN  
	ALTER COLUMN NGAYSINH DATE NOT NULL
-- Huy
-- Sáng
-- Công Minh
ALTER TABLE dbo.DONDATHANG
DROP CONSTRAINT DK_DONDATHANG_NGAYDATHANG
ALTER TABLE dbo.DONDATHANG
ADD CONSTRAINT DF_DONDATHANG_NGAYDATHANG DEFAULT GETDATE() FOR NGAYDATHANG

------------------------------------------------------------------INSERT----------------------------------------------------------------------------
-- Thêm dữ liệu bảng quốc gia
INSERT INTO QuocGia 
VALUES   
	('VN', 'Việt Nam'),  
	('US', 'Hoa Kỳ'),  
	('JP', 'Nhật Bản'),  
	('FR', 'Pháp'),  
	('DE', 'Đức'),  
	('CN', 'Trung Quốc'),  
	('IN', 'Ấn Độ'),  
	('GB', 'Vương Quốc Anh'),  
	('BR', 'Brazil'),  
	('AU', 'Úc')
-- thêm dữ liệu bảng tỉnh thành phố
INSERT INTO TinhThanhPho
VALUES   
	('HCM', 'Thành phố Hồ Chí Minh', 'VN'),  
	('HN', 'Hà Nội', 'VN'),  
	('DN', 'Đà Nẵng', 'VN'),  
	('NT', 'Nha Trang', 'VN'),  
	('DL', 'Đà Lạt', 'VN'),  
	('HP', 'Hải Phòng', 'VN'),  
	('QT', 'Quy Nhơn', 'VN'),  
	('CT', 'Cần Thơ', 'VN'),  
	('BG', 'Bắc Giang', 'VN'),  
	('BN', 'Bắc Ninh', 'VN')
-- thêm dữ liệu bảng quận huyện
INSERT INTO QuanHuyen
VALUES   
	('Q1', 'Quận 1', 'HCM'),  
	('Q2', 'Quận 2', 'HCM'),  
	('Q3', 'Quận 3', 'HCM'),  
	('Q4', 'Quận 4', 'HCM'),  
	('Q5', 'Quận 5', 'HCM'),  
	('HA', 'Huyện An Dương', 'HP'),  
	('HB', 'Huyện An Hải', 'HP'),  
	('DN1', 'Huyện Ba Đình', 'HN'),  
	('DN2', 'Huyện Tư Nghĩa', 'DN'),  
	('DN3', 'Huyện Liên Chiểu', 'DN')
-- thêm dữ liệu bảng phường xã
INSERT INTO PhuongXa
VALUES   
	('PX1', 'Phường 1', 'Q1'),  
	('PX2', 'Phường 2', 'Q1'),  
	('PX3', 'Phường 3', 'Q2'),  
	('PX4', 'Phường 4', 'Q2'),  
	('PX5', 'Phường 5', 'Q3'),  
	('PX6', 'Phường 6', 'Q3'),  
	('PX7', 'Phường Hương Khê', 'HA'),  
	('PX8', 'Phường Thủy Dương', 'HB'),  
	('PX9', 'Phường Ba Đình', 'DN1'),  
	('PX10', 'Phường Tư Nghĩa', 'DN2')

---- Phương : Loại hàng, Mặt hàng
--Loại hàng:
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG) 
VALUES  
	('LH001', N'Thuốc chữa bệnh'),  
	('LH002', N'Thực phẩm chức năng'),  
	('LH003', N'Mỹ phẩm'),  
	('LH004', N'Thực phẩm tươi sống'),  
	('LH005', N'Hàng gia dụng'),  
	('LH006', N'Điện thoại & Phụ kiện'),  
	('LH007', N'Thời trang nam'),  
	('LH008', N'Thời trang nữ'),  
	('LH009', N'Đồ điện tử'),  
	('LH010', N'Thời trang trẻ em'); 
-- Bảng mặt hàng:
INSERT INTO MATHANG (MAMATHANG, TENHANG, MACONGTY, MALOAIHANG, SOLUONG, DONVITINH, GIAHANG) 
VALUES  
	('MH001', N'Paracetamol 500mg', 'CT001', 'LH001', 150, N'Hộp', 120.00),  
	('MH002', N'Vitamin C 1000mg', 'CT001', 'LH002', 200, N'Hộp', 85.50),  
	('MH003', N'Son môi Super Matte', 'CT002', 'LH003', 100, N'Cây', 250.00),  
	('MH004', N'Salmon tươi', 'CT001', 'LH004', 50, N'Kg', 450.00),  
	('MH005', N'Nồi cơm điện', 'CT002', 'LH005', 75, N'Cái', 750.00),  
	('MH006', N'Iphone 13', 'CT003', 'LH006', 30, N'Cái', 30000.00),  
	('MH007', N'Áo phông nam', 'CT002', 'LH007', 120, N'Cái', 150.00),  
	('MH008', N'Váy đầm nữ', 'CT001', 'LH008', 80, N'Cái', 400.00),  
	('MH009', N'Tivi LED 50 inches', 'CT003', 'LH009', 20, N'Cái', 12000.00),  
	('MH010', N'Áo khoác trẻ em', 'CT001', 'LH010', 150, N'Cái', 300.00);
-- Khách hàng
INSERT INTO dbo.KHACHHANG(MAKHACHHANG, TENCONGTY, NGUOIDAIDIEN, TENGIAODICH, EMAIL, DIENTHOAI, FAX, SoNhaTenDuong, MaPXNo)
VALUES('KH00000001', N'CTHH 1TV', N'Nguyễn Công Minh', N'QWETR', 'ncm071205@gmail.com', '0702772847', '22334455', N'Thôn Phú Mỹ', 'PX1'),
('KH00000002', N'CTHH 1TV A', N'Lê Văn Hùng', N'ASDFG', 'lvh0201@gmail.com', '0702772848', '22334456', N'Thôn Phú Cường', 'PX2'),
('KH00000003', N'CTHH 1TV B', N'Phạm Thị Mai', N'ZXCVB', 'ptm0201@gmail.com', '0702772849', '22334457', N'Thôn Phú Thọ', 'PX3'),
('KH00000004', N'CTHH 1TV C', N'Trần Công Tâm', N'QWERQ', 'tct0301@gmail.com', '0702772850', '22334458', N'Thôn Phú Thành', 'PX4'),
('KH00000005', N'CTHH 1TV D', N'Ngô Bảo Ngọc', N'LKJHG', 'nbn0401@gmail.com', '0702772851', '22334459', N'Thôn Phú Hòa', 'PX5'),
('KH00000006', N'CTHH 1TV E', N'Đinh Quang Khánh', N'KJHFD', 'dqk0501@gmail.com', '0702772852', '22334460', N'Thôn Phú An', 'PX6'),
('KH00000007', N'CTHH 1TV F', N'Nguyễn Hồng Phúc', N'MNBVC', 'nhp0601@gmail.com', '0702772853', '22334461', N'Thôn Phú Định', 'PX7'),
('KH00000008', N'CTHH 1TV G', N'Lý Minh Hoàng', N'GHJKL', 'lmh0701@gmail.com', '0702772854', '22334462', N'Thôn Phú Lợi', 'PX8'),
('KH00000009', N'CTHH 1TV H', N'Vũ Văn Kiệt', N'ERTYU', 'vvk0801@gmail.com', '0702772855', '22334463', N'Thôn Phú Bình', 'PX9'),
('KH00000010', N'CTHH 1TV I', N'Tôn Thất Thảo', N'YTREW', 'ttt0901@gmail.com', '0702772856', '22334464', N'Thôn Phú Xuân', 'PX10');


-- đơn đặt hàng
INSERT INTO dbo.DONDATHANG(MAKHACHHANG, MANHANVIEN, NGAYDATHANG, NGAYGIAOHANG, NGAYCHUYENHANG, SoNhaTenDuong, MaPXNo)
VALUES('KH00000001', 'NV0001', DEFAULT, GETDATE() + 5, GETDATE() + 7, N'Số 1 Đường 1', 'PX1'),('KH00000002', 'NV00000002', DEFAULT, GETDATE() + 6, GETDATE() + 8, N'Số 2 Đường 2', 'PX2'),
('KH00000003', 'NV0003', DEFAULT, GETDATE() + 4, GETDATE() + 6, N'Số 3 Đường 3', 'PX3'),
('KH00000004', 'NV0004', DEFAULT, GETDATE() + 5, GETDATE() + 9, N'Số 4 Đường 4', 'PX4'),
('KH00000005', 'NV0005', DEFAULT, GETDATE() + 7, GETDATE() + 10, N'Số 5 Đường 5', 'PX5'),
('KH00000006', 'NV0006', DEFAULT, GETDATE() + 5, GETDATE() + 7, N'Số 6 Đường 6', 'PX6'),
('KH00000007', 'NV0007', DEFAULT, GETDATE() + 8, GETDATE() + 12, N'Số 7 Đường 7', 'PX7'),
('KH00000008', 'NV0008', DEFAULT, GETDATE() + 6, GETDATE() + 9, N'Số 8 Đường 8', 'PX8'),
('KH00000009', 'NV0009', DEFAULT, GETDATE() + 3, GETDATE() + 5, N'Số 9 Đường 9', 'PX9'),
('KH00000010', 'NV0010', DEFAULT, GETDATE() + 4, GETDATE() + 7, N'Số 10 Đường 10', 'PX10')
