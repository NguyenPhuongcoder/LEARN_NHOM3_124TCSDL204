-- Kiểm tra xem có data xem đã có hay chưa và xóa, khi ta cần chạy lại tất cả code để tránh sung đột
IF EXISTS (SELECT * From SYS.DATABASES WHERE NAME = 'Tuan5_Nhom3' )
BEGIN
-- su dung database master de xoa database tren
	use master
-- dong tat ca cac ket noi den co so, du lieu chuyen sang che do simggle use
	alter database Tuan5_Nhom3 set single_user with rollback immediate
	drop database Tuan5_Nhom3;
END
-- Tạo database
CREATE DATABASE Tuan5_Nhom3 COLLATE Vietnamese_CI_AS
GO
-- Dùng database
USE Tuan5_Nhom3
GO
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
ALTER TABLE NHANVIEN
	ADD
	CONSTRAINT DF_NHANVIEN_PHUCAP
	DEFAULT 0 FOR PHUCAP
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
-- Sáng
-- Công Minh
------- Ràng buộc số lượng ở bảng CHI TIẾT ĐẶT HÀNG và MẶT HÀNG
------------------------------------------------------------------INSERT----------------------------------------------------------------------------
-- Thêm dữ liệu bảng quốc gia
set dateformat dMy;
INSERT INTO QuocGia 
VALUES   
	('VN0001', N'Việt Nam'),  
	('US0002', N'Hoa Kỳ'),  
	('JP0003', N'Nhật Bản'),  
	('FR0004', N'Pháp'),  
	('DE0005', N'Đức'),  
	('CN0006', N'Trung Quốc'),  
	('IN0007', N'Ấn Độ'),  
	('GB0008', N'Vương Quốc Anh'),  
	('BR0009', N'Brazil'),  
	('AU0010', N'Úc');
-- thêm dữ liệu bảng tỉnh thành phố
INSERT INTO TinhThanhPho 
VALUES   
	('HCM001', N'Thành phố Hồ Chí Minh', 'VN0001'),  
	('HN0002', N'Hà Nội', 'VN0001'),  
	('DN0003', N'Đà Nẵng', 'VN0001'),  
	('NT0004', N'Nha Trang', 'VN0001'),  
	('DL0005', N'Đà Lạt', 'VN0001'),  
	('HP0006', N'Hải Phòng', 'VN0001'),  
	('QT0007', N'Quy Nhơn', 'VN0001'),  
	('CT0008', N'Cần Thơ', 'VN0001'),  
	('BG0009', N'Bắc Giang', 'VN0001'),  
	('BN0010', N'Bắc Ninh', 'VN0001');
-- thêm dữ liệu bảng quận huyện

INSERT INTO QUANHUYEN
VALUES   
	('Q10001', N'Quận 1', 'HCM001'),  
	('Q20002', N'Quận 2', 'HCM001'),  
	('Q30003', N'Quận 3', 'HCM001'),  
	('Q40004', N'Quận 4', 'HCM001'),  
	('Q50005', N'Quận 5', 'HCM001'),  
	('HA0006', N'Huyện An Dương', 'HP0006'),  
	('HB0007', N'Huyện An Hải', 'HP0006'),  
	('DN1008', N'Huyện Ba Đình', 'HN0002'),  
	('DN2009', N'Huyện Tư Nghĩa', 'DN0003'),  
	('DN3010', N'Huyện Liên Chiểu', 'DN0003');
-- thêm dữ liệu bảng phường xã
INSERT INTO PhuongXa 
VALUES   
	('PX0001', N'Phường 1', 'Q10001'),  
	('PX0002', N'Phường 2', 'Q10001'),  
	('PX0003', N'Phường 3', 'Q20002'),  
	('PX0004', N'Phường 4', 'Q20002'),  
	('PX0005', N'Phường 5', 'Q30003'),  
	('PX0006', N'Phường 6', 'Q30003'),  
	('PX0007', N'Phường Hương Khê', 'HA0006'),  
	('PX0008', N'Phường Thủy Dương', 'HB0007'),  
	('PX0009', N'Phường Ba Đình', 'DN1008'),  
	('PX0010', N'Phường Tư Nghĩa', 'DN2009');

