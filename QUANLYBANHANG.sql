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
-- ạdfh
-- Sáng
-- Công Minh

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

		--Mạnh Huy
INSERT INTO NHANVIEN (MANHANVIEN, HON, TEN, NGAYSINH, NGAYLAMVIEC, DIENTHOAI, LUONGCOBAN, PHUCAP, SoNhaTenDuong, MaPXNo) VALUES
	('NV0001', N'Trần Minh', N' Anh', '1990-06-21', '2023-01-15', '0912345678', 10000000, 2000000, N'123 Lê Lợi', 'PX0001'),
	('NV0002', N'Lê Ngọc', N'Ánh', '1991-03-01', '2023-02-10', '0912345679', 10500000, 2500000, N'456 Trần Phú', 'PX0002'),
	('NV0003', N'NguyễnVăn', N'Bình', '1992-08-10', '2023-03-20', '0912345680', 11000000, 2300000, N'789 Lý Tự Trọng', 'PX0003'),
	('NV0004', N'Phạm Hương', N'Giang', '1993-01-09', '2023-04-25', '0912345681', 9500000, 2100000, N'321 Hùng Vương', 'PX0004'),
	('NV0005', N'Hoàng Nhật', N'Minh', '1994-11-02', '2023-05-05', '0912345682', 9800000, 2200000, N'654 Hai Bà Trưng', 'PX0005'),
	('NV0006', N'Vũ Thanh', N'Hoa', '1995-11-29', '2023-06-15', '0912345683', 9200000, 2400000, N'987 Đinh Tiên Hoàng', 'PX0006'),
	('NV0007', N'Cao Văn', N'Sơn', '1996-04-12', '2023-07-25', '0912345684', 10100000, 2600000, N'258 Nguyễn Thị Minh Khai', 'PX0007'),
	('NV0008', N'Ngô Thị', N'Hạnh', '1997-10-24', '2023-08-05', '0912345685', 9700000, 2800000, N'369 Lê Văn Sỹ', 'PX0008'),
	('NV0009', N'Võ Đình', N'Phú', '1998-10-19', '2023-09-15', '0912345686', 10200000, 3000000, N'123 Võ Thị Sáu', 'PX0009'),
	('NV0010', N'Nguyễn Minh', N'Hoàng', '1999-10-16', '2023-10-25', '0912345687', 10900000, 3200000, N'456 Nguyễn Đình Chiểu', 'PX0010'),
	('NV0011', N'Phạm Hữu', N'Hưng', '2000-08-20', '2023-11-05', '0912345688', 9400000, 2100000, N'789 Hoàng Diệu', 'PX0011'),
	('NV0012', N'Lê Thị', N'Thanh', '2001-12-08', '2023-12-15', '0912345689', 9100000, 2700000, N'321 Bạch Đằng', 'PX0012'),
	('NV0013', N'Trần Công', N'Khoa', '2002-11-07', '2023-01-10', '0912345690', 8900000, 2200000, N'654 Lê Lai', 'PX0013');
