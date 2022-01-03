create database BanHangTrucTuyen
use BanHangTrucTuyen

--Khách hàng
create table KhachHang
(
	MaKH varchar(10),
	HoTenKH nvarchar(50),
	DiaChiKH nvarchar(50),
	SDT_KH varchar(15),
	DiemTichLuy int,
	IDCard varchar(10)
	CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH)
)

--Thẻ ngân hàng
create table TheNganHang
(
	IDCard varchar(10),
	TenNH nvarchar(50)
	CONSTRAINT PK_TheNganHang PRIMARY KEY (IDCard)
)

--Nhân viên
create table NhanVien
(
	MaNV varchar(10),
	HoTenNV nvarchar(50),
	GioiTinh nvarchar(5) constraint check_GioiTinh check (GioiTinh = 'Nam' or GioiTinh =N'Nữ'),
	ViTri nvarchar(50),
	ChiNhanhLamViec varchar(10)
	CONSTRAINT PK_NhanVien PRIMARY KEY (MaNV)
)

--Chi nhánh
create table ChiNhanh
(
	MaCN varchar(10),
	TenCN nvarchar(50),
	DiaChiCN nvarchar(50),
	NVQL varchar(10)
	CONSTRAINT PK_ChiNhanh PRIMARY KEY (MACN)
)

--Hoá đơn
create table HoaDon
(
	MaHD varchar(10),
	MaKH varchar(10),
	NgayLap date,
	HinhThucTT nvarchar(50) constraint Check_HinhThucTT check (HinhThucTT = N'Tiền mặt' or HinhThucTT = N'Chuyển khoản'),
	NV_ThanhToan varchar(10),
	TongGia float,
	ChiNhanh varchar(10),
	CONSTRAINT PK_HoaDon PRIMARY KEY (MaHD)
)

--Chi tiết hoá đơn
create table CT_HoaDon
(
	MaHD varchar(10),
	MaSP varchar(10),
	SoluongSP int constraint check_SLSP check (SoluongSP >= 1),
	GiaBan float constraint check_GiaBan check (GiaBan >= 1000),
	GiaGiam float,
	ThanhTien float
	CONSTRAINT PK_CT_HoaDon PRIMARY KEY (MaHD,MaSP)
)

--Sản phẩm
create table SanPham
(
	MaSP varchar(10),
	TenSP nvarchar(50),
	GiaBan float,
	MoTaSP nvarchar(50),
	SoLuongTon int,
	NhaCungCap varchar(10),
	CONSTRAINT PK_SanPham PRIMARY KEY (MaSP)
)

--Giỏ hàng
create table GioHang
(
	MaKH varchar(10),
	MaSP varchar(10),
	TenSP nvarchar(50),
	GiaBan float,
	SoLuong int
	constraint pk_GioHang primary key (MaKH, MaSP)
)

--Nhà cung cấp
create table NhaCungCap
(
	MaNCC varchar(10),
	TenNCC nvarchar(50)
	CONSTRAINT PK_NhaCungCap PRIMARY KEY (MaNCC)
)

--Phiếu nhập hàng
create table PhieuNhapHang
(
	MaPN varchar(10),
	NhaCungCap varchar(10),
	NgayNhap date,
	NV_Lap varchar(10)
	CONSTRAINT PK_PhieuNhap PRIMARY KEY (MaPN)
)

--Chi tiết phiếu nhập
create table CT_PhieuNhap
(
	MaPN varchar(10),
	MaSP varchar(10),
	SoLuongNhap int,
	CONSTRAINT PK_CT_PhieuNhap PRIMARY KEY (MaPN,MaSP)
)

--Phân công
create table PhanCong_NV
(
	MaNV varchar(10),
	NgayLamViec date,
	ChiNhanh varchar(10),
	DiemDanh nvarchar(10) constraint check_DiemDanh check (DiemDanh in (N'Có', N'Không'))
	CONSTRAINT PK_PhanCong PRIMARY KEY (MaNV, NgayLamViec, ChiNhanh)
)

--Phiếu giao hàng
create table PhieuGiaoHang
(
	MaKH varchar(10),
	MaHD varchar(10),
	DiaChiGiao nvarchar(50),
	PhiVanChuyen float
	CONSTRAINT PK_PhieuGiao PRIMARY KEY (MaKH, MaHD)
)