---- Phương : Loại hàng, Mặt hàng
--Loại hàng:
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG) 
VALUES  
	('LH0001', N'Thuốc chữa bệnh'),  
	('LH0002', N'Thực phẩm'),  
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
	('KH0001', N'CTHH 1TV S', N'Nguyễn Công Minh', N'Minh', 'ncm071205@gmail.com', '0702772847', '22334455', N'Thôn Phú Mỹ', 'PX0001'),
	('KH0002', N'CTHH 1TV A', N'Lê Văn Hùng', N'Hùng', 'lvh0201@gmail.com', '0702772848', '22334456', N'Thôn Phú Cường', 'PX0002'),
	('KH0003', N'CTHH 1TV B', N'Phạm Thị Mai', N'Mai', 'ptm0201@gmail.com', '0702772849', '22334457', N'Thôn Phú Thọ', 'PX0003'),
	('KH0004', N'CTHH 1TV C', N'Trần Công Tâm', N'Tâm', 'tct0301@gmail.com', '0702772850', '22334458', N'Thôn Phú Thành', 'PX0004'),
	('KH0005', N'CTHH 1TV D', N'Ngô Bảo Ngọc', N'Ngọc', 'nbn0401@gmail.com', '0702772851', '22334459', N'Thôn Phú Hòa', 'PX0005'),
	('KH0006', N'CTHH 1TV E', N'Đinh Quang Khánh', N'Khánh', 'dqk0501@gmail.com', '0702772852', '22334460', N'Thôn Phú An', 'PX0006'),
	('KH0007', N'CTHH 1TV F', N'Nguyễn Hồng Phúc', N'Phúc', 'nhp0601@gmail.com', '0702772853', '22334461', N'Thôn Phú Định', 'PX0007'),
	('KH0008', N'CTHH 1TV G', N'Lý Minh Hoàng', N'Hoàng', 'lmh0701@gmail.com', '0702772854', '22334462', N'Thôn Phú Lợi', 'PX0008'),
	('KH0009', N'CTHH 1TV H', N'Vũ Văn Kiệt', N'Kiệt', 'vvk0801@gmail.com', '0702772855', '22334463', N'Thôn Phú Bình', 'PX0009'),
	('KH0010', N'CTHH 1TV I', N'Tôn Thất Thảo', N'Thảo', 'ttt0901@gmail.com', '0702772856', '22334464', N'Thôn Phú Xuân', 'PX0010');

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
	('KH0001', 'NV0001', DEFAULT, GETDATE() + 5, NULL, N'Thôn Phú Mỹ', 'PX0001'),
	('KH0002', 'NV0002', '3-1-2022', '2-2-2022', '2-2-2022', N'Số 2 Đường 2', 'PX0002'),
	('KH0003', 'NV0003', DEFAULT, NULL, NULL, N'Thôn Phú Thọ', 'PX0003'),
	('KH0004', 'NV0004', DEFAULT, GETDATE() + 5, GETDATE() + 9, N'Số 4 Đường 4', 'PX0004'),
	('KH0005', 'NV0005', DEFAULT, GETDATE() + 7, NULL, N'Số 5 Đường 5', 'PX0005'),
	('KH0006', 'NV0006','3-1-2022', '2-4-2022', '2-4-2022', N'Số 6 Đường 6', 'PX0006'),
	('KH0007', 'NV0007', DEFAULT, GETDATE() + 8, NULL, N'Số 7 Đường 7', 'PX0007'),
	('KH0008', 'NV0008', DEFAULT, GETDATE() + 6, NULL, N'Số 8 Đường 8', 'PX0008'),
	('KH0009', 'NV0009', DEFAULT, NULL, NULL, N'Số 9 Đường 9', 'PX0009'),
	('KH0010', 'NV0010', DEFAULT, GETDATE() + 4, GETDATE() + 7, N'Số 10 Đường 10', 'PX0010');


--Hữu Sáng
--Nhà Cung Cấp
INSERT INTO NHACUNGCAP(MACONGTY, TENCONGTY, TENGIAODICH, DIENTHOAI, FAX, EMAIL, SONHATENDUONG, MAPXNo)  
VALUES  
    ('CT0001', N'THIÊN LONG', N'SAIGONMART', N'0865658451', '525525', 'info@saigonmart.vn', N'Thôn Phú Mỹ', 'PX0001'),  
    ('CT0002', N'CTHH 1TV A', N'GIAOHANG', N'0865658452', '325325', 'contact@viettrade.com', N'Thôn Phú Cường', 'PX0002'),  
    ('CT0003', N'MEGASTORE', N'SAIGONMART', N'0865658453', '625625', 'support@bigshop.vn', N'Thôn Phú Thọ', 'PX0003'),  
    ('CT0004', N'CTHH 1TV E', N'VIETTRADE', N'0865658454', '225225', 'sales@giaodich24h.com', N'Thôn Phú Thành', 'PX0004'),  
    ('CT0005', N'HÒA BÌNH', N'SAIGONMART', N'0865658455', '525525', 'customer@vinatrade.vn', N'Thôn Phú Hòa', 'PX0005'),  
    ('CT0006', N'CTHH 1TV H', N'VIETTRADE', N'0865658456', '125125', 'hello@megastore.vn', N'Thôn Phú An', 'PX0006'),  
    ('CT0007', N'CTHH 1TV 3', N'MEGASTORE', N'0865658457', '525525', 'service@vietmart.com', N'Thôn Phú Định', 'PX0007'),  
    ('CT0008', N'SAIGONMART', N'SAIGONMART', N'0865658458', '325325', 'admin@thanhcongtrade.vn', N'Thôn Phú Lợi', 'PX0008'),  
    ('CT0009', N'HÒA PHÁT', N'MEGASTORE', N'0865658459', '525525', 'support@sieuthiso.vn', N'Thôn Phú Bình', 'PX0009'),  
    ('CT0010', N'VINALMILK', N'VINALMILK', N'0865658410', '925925', 'info@daisymart.com', N'Thôn Phú Xuân', 'PX0010'); 
 
 
INSERT INTO MATHANG (MAMATHANG, TENHANG, MACONGTY, MALOAIHANG, SOLUONG, DONVITINH, GIAHANG) 
VALUES  
	('MH0001', N'Paracetamol 500mg', 'CT0001', 'LH0001', 3000, N'Hộp', 120.00),  
	('MH0002', N'Vitamin C 1000mg', 'CT0001', 'LH0002', 3033, N'Hộp', 85.50),  
	('MH0003', N'Son môi Super Matte', 'CT0002', 'LH0003', 4500, N'Cây', 250.00),  
	('MH0004', N'Salmon tươi', 'CT0001', 'LH0004', 5000, N'Kg', 450.00),  
	('MH0005', N'Nồi cơm điện', 'CT0002', 'LH0005', 5600, N'Cái', 750.00),  
	('MH0006', N'Iphone 13', 'CT0003', 'LH0006', 4300, N'Cái', 30000.00),  
	('MH0007', N'Áo phông nam', 'CT0002', 'LH0007', 6000, N'Cái', 150.00),  
	('MH0008', N'Váy đầm nữ', 'CT0001', 'LH0008', 7000, N'Cái', 400.00),  
	('MH0009', N'Tivi LED 50 inches', 'CT0003', 'LH0009', 10200, N'Cái', 12000.00),  
	('MH0010', N'Áo khoác trẻ em', 'CT0001', 'LH0010', 2330, N'Cái', 300.00),
	('MH0011', N'Sữa hộp XYZ', 'CT0010', 'LH0002', 7302, N'Hộp', 50.00);

