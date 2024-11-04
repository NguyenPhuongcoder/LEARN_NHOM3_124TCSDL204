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
CREATE TABLE QUOCGIA  
(  
	MAQG CHAR(6) PRIMARY KEY,  
	TENQG NVARCHAR(30) NOT NULL  
) 
-- tạo bảng tỉnh thành phố
CREATE TABLE TINHTHANHPHO 
(  
    MATTP CHAR(6) PRIMARY KEY,  
    TENTTP NVARCHAR(30) NOT NULL,  
    MAQGNo CHAR(6), 
	CONSTRAINT FK_TinhThanhPho_MaQGNo FOREIGN KEY(MAQGNo) REFERENCES QUOCGIA(MAQG)  
        ON DELETE 
			CASCADE  
        ON UPDATE 
			CASCADE  
)  
--tạo bảng quận huyện
CREATE TABLE QUANHUYEN  
(  
    MAQH CHAR(6) PRIMARY KEY,  
    TENQH NVARCHAR(30) NOT NULL,  
    MATTPNo CHAR(6),
	CONSTRAINT FK_QuanHuyen_MaTTPNo FOREIGN KEY (MATTPNo) REFERENCES TINHTHANHPHO(MATTP)  
        ON DELETE 
			CASCADE  
        ON UPDATE 
			CASCADE  
)  
--tạo bảng Phường xã
CREATE TABLE PHUONGXA
(  
    MAPX CHAR(6) PRIMARY KEY,  
    TENPX NVARCHAR(30) NOT NULL,  
    MAQHNo CHAR(6),
	CONSTRAINT FK_PhuongXa_MaQHNo FOREIGN KEY (MAQHNo) REFERENCES QUANHUYEN(MaQH)  
        ON DELETE 
			CASCADE  
        ON UPDATE 
			CASCADE  
) 