--Lịch sử lương
create table LichSuLuong
(
	MaNV varchar(10),
	NgayNhanLuong date,
	Luong float,
	Thuong float,
	TruLuong float,
	TongLuong float
	CONSTRAINT PK_LichSuLuong PRIMARY KEY (MaNV,NgayNhanLuong)
)

create table DanhSachNhap
(
	MaSP varchar(10),
	SoLuong int,
	NhaCungCap varchar(10)
	CONSTRAINT PK_DS_Nhap PRIMARY KEY (MaSP, NhaCungCap)
)

ALTER TABLE KhachHang 
ADD CONSTRAINT fk_kh_IDCard FOREIGN KEY (IDCard) REFERENCES TheNganHang(IDCard)

ALTER TABLE NhanVien 
ADD CONSTRAINT fk_nv_chinhanh FOREIGN KEY (ChiNhanhLamViec) REFERENCES ChiNhanh(MaCN) ON DELETE NO ACTION

ALTER TABLE HoaDon 
ADD CONSTRAINT fk_hoadon_kh FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
ALTER TABLE HoaDon
ADD CONSTRAINT fk_hoadon_nv FOREIGN KEY (Nv_ThanhToan) REFERENCES NhanVien(MaNV) ON DELETE SET NULL
ALTER TABLE HoaDon
ADD CONSTRAINT fk_hoadon_chinhanh FOREIGN KEY (ChiNhanh) REFERENCES ChiNhanh(MaCN) ON DELETE NO ACTION

ALTER TABLE CT_HoaDon
ADD CONSTRAINT fk_cthoadon_hd FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD) ON DELETE CASCADE
ALTER TABLE CT_HoaDon
ADD CONSTRAINT fk_cthoadon_sp FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON DELETE CASCADE
ALTER TABLE CT_HoaDon
ADD CONSTRAINT fk_cthoadon_sp2 FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE

ALTER TABLE SanPham 
ADD CONSTRAINT fk_sp_nhacungcap FOREIGN KEY (NhaCungCap) REFERENCES NhaCungCap(MaNCC)

ALTER TABLE GioHang 
ADD CONSTRAINT fk_GH_KH FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
ALTER TABLE GioHang 
ADD CONSTRAINT fk_GH_SP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON DELETE CASCADE

ALTER TABLE PhieuNhapHang  
ADD CONSTRAINT fk_phieunhap_ncc FOREIGN KEY (NhaCungCap) REFERENCES NhaCungCap(MaNCC)
ALTER TABLE PhieuNhapHang
ADD CONSTRAINT fk_phieunhap_nv FOREIGN KEY (NV_Lap) REFERENCES NhanVien(MaNV) ON DELETE SET NULL

ALTER TABLE CT_PhieuNhap 
ADD CONSTRAINT fk_ctpn_phieunhap FOREIGN KEY (MaPN) REFERENCES PhieuNhapHang(MaPN) ON DELETE CASCADE
ALTER TABLE CT_PhieuNhap
ADD CONSTRAINT fk_ctpn_sp FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON DELETE CASCADE

ALTER TABLE ChiNhanh
ADD CONSTRAINT fk_chinhanh_nv FOREIGN KEY (NVQL) REFERENCES NhanVien(MaNV) ON DELETE SET NULL

ALTER TABLE PhanCong_NV
ADD CONSTRAINT fk_phancong_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON DELETE CASCADE
ALTER TABLE PhanCong_NV
ADD CONSTRAINT fk_phancong_cn FOREIGN KEY (ChiNhanh) REFERENCES ChiNhanh(MaCN) ON DELETE CASCADE

ALTER TABLE PhieuGiaoHang 
ADD CONSTRAINT fk_phieugiao_kh FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
ALTER TABLE PhieuGiaoHang
ADD CONSTRAINT fk_phieugiao_hd FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD) ON DELETE CASCADE

ALTER TABLE LichSuLuong
ADD CONSTRAINT fk_lichsu_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON DELETE CASCADE

ALTER TABLE DanhSachNhap
ADD CONSTRAINT fk_DS_SP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)	ON DELETE CASCADE
ALTER TABLE DanhSachNhap
ADD CONSTRAINT fk_DS_NCC FOREIGN KEY (NhaCungCap) REFERENCES NhaCungCap(MaNCC)