--Chi tiết đơn HàngHàng
INSERT INTO CHITIETDATHANG(SOHOADON, MAHANG, GIABAN, SOLUONG, MUCGIAMGIA) 
VALUES 
	(1, 'MH0003', 750, 100, 5), 
	(1, 'MH0005', 1500, 200, 8), 
	(2, 'MH0008', 800, 1000, 4), 
	(2, 'MH0001', 4500, 150, 10), 
	(3, 'MH0009', 15000, 100, 3), 
	(3, 'MH0004', 1000, 300, 5), 
	(4, 'MH0011', 100, 100, 4), 
	(4, 'MH0002', 120, 600, 3), 
	(5, 'MH0010', 800, 100, 5), 
	(5, 'MH0006', 35000, 500, 5),
	(6, 'MH0011', 100, 250, 5), 
	(7, 'MH0003', 150, 400, 5), 
	(7, 'MH0009', 15000, 350, 3), 
	(8, 'MH0006', 35000, 150, 5), 
	(9, 'MH0002', 120, 80, 3), 
    (10, 'MH0005', 1500, 300, 8);




------------------------------------------------------------------UPDATE----------------------------------------------------------------------------
--Hữu Sáng
--a,) Cập nhật lại giá trị trường NGAYCHUYENHANG của những bản ghi có NGAYCHUYENHANG chưa xác định (NULL) trong bảng DONDATHANG bằng với giá trị của trường NGAYDATHANG. 
UPDATE DONDATHANG  
SET NGAYCHUYENHANG = NGAYDATHANG  
WHERE NGAYCHUYENHANG IS NULL; 

select *from DONDATHANG
--b) Tăng số lượng hàng của những mặt hàng do công ty VINAMILK cung cấp lên gấp đôi. 

UPDATE MATHANG 
SET SOLUONG = SOLUONG * 2  
FROM  MATHANG d, NHACUNGCAP c
WHERE c.MACONGTY=d.MACONGTY AND c.TENCONGTY = N'VINAMILK'; 

select *from MATHANG

-- Công Minh
/* c)Cập nhật giá trị của trường NOIGIAOHANG trong bảng DONDATHANG 
bằng địa chỉ của khách hàng đối với những đơn đặt hàng chưa xác định được nơi giao hàng (giá trị trường NOIGIAOHANG bằng NULL).*/
UPDATE DONDATHANG
SET SoNhaTenDuong = k.SoNhaTenDuong, MaPXNo = k.MaPXNo
FROM KHACHHANG k
WHERE DONDATHANG.SoNhaTenDuong IS NULL

select *from DONDATHANG

/*d)Cập nhật lại dữ liệu trong bảng KHACHHANG sao cho nếu tên công ty và tên giao dịch của 
khách hàng trùng với tên công ty và tên giao dịch của một nhà cung cấp nào đó thì địa chỉ, điện thoại, fax và e-mail phải giống nhau.*/


UPDATE KHACHHANG
SET	SoNhaTenDuong = n.SoNhaTenDuong, MaPXNo = n.MaPXNo, EMAIL = n.EMAIL, DIENTHOAI = n.DIENTHOAI, FAX = n.FAX
FROM dbo.NHACUNGCAP n
WHERE n.TENCONGTY = dbo.KHACHHANG.TENCONGTY AND n.TENGIAODICH = dbo.KHACHHANG.TENGIAODICH

select *from KHACHHANG

--huy
/*e)Tăng lương lên gấp rưỡi cho những nhân viên bán được số lượng hàng nhiều hơn 100 trong năm 2022.*/

UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN*1.5
WHERE MANHANVIEN IN (SELECT D.MANHANVIEN
					FROM DONDATHANG D, CHITIETDATHANG C
					WHERE D.SOHOADON = C.SOHOADON 
					AND YEAR(NGAYDATHANG) = 2024
					GROUP BY MANHANVIEN 
					HAVING SUM(SOLUONG) > 10)

select *from NHANVIEN

/* f)Tăng phụ cấp lên bằng 50% lương cho những nhân viên bán được hàng nhiều nhất.*/
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

select *from NHANVIEN

--Phuong 
--g)Giảm 25% lương của những nhân viên trong năm 2023 không lập được bất kỳ đơn đặt hàng nào.

UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN - LUONGCOBAN*0.25
WHERE MANHANVIEN NOT IN ( SELECT MANHANVIEN
						  FROM DONDATHANG
						  WHERE NGAYGIAOHANG BETWEEN '1/1/2024'and '31/12/2024')

select *from NHANVIEN
	
---------------------------------------------------------------BAI TAP CA NHAN-------------------------------------------------------------------------------
--1)Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch [VINALMILK]  là gì?

-- cách 1 dùng câu lệnh where để nối quan hệ giữa các bảng 


select *
from NHACUNGCAP

SELECT SONHATENDUONG, TENPX,TENQH,TENTTP,TENQG,DIENTHOAI
FROM NHACUNGCAP,PHUONGXA,QUANHUYEN,QUOCGIA,TINHTHANHPHO
WHERE TENGIAODICH = N'VINALMILK' AND MAPX = MAPXNo AND MAQH = MAQHNo AND MATTP = MATTPNo AND MAQG = MAQGNo