-- Kết thúc bổ xung
--Tạo bảng loại hàng
CREATE TABLE LOAIHANG
(
	MALOAIHANG 	CHAR(6) PRIMARY KEY,
	TENLOAIHANG 	NVARCHAR(50)
)
--tạo bảng khách hàng
CREATE TABLE KHACHHANG
(
	MAKHACHHANG 	CHAR(6) PRIMARY KEY,
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
		SONHATENDUONG NVARCHAR(50) NOT NULL,
		MAPXNo CHAR(6) NOT NULL,
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
	MANHANVIEN		CHAR(6) PRIMARY KEY ,
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
		SONHATENDUONG NVARCHAR(50) NOT NULL,
		MAPXNo CHAR(6) NOT NULL,
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
		MACONGTY			CHAR(6) PRIMARY KEY,
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
		SONHATENDUONG NVARCHAR(50) NOT NULL,
		MAPXNo CHAR(6) NOT NULL,
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

		MAMATHANG 	CHAR(6) PRIMARY KEY,
		TENHANG 	NVARCHAR(50),
		MACONGTY 	CHAR(6) NOT NULL,
		MALOAIHANG 	CHAR(6) NOT NULL,
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
	SOHOADON 	INT IDENTITY(1,1) PRIMARY KEY,
	MAKHACHHANG 	CHAR(6) NOT NULL,	
	MANHANVIEN	CHAR(6) NOT NULL,	
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
		SONHATENDUONG NVARCHAR(50) NOT NULL,
		MAPXNo CHAR(6) NOT NULL,
		CONSTRAINT FK_DONDATHANG_MaPXNo 
			FOREIGN KEY (MAPXNo) REFERENCES  PhuongXa(MAPX) 
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
		CHECK (NGAYCHUYENHANG>=NGAYDATHANG)
--Tạo bảng chi tiết đặt hàng
CREATE TABLE CHITIETDATHANG
(
  		SOHOADON 		INT,
  		MAHANG 			CHAR(6),
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
set dateformat dMy;
INSERT INTO QuocGia 
VALUES   
	('VN0001', 'Việt Nam'),  
	('US0002', 'Hoa Kỳ'),  
	('JP0003', 'Nhật Bản'),  
	('FR0004', 'Pháp'),  
	('DE0005', 'Đức'),  
	('CN0006', 'Trung Quốc'),  
	('IN0007', 'Ấn Độ'),  
	('GB0008', 'Vương Quốc Anh'),  
	('BR0009', 'Brazil'),  
	('AU0010', 'Úc');
-- thêm dữ liệu bảng tỉnh thành phố
INSERT INTO TinhThanhPho 
VALUES   
	('HCM001', 'Thành phố Hồ Chí Minh', 'VN0001'),  
	('HN0002', 'Hà Nội', 'VN0001'),  
	('DN0003', 'Đà Nẵng', 'VN0001'),  
	('NT0004', 'Nha Trang', 'VN0001'),  
	('DL0005', 'Đà Lạt', 'VN0001'),  
	('HP0006', 'Hải Phòng', 'VN0001'),  
	('QT0007', 'Quy Nhơn', 'VN0001'),  
	('CT0008', 'Cần Thơ', 'VN0001'),  
	('BG0009', 'Bắc Giang', 'VN0001'),  
	('BN0010', 'Bắc Ninh', 'VN0001');
-- thêm dữ liệu bảng quận huyện

INSERT INTO QuanHuyen 
VALUES   
	('Q10001', 'Quận 1', 'HCM001'),  
	('Q20002', 'Quận 2', 'HCM001'),  
	('Q30003', 'Quận 3', 'HCM001'),  
	('Q40004', 'Quận 4', 'HCM001'),  
	('Q50005', 'Quận 5', 'HCM001'),  
	('HA0006', 'Huyện An Dương', 'HP0006'),  
	('HB0007', 'Huyện An Hải', 'HP0006'),  
	('DN1008', 'Huyện Ba Đình', 'HN0002'),  
	('DN2009', 'Huyện Tư Nghĩa', 'DN0003'),  
	('DN3010', 'Huyện Liên Chiểu', 'DN0003');
-- thêm dữ liệu bảng phường xã
INSERT INTO PhuongXa 
VALUES   
	('PX0001', 'Phường 1', 'Q10001'),  
	('PX0002', 'Phường 2', 'Q10001'),  
	('PX0003', 'Phường 3', 'Q20002'),  
	('PX0004', 'Phường 4', 'Q20002'),  
	('PX0005', 'Phường 5', 'Q30003'),  
	('PX0006', 'Phường 6', 'Q30003'),  
	('PX0007', 'Phường Hương Khê', 'HA0006'),  
	('PX0008', 'Phường Thủy Dương', 'HB0007'),  
	('PX0009', 'Phường Ba Đình', 'DN1008'),  
	('PX0010', 'Phường Tư Nghĩa', 'DN2009');

---- Phương : Loại hàng, Mặt hàng
--Loại hàng:
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG) 
VALUES  
	('LH0001', N'Thuốc chữa bệnh'),  
	('LH0002', N'Thực phẩm chức năng'),  
	('LH0003', N'Mỹ phẩm'),  
	('LH0004', N'Thực phẩm tươi sống'),  
	('LH0005', N'Hàng gia dụng'),  
	('LH0006', N'Điện thoại & Phụ kiện'),  
	('LH0007', N'Thời trang nam'),  
	('LH0008', N'Thời trang nữ'),  
	('LH0009', N'Đồ điện tử'),  
	('LH0010', N'Thời trang trẻ em'); 
-- Bảng mặt hàng:

--Bảng NHANVIEN

-- Khách hàng
INSERT INTO dbo.KHACHHANG(MAKHACHHANG, TENCONGTY, NGUOIDAIDIEN, TENGIAODICH, EMAIL, DIENTHOAI, FAX, SoNhaTenDuong, MaPXNo)
VALUES
	('KH0001', N'CTHH 1TV S', N'Nguyễn Công Minh', N'QWETR', 'ncm071205@gmail.com', '0702772847', '22334455', N'Thôn Phú Mỹ', 'PX0001'),
	('KH0002', N'CTHH 1TV A', N'Lê Văn Hùng', N'ASDFG', 'lvh0201@gmail.com', '0702772848', '22334456', N'Thôn Phú Cường', 'PX0002'),
	('KH0003', N'CTHH 1TV B', N'Phạm Thị Mai', N'ZXCVB', 'ptm0201@gmail.com', '0702772849', '22334457', N'Thôn Phú Thọ', 'PX0003'),
	('KH0004', N'CTHH 1TV C', N'Trần Công Tâm', N'QWERQ', 'tct0301@gmail.com', '0702772850', '22334458', N'Thôn Phú Thành', 'PX0004'),
	('KH0005', N'CTHH 1TV D', N'Ngô Bảo Ngọc', N'LKJHG', 'nbn0401@gmail.com', '0702772851', '22334459', N'Thôn Phú Hòa', 'PX0005'),
	('KH0006', N'CTHH 1TV E', N'Đinh Quang Khánh', N'KJHFD', 'dqk0501@gmail.com', '0702772852', '22334460', N'Thôn Phú An', 'PX0006'),
	('KH0007', N'CTHH 1TV F', N'Nguyễn Hồng Phúc', N'MNBVC', 'nhp0601@gmail.com', '0702772853', '22334461', N'Thôn Phú Định', 'PX0007'),
	('KH0008', N'CTHH 1TV G', N'Lý Minh Hoàng', N'GHJKL', 'lmh0701@gmail.com', '0702772854', '22334462', N'Thôn Phú Lợi', 'PX0008'),
	('KH0009', N'CTHH 1TV H', N'Vũ Văn Kiệt', N'ERTYU', 'vvk0801@gmail.com', '0702772855', '22334463', N'Thôn Phú Bình', 'PX0009'),
	('KH0010', N'CTHH 1TV I', N'Tôn Thất Thảo', N'YTREW', 'ttt0901@gmail.com', '0702772856', '22334464', N'Thôn Phú Xuân', 'PX0010');

INSERT INTO NHANVIEN (MANHANVIEN, HO, TEN, NGAYSINH, NGAYLAMVIEC, DIENTHOAI, LUONGCOBAN, PHUCAP, SoNhaTenDuong, MaPXNo) 
VALUES
    ('NV0001', N'Trần Minh', N'Anh', '21-06-1990', '15-01-2023', '0912345678', 10000000, 2000000, N'123 Lê Lợi', 'PX0001'),
    ('NV0002', N'Lê Ngọc', N'Ánh', '01-03-1991', '10-02-2023', '0912345679', 10500000, 2500000, N'456 Trần Phú', 'PX0002'),
    ('NV0003', N'Nguyễn Văn', N'Bình', '10-08-1992', '20-03-2023', '0912345680', 11000000, 2300000, N'789 Lý Tự Trọng', 'PX0003'),
    ('NV0004', N'Phạm Hương', N'Giang', '09-01-1993', '25-04-2023', '0912345681', 9500000, 2100000, N'321 Hùng Vương', 'PX0004'),
    ('NV0005', N'Hoàng Nhật', N'Minh', '02-11-1994', '05-05-2023', '0912345682', 9800000, 2200000, N'654 Hai Bà Trưng', 'PX0005'),
    ('NV0006', N'Vũ Thanh', N'Hoa', '29-11-1995', '15-06-2023', '0912345683', 9200000, 2400000, N'987 Đinh Tiên Hoàng', 'PX0006'),
    ('NV0007', N'Cao Văn', N'Sơn', '12-04-1996', '25-07-2023', '0912345684', 10100000, 2600000, N'258 Nguyễn Thị Minh Khai', 'PX0007'),
    ('NV0008', N'Ngô Thị', N'Hạnh', '24-10-1997', '05-08-2023', '0912345685', 9700000, 2800000, N'369 Lê Văn Sỹ', 'PX0008'),
    ('NV0009', N'Võ Đình', N'Phú', '19-10-1998', '15-09-2023', '0912345686', 10200000, 3000000, N'123 Võ Thị Sáu', 'PX0009'),
    ('NV0010', N'Nguyễn Minh', N'Hoàng', '16-10-1999', '25-10-2023', '0912345687', 10900000, 3200000, N'456 Nguyễn Đình Chiểu', 'PX0010'),
    ('NV0011', N'Phạm Hữu', N'Hưng', '20-08-2000', '05-11-2023', '0912345688', 9400000, 2100000, N'789 Hoàng Diệu', 'PX0001'),
    ('NV0012', N'Lê Thị', N'Thanh', '08-12-2001', '15-12-2023', '0912345689', 9100000, 2700000, N'321 Bạch Đằng', 'PX0003'),
    ('NV0013', N'Trần Công', N'Khoa', '07-11-2002', '10-01-2023', '0912345690', 8900000, 2200000, N'654 Lê Lai', 'PX0007');




-- đơn đặt hàng
INSERT INTO dbo.DONDATHANG(MAKHACHHANG, MANHANVIEN, NGAYDATHANG, NGAYGIAOHANG, NGAYCHUYENHANG, SoNhaTenDuong, MaPXNo)
VALUES
	('KH0001', 'NV0001', DEFAULT, GETDATE() + 5, NULL, N'Số 1 Đường 1', 'PX0001'),
	('KH0002', 'NV0002', DEFAULT, GETDATE() + 6, GETDATE() + 8, N'Số 2 Đường 2', 'PX0002'),
	('KH0003', 'NV0003', DEFAULT, NULL, NULL, N'Số 3 Đường 3', 'PX0003'),
	('KH0004', 'NV0004', DEFAULT, GETDATE() + 5, GETDATE() + 9, N'Số 4 Đường 4', 'PX0004'),
	('KH0005', 'NV0005', DEFAULT, GETDATE() + 7, NULL, N'Số 5 Đường 5', 'PX0005'),
	('KH0006', 'NV0006', DEFAULT, GETDATE() + 5, GETDATE() + 7, N'Số 6 Đường 6', 'PX0006'),
	('KH0007', 'NV0007', DEFAULT, GETDATE() + 8, NULL, N'Số 7 Đường 7', 'PX0007'),
	('KH0008', 'NV0008', DEFAULT, GETDATE() + 6, NULL, N'Số 8 Đường 8', 'PX0008'),
	('KH0009', 'NV0009', DEFAULT, NULL, NULL, N'Số 9 Đường 9', 'PX0009'),
	('KH0010', 'NV0010', DEFAULT, GETDATE() + 4, GETDATE() + 7, N'Số 10 Đường 10', 'PX0010');


--Hữu Sáng
--Nhà Cung Cấp
INSERT INTO NHACUNGCAP(MACONGTY, TENCONGTY, TENGIAODICH, DIENTHOAI, FAX, EMAIL, SONHATENDUONG, MAPXNo)  
VALUES  
    ('CT0001', N'THIÊN LONG', N'SAIGONMART', N'0865658451', '525525', 'info@saigonmart.vn', N'Thôn Phú Mỹ', 'PX0001'),  
    ('CT0002', N'THIÊN KIM', N'GIAOHANG', N'0865658452', '325325', 'contact@viettrade.com', N'Thôn Phú Cường', 'PX0002'),  
    ('CT0003', N'HÒA BÌNH', N'SAIGONMART', N'0865658453', '625625', 'support@bigshop.vn', N'Thôn Phú Thọ', 'PX0003'),  
    ('CT0004', N'THIÊN LONG', N'VIETTRADE', N'0865658454', '225225', 'sales@giaodich24h.com', N'Thôn Phú Thành', 'PX0004'),  
    ('CT0005', N'HÒA BÌNH', N'SAIGONMART', N'0865658455', '525525', 'customer@vinatrade.vn', N'Thôn Phú Hòa', 'PX0005'),  
    ('CT0006', N'THIÊN LONG', N'VIETTRADE', N'0865658456', '125125', 'hello@megastore.vn', N'Thôn Phú An', 'PX0006'),  
    ('CT0007', N'HÒA BÌNH', N'MEGASTORE', N'0865658457', '525525', 'service@vietmart.com', N'Thôn Phú Định', 'PX0007'),  
    ('CT0008', N'KIM PHÁT', N'SAIGONMART', N'0865658458', '325325', 'admin@thanhcongtrade.vn', N'Thôn Phú Lợi', 'PX0008'),  
    ('CT0009', N'THIÊN LONG', N'MEGASTORE', N'0865658459', '525525', 'support@sieuthiso.vn', N'Thôn Phú Bình', 'PX0009'),  
    ('CT0010', N'KIM PHÁT', N'SIEUTHISO', N'0865658410', '925925', 'info@daisymart.com', N'Thôn Phú Xuân', 'PX0010'); 
 
 
INSERT INTO MATHANG (MAMATHANG, TENHANG, MACONGTY, MALOAIHANG, SOLUONG, DONVITINH, GIAHANG) 
VALUES  
	('MH0001', N'Paracetamol 500mg', 'CT0001', 'LH0001', 150, N'Hộp', 120.00),  
	('MH0002', N'Vitamin C 1000mg', 'CT0001', 'LH0002', 200, N'Hộp', 85.50),  
	('MH0003', N'Son môi Super Matte', 'CT0002', 'LH0003', 100, N'Cây', 250.00),  
	('MH0004', N'Salmon tươi', 'CT0001', 'LH0004', 50, N'Kg', 450.00),  
	('MH0005', N'Nồi cơm điện', 'CT0002', 'LH0005', 75, N'Cái', 750.00),  
	('MH0006', N'Iphone 13', 'CT0003', 'LH0006', 30, N'Cái', 30000.00),  
	('MH0007', N'Áo phông nam', 'CT0002', 'LH0007', 120, N'Cái', 150.00),  
	('MH0008', N'Váy đầm nữ', 'CT0001', 'LH0008', 80, N'Cái', 400.00),  
	('MH0009', N'Tivi LED 50 inches', 'CT0003', 'LH0009', 20, N'Cái', 12000.00),  
	('MH0010', N'Áo khoác trẻ em', 'CT0001', 'LH0010', 150, N'Cái', 300.00);

--Chi tiết đơn HàngHàng
INSERT INTO CHITIETDATHANG(SOHOADON, MAHANG, GIABAN, SOLUONG, MUCGIAMGIA) 
VALUES 
	(1, 'MH0003', 1500, 100, 5), 
	(1, 'MH0005', 2500, 200, 5), 
	(2, 'MH0008', 3500, 1000, 8), 
	(2, 'MH0001', 4500, 150, 5), 
	(3, 'MH0009', 5500, 100, 10), 
	(3, 'MH0004', 6500, 300, 5), 
	(4, 'MH0007', 7500, 100, 4), 
	(4, 'MH0002', 7500, 600, 5), 
	(5, 'MH0010', 8500, 100, 3), 
	(5, 'MH0006', 9500, 500, 5),
	(6, 'MH0001', 1200, 250, 6), 
	(7, 'MH0003', 2200, 400, 7), 
	(7, 'MH0009', 3200, 350, 8), 
	(8, 'MH0006', 4200, 150, 5), 
	(9, 'MH0002', 5200, 80, 9), 
    (10, 'MH0005', 6100, 300, 6);




------------------------------------------------------------------UPDATE----------------------------------------------------------------------------
--Hữu Sáng
--a,) Cập nhật lại giá trị trường NGAYCHUYENHANG của những bản ghi có NGAYCHUYENHANG chưa xác định (NULL) trong bảng DONDATHANG bằng với giá trị của trường NGAYDATHANG. 
UPDATE DONDATHANG  
SET NGAYCHUYENHANG = NGAYDATHANG  
WHERE NGAYCHUYENHANG IS NULL; 