-- cách 2 dùng câu lệnh JORN Bảng ON thuộc tính 1 = thuộc tính 2  để liên kết quan hệ giữa các bảng 
SELECT SONHATENDUONG,TENPX,TENQH,TENTTP,TENQG,DIENTHOAI  
FROM  NHACUNGCAP  
JOIN  PHUONGXA  ON  MAPX = MAPXNo  
JOIN  QUANHUYEN  ON MAQH = MAQHNo  
JOIN  TINHTHANHPHO  ON MATTP =MATTPNo  
JOIN  QUOCGIA qg ON MAQG = MAQGNo  
WHERE TENGIAODICH = N'VINALMILK';

-- Cách 3 dùng subquery
SELECT  SONHATENDUONG, TENPX,TENQH, TENTTP,TENQG,DIENTHOAI
FROM NHACUNGCAP 
JOIN PHUONGXA  ON MAPX = MAPXNo
JOIN QUANHUYEN  ON MAQH = MAQHNo
JOIN TINHTHANHPHO  ON MATTP = MATTPNo
JOIN QUOCGIA  ON MAQG = MAQGNo
WHERE MACONGTY IN (SELECT MACONGTY 
					 FROM NHACUNGCAP 
					 WHERE TENGIAODICH = N'VINALMILK')

-- Phát triển và hoàn thiện cách làm câu 1 

SELECT CONCAT(SONHATENDUONG, ',', TENPX, ',', TENQH,',',TENTTP,',',TENQG)  "Địa chỉ",DIENTHOAI   "Số điện thoại"
FROM  NHACUNGCAP  
JOIN  PHUONGXA  ON  MAPX = MAPXNo  
JOIN  QUANHUYEN  ON MAQH = MAQHNo  
JOIN  TINHTHANHPHO  ON MATTP =MATTPNo  
JOIN  QUOCGIA qg ON MAQG = MAQGNo  
WHERE TENGIAODICH = N'VINALMILK';

--2)Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ của các công ty đó là gì?

-- cách 1 dùng câu lệnh where để nối quan hệ giữa các bảng 

select *
from NHACUNGCAP

select *
from MATHANG

select *
from LOAIHANG


SELECT DISTINCT c.MACONGTY,c.TENCONGTY,d.MALOAIHANG,TENLOAIHANG,SONHATENDUONG, TENPX,TENQH,TENTTP,TENQG
FROM NHACUNGCAP c,PHUONGXA,QUANHUYEN,QUOCGIA,TINHTHANHPHO,LOAIHANG l,MATHANG d
WHERE l.MALOAIHANG = d.MALOAIHANG AND MAPX = MAPXNo AND MAQH = MAQHNo AND MATTP = MATTPNo AND MAQG = MAQGNo AND c.MACONGTY = d.MACONGTY AND TENLOAIHANG = N'thực phẩm'

-- cách 2 dùng câu lệnh JORN Bảng ON thuộc tính 1 = thuộc tính 2  để liên kết quan hệ giữa các bảng 

SELECT DISTINCT c.MACONGTY "Mã Công Ty",c.TENCONGTY "Tên công ty",l.MALOAIHANG,TENLOAIHANG,SONHATENDUONG,TENPX,TENQH,TENTTP,TENQG,DIENTHOAI
FROM NHACUNGCAP c
JOIN MATHANG d ON c.MACONGTY = d.MACONGTY
JOIN LOAIHANG l ON l.MALOAIHANG = d.MALOAIHANG
JOIN PHUONGXA  ON MAPX = MAPXNo
JOIN QUANHUYEN  ON MAQH = MAQHNo
JOIN TINHTHANHPHO  ON MATTP = MATTPNo
JOIN QUOCGIA  ON MAQG = MAQGNo
WHERE TENLOAIHANG = N'thực phẩm'


-- Phát triển cách làm câu 2

SELECT DISTINCT c.MACONGTY "Mã Công Ty",c.TENCONGTY "Tên công ty",l.MALOAIHANG "Mã Loại Hàng", 
TENLOAIHANG  "Tên Loại Hàng",CONCAT(SONHATENDUONG, ',', TENPX, ',', TENQH,',',TENTTP,',',TENQG)  "Địa chỉ",
DIENTHOAI   "Số điện thoại"
FROM NHACUNGCAP c
JOIN MATHANG d ON c.MACONGTY = d.MACONGTY
JOIN LOAIHANG l ON l.MALOAIHANG = d.MALOAIHANG
JOIN PHUONGXA  ON MAPX = MAPXNo
JOIN QUANHUYEN  ON MAQH = MAQHNo
JOIN TINHTHANHPHO  ON MATTP = MATTPNo
JOIN QUOCGIA  ON MAQG = MAQGNo
WHERE TENLOAIHANG = N'thực phẩm'

--3)Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng Sữa hộp XYZ của công ty?

-- cách 1 dùng câu lệnh where để nối quan hệ giữa các bảng 


select *
from KHACHHANG

select *
from DONDATHANG

select *
from CHITIETDATHANG

select *
from MATHANG


SELECT DISTINCT k.MAKHACHHANG "Mã Khách hàng",  k.TENGIAODICH "Khách Hàng"
FROM KHACHHANG k,DONDATHANG d,CHITIETDATHANG c,MATHANG m
WHERE k.MAKHACHHANG = d.MAKHACHHANG AND d.SOHOADON = c.SOHOADON AND c.MAHANG = m.MAMATHANG AND m.TENHANG = N'Sữa hộp XYZ'

-- cách 2 dùng câu lệnh JORN Bảng ON thuộc tính 1 = thuộc tính 2  để liên kết quan hệ giữa các bảng 

SELECT DISTINCT k.MAKHACHHANG "Mã Khách hàng", TENGIAODICH  "Khách Hàng"
FROM KHACHHANG k
JOIN DONDATHANG d ON k.MAKHACHHANG = d.MAKHACHHANG
JOIN CHITIETDATHANG c ON d.SOHOADON = c.SOHOADON
JOIN MATHANG m ON c.MAHANG = m.MAMATHANG
WHERE m.TENHANG = N'Sữa hộp XYZ';

-- cách 3 subquery

SELECT MAKHACHHANG "Mã Khách hàng",TENGIAODICH  "Khách Hàng"
FROM KHACHHANG 
WHERE   MAKHACHHANG IN (SELECT DISTINCT d.MAKHACHHANG
						FROM  DONDATHANG d
						JOIN CHITIETDATHANG c ON d.SOHOADON = c.SOHOADON
						JOIN  MATHANG m ON c.MAHANG = m.MAMATHANG
						WHERE  m.TENHANG = N'Sữa hộp XYZ')
--4)Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là của công ty nào?

-- cách 1 dùng câu lệnh where để nối quan hệ giữa các bảng 

select *
from DONDATHANG

select *
from KHACHHANG


SELECT d.*,TENCONGTY "Tên Công Ty"
FROM DONDATHANG d,KHACHHANG k
WHERE d.SONHATENDUONG = k.SONHATENDUONG AND d.MAPXNo = k.MAPXNo

-- cách 2 dùng câu lệnh JORN Bảng ON thuộc tính 1 = thuộc tính 2  để liên kết quan hệ giữa các bảng 

SELECT  d.*,TENCONGTY AS "Tên Công Ty"
FROM DONDATHANG d
JOIN KHACHHANG k ON d.SONHATENDUONG = k.SONHATENDUONG AND d.MAPXNo = k.MAPXNo;

--5)Tổng số tiền mà khách hàng phải trả cho mỗi đơn đặt hàng là bao nhiêu?

-- cách 1 dùng câu lệnh where để nối quan hệ giữa các bảng

select *
from CHITIETDATHANG

select *
from DONDATHANG

select *
from KHACHHANG

SELECT  k.MAKHACHHANG "Mã Khách Hàng", k.TENCONGTY "Tên Công Ty",d.sohoadon "Hóa đơn",SUM(c.SOLUONG * c.GIABAN-(c.SOLUONG * c.GIABAN)*MUCGIAMGIA/100)  "Tổng số tiền" 
FROM KHACHHANG k,DONDATHANG d,CHITIETDATHANG c
WHERE k.MAKHACHHANG = d.MAKHACHHANG AND d.SOHOADON = c.SOHOADON
GROUP BY k.MAKHACHHANG, k.TENCONGTY,d.sohoadon

-- cách 2 dùng câu lệnh JORN Bảng ON thuộc tính 1 = thuộc tính 2  để liên kết quan hệ giữa các bảng 

SELECT k.MAKHACHHANG AS "Mã Khách Hàng",k.TENCONGTY AS "Tên Công Ty", d.sohoadon "Hóa đơn",
SUM(c.SOLUONG * c.GIABAN - (c.SOLUONG * c.GIABAN) * MUCGIAMGIA / 100) AS "Tổng số tiền"  
FROM KHACHHANG k  
JOIN  DONDATHANG d ON k.MAKHACHHANG = d.MAKHACHHANG  
JOIN  CHITIETDATHANG c ON d.SOHOADON = c.SOHOADON  
GROUP BY k.MAKHACHHANG,k.TENCONGTY,d.sohoadon 

-- cách 3 subquery

SELECT k.MAKHACHHANG AS "Mã Khách Hàng",k.TENCONGTY AS "Tên Công Ty", d.sohoadon "Hóa đơn",
    (SELECT SUM(c.SOLUONG * c.GIABAN - (c.SOLUONG * c.GIABAN) * MUCGIAMGIA / 100) 
     FROM DONDATHANG d 
     JOIN CHITIETDATHANG c ON d.SOHOADON = c.SOHOADON 
     WHERE d.MAKHACHHANG = k.MAKHACHHANG) AS "Tổng số tiền"
FROM  KHACHHANG k
JOIN DONDATHANG d ON k.MAKHACHHANG = d.MAKHACHHANG
WHERE  k.MAKHACHHANG IN (SELECT DISTINCT d.MAKHACHHANG 
						 FROM DONDATHANG d)

--6)Hãy cho biết tổng số tiền lời mà công ty thu  được từ mỗi mặt hàng trong năm 2022.


select *
from CHITIETDATHANG

select *
from DONDATHANG

select *
from MATHANG


-- cách 1 dùng câu lệnh where để nối quan hệ giữa các bảng
SELECT m.MAMATHANG,m.TENHANG,SUM((c.SOLUONG * c.GIABAN - (c.SOLUONG * c.GIABAN) * MUCGIAMGIA / 100)-c.SOLUONG*GIAHANG) "Tổng tiền"
FROM MATHANG m,CHITIETDATHANG c,DONDATHANG d
WHERE m.MAMATHANG = c.MAHANG AND d.SOHOADON = c.SOHOADON AND YEAR(NGAYGIAOHANG) = 2022 
GROUP BY m.MAMATHANG,m.TENHANG

-- cách 2 dùng câu lệnh JORN Bảng ON thuộc tính 1 = thuộc tính 2  để liên kết quan hệ giữa các bảng 
SELECT m.MAMATHANG,m.TENHANG,
SUM((c.SOLUONG * c.GIABAN - (c.SOLUONG * c.GIABAN) * c.MUCGIAMGIA / 100) - c.SOLUONG * m.GIAHANG) AS "Tổng tiền"
FROM  MATHANG m
JOIN CHITIETDATHANG c ON m.MAMATHANG = c.MAHANG
JOIN DONDATHANG d ON d.SOHOADON = c.SOHOADON
WHERE YEAR(d.NGAYGIAOHANG) = 2022
GROUP BY  m.MAMATHANG, m.TENHANG;