--b) Tăng số lượng hàng của những mặt hàng do công ty VINAMILK((THIÊN LONG) cung cấp lên gấp đôi. 
UPDATE MATHANG 
SET SOLUONG = SOLUONG * 2  
FROM  MATHANG d, NHACUNGCAP c
WHERE c.MACONGTY=d.MACONGTY AND c.TENCONGTY = N'THIÊN LONG'; 
-- Công Minh
-- c
UPDATE dbo.DONDATHANG
SET SoNhaTenDuong = k.SoNhaTenDuong, MaPXNo = k.MaPXNo
FROM dbo.KHACHHANG k
WHERE DONDATHANG.SoNhaTenDuong IS NULL

-- d 
UPDATE dbo.KHACHHANG
SET	SoNhaTenDuong = n.SoNhaTenDuong, MaPXNo = n.MaPXNo, EMAIL = n.EMAIL, DIENTHOAI = n.DIENTHOAI, FAX = n.FAX
FROM dbo.NHACUNGCAP n
WHERE n.TENCONGTY = dbo.KHACHHANG.TENCONGTY AND n.TENGIAODICH = dbo.KHACHHANG.TENGIAODICH

--huy
--e
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN*1.5
WHERE MANHANVIEN IN (SELECT D.MANHANVIEN
					FROM DONDATHANG D, CHITIETDATHANG C
					WHERE D.SOHOADON = C.SOHOADON 
					AND YEAR(NGAYDATHANG) = 2024
					GROUP BY MANHANVIEN 
						HAVING SUM(SOLUONG) > 10)

--f
UPDATE NHANVIEN
SET PHUCAP = LUONGCOBAN*0.5
WHERE MANHANVIEN IN (SELECT MANHANVIEN 
		FROM DONDATHANG D, CHITIETDATHANG C
		WHERE D.SOHOADON = C.SOHOADON 
		GROUP BY MANHANVIEN 
		HAVING SUM(SOLUONG) IN (SELECT TOP 1  SUM(SOLUONG)
				FROM DONDATHANG D, CHITIETDATHANG C
				WHERE D.SOHOADON = C.SOHOADON 
				GROUP BY MANHANVIEN 
				HAVING SUM(SOLUONG) > 10
					ORDER BY SUM(SOLUONG) DESC))

--Phuong 
--g
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN - LUONGCOBAN*0.25
WHERE MANHANVIEN NOT IN ( SELECT MANHANVIEN
						  FROM DONDATHANG
						  WHERE NGAYGIAOHANG BETWEEN '1/1/2023'and '31/12/2023')
							