------------------------------------------------------------------------BAI TAP NHOM--------------------------------------------------------------------------------------
--1)

select MAMATHANG,TENHANG, sum(m.SOLUONG-c.SOLUONG)
from MATHANG m
join CHITIETDATHANG c on MAMATHANG = MAHANG
group by MAMATHANG,TENHANG

--2)

SELECT c.MACONGTY "Mã Công Ty",c.TENCONGTY "Tên công ty",MAMATHANG "Mã Mặt Hàng", 
TENHANG  "Tên Mặt Hàng"
FROM NHACUNGCAP c
JOIN MATHANG d ON c.MACONGTY = d.MACONGTY

--3)

select MANHANVIEN,HO,TEN,(LUONGCOBAN+PHUCAP) "Tiền Lương"
from NHANVIEN

--4)
select MAMATHANG,TENHANG
from MATHANG
where MAMATHANG NOT IN (select DISTINCT MAHANG
						from CHITIETDATHANG)
--5)
select k.MAKHACHHANG,TENCONGTY,SUM(c.SOLUONG * c.GIABAN - (c.SOLUONG * c.GIABAN) * MUCGIAMGIA / 100)
from KHACHHANG k
JOIN DONDATHANG d ON d.MAKHACHHANG = k.MAKHACHHANG
JOIN CHITIETDATHANG c ON c.SOHOADON = d.SOHOADON
GROUP BY k.MAKHACHHANG,TENCONGTY
--6)
SELECT m.MAMATHANG,m.TENHANG,
SUM((c.SOLUONG * c.GIABAN - (c.SOLUONG * c.GIABAN) * c.MUCGIAMGIA / 100) - c.SOLUONG * m.GIAHANG) AS "Tổng tiền"
FROM  MATHANG m
JOIN CHITIETDATHANG c ON m.MAMATHANG = c.MAHANG
JOIN DONDATHANG d ON d.SOHOADON = c.SOHOADON
WHERE YEAR(d.NGAYGIAOHANG) = 2022
GROUP BY  m.MAMATHANG, m.TENHANG;


-----------------------------------------------------------------------BAI TAP NHOM TUAN 10------------------------------------------------------------------------------------
--1
SELECT DISTINCT N.* FROM NHACUNGCAP N
JOIN MATHANG M ON M.MACONGTY = N.MACONGTY

--2
select m.MAMATHANG,m.TENHANG, sum(m.SOLUONG - c.SOLUONG) "Số lượng"
from MATHANG m
join CHITIETDATHANG c on c.MAHANG = m.MAMATHANG
group by m.MAMATHANG,m.TENHANG

--3
SELECT CONCAT(HO, ' ', TEN) "Họ và tên", CONCAT(SONHATENDUONG, ', ', PX.TENPX, ', ', QH.TENQH, ', ', T.TENTTP, ', ', QG.TENQG) "Địa chỉ", YEAR(NGAYLAMVIEC) "Năm bắt đầu làm việc"
FROM NHANVIEN n
JOIN PHUONGXA px ON n.MAPXNo = px.MAPX
JOIN QUANHUYEN qh ON px.MAQHNo = qh.MAQH
JOIN TINHTHANHPHO t ON  t.MATTP = qh.MATTPNo
JOIN QUOCGIA qg ON t.MAQGNo = qg.MAQG

--4
select *
from NHACUNGCAP
SELECT MACONGTY, TENCONGTY, CONCAT(SONHATENDUONG, ', ', PX.TENPX, ', ', QH.TENQH, ', ', T.TENTTP, ', ', QG.TENQG) "Địa chỉ", DIENTHOAI "Số điện thoại"
FROM NHACUNGCAP n
JOIN PHUONGXA px ON n.MAPXNo = px.MAPX
JOIN QUANHUYEN qh ON px.MAQHNo = qh.MAQH
JOIN TINHTHANHPHO t ON  t.MATTP = qh.MATTPNo
JOIN QUOCGIA qg ON t.MAQGNo = qg.MAQG
WHERE TENGIAODICH = 'VINALMILK'

--5
update CHITIETDATHANG 
set SOLUONG = SOLUONG/10;

select m.MAMATHANG, m.TENHANG
from MATHANG m
join CHITIETDATHANG c on c.MAHANG = m.MAMATHANG
where GIAHANG > 100000
group by m.MAMATHANG, m.TENHANG
having sum(m.SOLUONG - c.SOLUONG) < 50


-- 6. 
SELECT * FROM dbo.MATHANG
SELECT * FROM dbo.NHACUNGCAP

SELECT m.MAMATHANG, m.TENHANG, n.TENCONGTY 
FROM dbo.MATHANG m 
JOIN dbo.NHACUNGCAP n ON n.MACONGTY = m.MACONGTY

-- 7.

SELECT * FROM dbo.NHACUNGCAP

SELECT * FROM [dbo].[MATHANG]

UPDATE MATHANG
set MACONGTY = 'CT0004'
where MAMATHANG = 'MH0003'

UPDATE NHACUNGCAP
set TENCONGTY = N'Việt Tiến'
where MACONGTY = 'CT0004'

SELECT n.TENCONGTY, m.TENHANG 
FROM dbo.NHACUNGCAP n 
JOIN dbo.MATHANG m ON m.MACONGTY = n.MACONGTY
WHERE n.TENCONGTY = N'Việt Tiến'

-- 8. 

SELECT DISTINCT c.MACONGTY "Mã Công Ty",c.TENCONGTY "Tên công ty",l.MALOAIHANG "Mã Loại Hàng", 
TENLOAIHANG  "Tên Loại Hàng",CONCAT(SONHATENDUONG, ',', TENPX, ',', TENQH,',',TENTTP,',',TENQG)  "Địa chỉ",
DIENTHOAI   "Số điện thoại"
FROM NHACUNGCAP c
JOIN MATHANG d ON c.MACONGTY = d.MACONGTY
JOIN LOAIHANG l ON l.MALOAIHANG = d.MALOAIHANG
JOIN PHUONGXA  ON MAPX = MAPXNo
JOIN QUANHUYEN  ON MAQH = MAQHNo
JOIN TINHTHANHPHO  ON MATTP = MATTPNo
JOIN QUOCGIA  ON MAQG = MAQGNo
WHERE TENLOAIHANG = N'thực phẩm'

-- 9.

SELECT DISTINCT k.MAKHACHHANG "Mã Khách hàng", TENGIAODICH  "Khách Hàng"
FROM KHACHHANG k
JOIN DONDATHANG d ON k.MAKHACHHANG = d.MAKHACHHANG
JOIN CHITIETDATHANG c ON d.SOHOADON = c.SOHOADON
JOIN MATHANG m ON c.MAHANG = m.MAMATHANG
WHERE m.TENHANG = N'Sữa hộp XYZ';

-- 10.

SELECT k.TENCONGTY, CONCAT(n.HO, ' ', n.TEN) AS [Nhân viên phụ trách], d.NGAYDATHANG, 
CONCAT(d.SONHATENDUONG, ' ', p.TENPX, ' ', q.TENQH, ' ', t.TENTTP, ' ', qg.TENQG) AS [Địa chỉ]
FROM dbo.DONDATHANG d JOIN dbo.KHACHHANG k ON k.MAKHACHHANG = d.MAKHACHHANG
JOIN dbo.NHANVIEN n ON n.MANHANVIEN = d.MANHANVIEN, dbo.PHUONGXA p, dbo.QUANHUYEN q, dbo.TINHTHANHPHO t, dbo.QUOCGIA qg
WHERE d.SOHOADON = 1 AND p.MAPX = d.MAPXNo AND p.MAQHNo = q.MAQH AND q.MATTPNo = t. MATTP  AND t.MAQGNo = qg.MAQG

--11
UPDATE NHANVIEN
SET PHUCAP = 0
WHERE PHUCAP IS NULL

select MANHANVIEN, CONCAT(HO,' ',TEN) 'Họ và tên', (LUONGCOBAN + PHUCAP) 'Lương'
from NHANVIEN


--12.

SELECT KH.*  
FROM KHACHHANG KH  
JOIN NHACUNGCAP NC ON KH.TENCONGTY = NC.TENCONGTY

SELECT KH.* 
FROM KHACHHANG KH, NHACUNGCAP DH  
WHERE KH.TENCONGTY = DH.TENCONGTY  

--13.

SELECT * 
FROM  NHANVIEN 
WHERE NGAYSINH IN(SELECT test.NGAYSINH 
				  FROM (SELECT NGAYSINH, COUNT(NGAYSINH) AS soLuong
						FROM dbo.NHANVIEN 
						GROUP BY NGAYSINH 
						HAVING COUNT(NGAYSINH) >= 2) AS test)
	
--14.
SELECT D.SOHOADON , N.MACONGTY
FROM DONDATHANG D, CHITIETDATHANG C, MATHANG M ,NHACUNGCAP N
WHERE D.SOHOADON =C.SOHOADON AND C.MAHANG=M.MAMATHANG AND M.MACONGTY =N.MACONGTY	
		AND D.SONHATENDUONG=N.SONHATENDUONG


--15)

SELECT DISTINCT n.TENCONGTY,n.TENGIAODICH,CONCAT(k.SONHATENDUONG, ',', TENPX, ',', TENQH,',',TENTTP,',',TENQG)  "Địa chỉ khách hàng",k.DIENTHOAI   "Số điện thoại khách hàng"
,CONCAT(n.SONHATENDUONG, ',', TENPX, ',', TENQH,',',TENTTP,',',TENQG)  "Địa chỉ nhà cung cấp",n.DIENTHOAI   "Số điện thoại nhà cung cấp"
FROM NHACUNGCAP n
JOIN PHUONGXA p ON p.MAPX = n.MAPXNo
JOIN  KHACHHANG k ON p.MAPX =k.MAPXNo
JOIN QUANHUYEN  ON MAQH = MAQHNo
JOIN TINHTHANHPHO  ON MATTP = MATTPNo
JOIN QUOCGIA  ON MAQG = MAQGNo
JOIN DONDATHANG d ON d.MAKHACHHANG = k.MAKHACHHANG
JOIN MATHANG m ON m.MACONGTY = n.MACONGTY


SELECT *
from MATHANG

--16)
select MAMATHANG,TENHANG
from MATHANG
where MAMATHANG NOT IN (select MAHANG
						from CHITIETDATHANG)
--17)
select MANHANVIEN,CONCAT(HO,',',TEN) "Họ và tên"
from NHANVIEN 
where MANHANVIEN NOT IN (SELECT MANHANVIEN
						 FROM DONDATHANG)
--18)
SELECT *
FROM NHANVIEN
WHERE LUONGCOBAN = (SELECT MAX(LUONGCOBAN)
					FROM NHANVIEN)


------------------------------------------------------------------- FUNCTION, PROCEDURE, TRIGGER -----------------------------------------------------------------------
--1) Tạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung thêm một bản ghi mới cho bảng MATHANG 
--(thủ tục phải thực hiện kiểm tra tính hợp lệ của dữ liệu cần bổ sung: không trùng khoá chính và đảm bảo toàn vẹn tham chiếu) 
GO
CREATE PROC PR_MATHANG_INSERT   
    @MAMATHANG CHAR(6),  
    @TENHANG NVARCHAR(50),  
    @MACONGTY CHAR(6),  
    @MALOAIHANG CHAR(6),  
    @SOLUONG INT,  
    @DONVITINH NVARCHAR(50),  
    @GIAHANG DECIMAL(10,2)  
AS  
BEGIN   
    IF @MAMATHANG IS NULL OR @TENHANG IS NULL OR @MACONGTY IS NULL OR   
       @MALOAIHANG IS NULL OR @DONVITINH IS NULL OR @GIAHANG IS NULL  
    BEGIN  
        RAISERROR('Các tham số không được để trống!', 16, 1);  
        RETURN;  
    END  
    IF LEN(@MAMATHANG) <> 6  
    BEGIN  
        RAISERROR('Mã hàng phải có độ dài 6 ký tự!', 16, 1);  
        RETURN;  
    END  
    IF @SOLUONG < 0  
    BEGIN  
        RAISERROR('Số lượng không thể là giá trị âm!', 16, 1);  
        RETURN;  
    END  
    IF @GIAHANG < 0  
    BEGIN  
        RAISERROR('Giá hàng không thể là giá trị âm!', 16, 1);  
        RETURN
    END  

    IF EXISTS (SELECT * FROM MATHANG WHERE MAMATHANG = @MAMATHANG)  
    BEGIN  
        RAISERROR('Mã hàng đã tồn tại!', 16, 1);  
        RETURN
    END  
    
    IF NOT EXISTS (SELECT * FROM NHACUNGCAP WHERE MACONGTY = @MACONGTY)  
    BEGIN  
        RAISERROR('Mã công ty không tồn tại!', 16, 1);  
        RETURN  
    END  
    
    IF NOT EXISTS (SELECT * FROM LOAIHANG WHERE MALOAIHANG = @MALOAIHANG)  
    BEGIN  
        RAISERROR('Mã loại hàng không tồn tại!', 16, 1);  
        RETURN
    END  
     
    INSERT INTO MATHANG (MAMATHANG, TENHANG, MACONGTY, MALOAIHANG, SOLUONG, DONVITINH, GIAHANG)  
    VALUES (@MAMATHANG, @TENHANG, @MACONGTY, @MALOAIHANG, @SOLUONG, @DONVITINH, @GIAHANG) 
END  
GO
EXEC PR_MATHANG_INSERT   
    @MAMATHANG ='MH0001',  
    @TENHANG = N'Bình nước',  
    @MACONGTY = 'CT0001',  
    @MALOAIHANG = 'LH00401',  
    @SOLUONG = 3,  
    @DONVITINH = 1,  
    @GIAHANG = 20.00; 
--2) Tạo thủ tục lưu trữ có chức năng thống kê 
--tổng số lượng hàng bán được của một mặt hàng có mã bất kỳ (mã mặt hàng cần thống kê là tham số của thủ tục). 
GO
CREATE PROC PR_THONGKE_TONGSOLUONGHANGBANDUOC  
    @MAHANG CHAR(6)  
AS  
BEGIN  
    SELECT ISNULL(SUM(SOLUONG), 0) AS "Tổng Số Lượng Bán"  
    FROM CHITIETDATHANG   
    WHERE MAHANG = @MAHANG  
END
GO
EXEC dbo.PR_THONGKE_TONGSOLUONGHANGBANDUOC @MAHANG = 'MH0012'
GO
SELECT * FROM CHITIETDATHANG
--3)Viết hàm trả về một bảng trong đó cho biết tổng số lượng hàng bán được của mỗi mặt hàng. 
--  Sử dụng hàm này để thống kê xem tổng số lượng hàng (hiện có và đã bán) của mỗi mặt hàng là bao nhiêu
GO
CREATE FUNCTION FC_THONGKE_TONGSOHANGHIENCOVADABAN()  
RETURNS TABLE  
AS  
RETURN  
(  
    SELECT   
        MH.MAMATHANG,  
        MH.TENHANG,  
        COALESCE(SUM(CTDH.SOLUONG), 0) AS "Tổng Số Lượng Bán",  
        MH.SOLUONG AS "Số Lượng Hiện Có"  
    FROM   
        MATHANG MH  
    LEFT JOIN   
        CHITIETDATHANG CTDH ON MH.MAMATHANG = CTDH.MAHANG  
    GROUP BY   
        MH.MAMATHANG, MH.TENHANG, MH.SOLUONG  
)  
GO
SELECT *   
FROM FC_THONGKE_TONGSOHANGHIENCOVADABAN();
GO

/*
4) Viết trigger cho bảng CHITIETDATHANG theo yêu cầu sau: 
•Khi một bản ghi mới được bổ sung vào bảng này thì giảm số lượng hàng hiện có nếu số lượng hàng hiện có lớn hơn hoặc bằng số lượng hàng được bán ra. 
Ngược lại thì huỷ bỏ thao tác bổ sung. 
•Khi cập nhật lại số lượng hàng được bán, kiểm tra số lượng hàng được cập nhật lại có phù hợp hay không 
(số lượng hàng bán ra không được vượt quá số lượng hàng hiện có và không được nhỏ hơn 1).
Nếu dữ liệu hợp lệ thì giảm (hoặc tăng) số lượng hàng hiện có trong công ty, ngược lại thì huỷ bỏ thao tác cập nhật. 
*/

CREATE TRIGGER TG_CTDH_INSERT
ON 
AFTER INSERT 


