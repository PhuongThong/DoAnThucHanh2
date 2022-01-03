----Procedure Quản trị----
-- proc Thêm sản phẩm
create proc usp_ThemSanPham 
	 @masp varchar(10), 
     @tensp nvarchar(50), 
     @gia float, 
     @nhaccap varchar(10),
	 @mota nvarchar(200)
as
   if exists (select MaSP from SanPham where MaSP = @masp)
   begin
        return 0
   end
   else 
   begin
        insert into SanPham(MaSP,TenSP,GiaBan,NhaCungCap,MoTaSP) values(@masp, @tensp, @gia, @nhaccap,@mota)
		if @@ROWCOUNT = 1 begin return 1 end
		else begin return 0 end
   end
go

-- proc Cập nhập số lượng tồn của sản phẩm
create proc usp_CapNhapSLT
	@masp varchar(10),
	@soluong int
as
begin
	if not exists (select * from SanPham where MaSP = @masp)
	begin
		return 0
	end
	else 
	begin
		update SanPham
		set SoLuongTon = @soluong
		where MaSP = @masp
		return 1
	end
end
go

-- proc Cập nhập giá bán của sản phẩm
create proc usp_CapNhapGia
	@masp varchar(10),
	@gia float
as
begin
	if not exists (select * from SanPham where MaSP = @masp)
	begin
		return 0
	end
	else 
	begin
		update SanPham 
		set GiaBan = @gia
		output deleted.MaSP, deleted.TenSP, deleted.GiaBan
		into UpdatedTab
		where MaSP = @masp
		return 1
	end
end
go

-- Proc Xóa sản phẩm
create proc usp_XoaSanPham 
	@masp varchar(10)
as
begin
	if not exists (select * from SanPham where MaSP = @masp)
	begin
		return 0
	end
	else
	begin
		delete from SanPham where MaSP = @masp
		return 1
	end
end
go

-- Proc truy vết giá sản phẩm
create proc usp_TruyVet
	@masp varchar(10)
as
begin
	if not exists (select * from SanPham where MaSP = @masp)
	begin
		return 0
	end
	else
	begin
		select* from UpDatedTab
		where MaSP = @masp
		return 1
	end
end
go

----- Tạo bảng phụ
--create table UpDatedTab
--(
--	MaSP varchar(10), 
--	TenSP nvarchar(50), 
--	GiaBan float,
--)

-- Proc Theo dõi tồn kho
create proc usp_TheoDoiTonKho
as
begin
	select* 
	from SanPham
end
go

-- Proc Theo dõi nhập hàng
create proc usp_LichSuNhapHang
	@ngaynhap date
as
begin
	select pn.MaPN,ct.MaSP, ct.SoLuongNhap, pn.NgayNhap,pn.NhaCungCap,pn.NV_Lap
	from PhieuNhapHang as pn, CT_PhieuNhap as ct
	where pn.MaPN = ct.MaPN and pn.NgayNhap = @ngaynhap
end
go

-- Proc Theo dõi xuất hàng
create proc usp_LichSuXuatHang
	@masp varchar(10)
as
begin
	select hd.MaHD, ct.MaSP, ct.SoluongSP, hd.NgayLap, hd.NV_ThanhToan
	from HoaDon hd, CT_HoaDon ct
	where hd.MaHD = ct.MaHD and ct.MaSP = @masp
end
go

-- Proc thêm vào danh sách nhập
create proc usp_ThemVaoDSN @MaSP varchar(10),
							@MaNCC varchar(10),
							@SoLuong int
as
begin
	insert into DanhSachNhap(MaSP, SoLuong, NhaCungCap) values (@MaSP,@SoLuong,@MaNCC)
	return 1
end
go

-- Proc tao phieu nhap hang
create proc usp_NhapHang @MaPN varchar(10),
			 @NhaCungCap varchar(10),
			 @MaNV varchar(10)
as
begin
	if exists (select* from PhieuNhapHang where MaPN = @MaPN)
		return 0
	insert into PhieuNhapHang(MaPN, NhaCungCap, NgayNhap, NV_Lap) values (@MaPN,@NhaCungCap,getdate(),@MaNV)
	declare @MaSP varchar(10)
	declare @SoLuong int
	declare @count int
	select @count = count(*) from DanhSachNhap where NhaCungCap = @NhaCungCap
	if @count = 0 begin return 0 end
	declare @index int = 0
	while @index < @count
	begin
		select @MaSP = MaSP from DanhSachNhap where NhaCungCap = @NhaCungCap
		select @SoLuong = SoLuong from DanhSachNhap where NhaCungCap =  @NhaCungCap and MaSP = @MaSP
		insert into CT_PhieuNhap(MaPN,MaSP,SoLuongNhap) values (@MaPN, @MaSP, @SoLuong)
		delete from DanhSachNhap where MaSP = @MaSP and NhaCungCap = @NhaCungCap
		set @index = @index + 1
	end 
	return 1
end
go


----Procedure Khách hàng----
--proc xem chi tiết đơn hàng
create procedure usp_XemCTDHang 
@MaHD varchar(10)
as
begin
	select*
	from CT_HoaDon
	where MaHD = @MaHD
end
go

--proc xem sản phẩm
create procedure XemSanPham
as
begin
	select*
	from SanPham 
end
go

--proc xem giỏ hàng
create procedure XemGioHang
@maKH VARCHAR(10)	
as
begin
	select*
	from GioHang gh
	where @maKH = gh.MaKH
end
go

--proc xem hoá đơn
create procedure XemHoaDon
@maKH VARCHAR(10)	
as
begin
	select *
	from HoaDon hd
	where @maKH = hd.MaKH
end
go

--proc sửa số lượng sản phẩm trong giỏ hàng
create procedure UpdateSoLuongSPGioHang
@maKH varchar(10),
@maSP varchar(10),
@solg int 
as
begin
if exists (select* from GioHang gh where gh.MaKH = @maKH and gh.MaSP = @maSP)
	begin 
	update GioHang set SoLuong = @solg where MaKH = @maKH and MaSP = @maSP ;
	return 1;
	end
else return 0;
end
go

--proc xoá sản phẩm trong giỏ hàng
create procedure XoaSPGioHang
@maKH varchar(10),
@maSP varchar(10)
as
begin
if exists (select* from GioHang gh where gh.MaSP = @maSP and gh.MaKH = @maKH)
	begin
	delete from GioHang where MaKH = @maKH and MaSP = @maSP;
	return 1;
	end
else return 0;
end
go

--proc thêm sản phẩm vào giỏ hàng
create procedure ThemSPvaoGioHang
@maKH varchar(10),
@maSP varchar(10)
as
begin
	declare @giaban int;
	declare @TenSP nvarchar(50);
	if not exists(select* from SanPham sp where sp.MaSP = @maSP) 
		return 0

	set @giaban = (select sp.GiaBan from SanPham sp where sp.MaSP = @maSP)
	set @TenSP = (select sp.TenSP from SanPham sp where sp.MaSP = @maSP)
	insert into GioHang(MaKH, MaSP,TenSP, GiaBan, SoLuong) values (@maKH, @maSP, @TenSP, @giaban, 1)
	return 1;
end
go

--proc tạo hoá đơn
create proc TaoHoaDon 
@makh varchar(10),
@httt nvarchar(30)
as 
begin tran
	begin try
		declare @mahd varchar(10);
		declare @count int;
		declare @ngaylap date;
		declare @tonggia bigint;

		set @tonggia = 0;
		set @count = (select Count(*) from HoaDon) + 2000
		set @count = @count + 1;
		
		set @mahd = 'HD' + REPLICATE('0', 4 - len(cast (@count as varchar))) + cast(@count as varchar)
		set @ngaylap= (select getdate())

		insert into HoaDon(MaHD,MaKH,NgayLap,HinhThucTT,NV_ThanhToan,TongGia,ChiNhanh) 
		values(@mahd,@makh,@ngaylap,@httt,null,0,null)

		declare @masp varchar(10);
		declare @tensp varchar(30);
		declare @sl int;
		declare @giaban int;
		declare @giagiam int;
		declare @thanhtien int;
		declare @diemtichluy int;
		declare @giam float;

		set @giam = 0
		set @diemtichluy = (select DiemTichLuy from KhachHang where MaKH = @makh)
		if(@diemtichluy > 100)
		begin
			set @giam = 0.05
		end
		if(@diemtichluy > 1000)
		begin
			set @giam = 0.1
		end

		DECLARE cursorGioHang CURSOR FOR  -- khai báo con trỏ cursorProduct
		SELECT MaSP, TenSP, GiaBan, SoLuong FROM GioHang     -- dữ liệu trỏ tới

		OPEN cursorGioHang               -- Mở con trỏ

		FETCH NEXT FROM cursorGioHang    -- Đọc dòng đầu tiên
		      INTO @masp, @tensp, @giaban, @sl

		WHILE @@FETCH_STATUS = 0          --vòng lặp WHILE khi đọc Cursor thành công
		BEGIN
		    set @giagiam = @giaban*@giam; 
			set @thanhtien = @sl*@giaban - @giagiam
			set @tonggia = @tonggia+ @thanhtien
			insert into CT_HoaDon(MaHD,MaSP,SoluongSP,GiaBan,GiaGiam,ThanhTien) values (@mahd,@masp,@sl,@giaban,@giagiam,@thanhtien)  
			update SanPham
			set SoLuongTon = SoLuongTon - @sl
			where MaSP = @masp
				  
			FETCH NEXT FROM cursorGioHang -- Đọc dòng tiếp
		    INTO @masp, @tensp, @giaban, @sl
			
			set @giagiam = 0
			set @thanhtien = 0		
		END	

		CLOSE cursorGioHang              -- Đóng Cursor
		DEALLOCATE cursorGioHang
		update HoaDon 
		set TongGia = @tonggia 
		where MaHD = @mahd

		update  Khachhang
		set DiemTichLuy = DiemTichLuy+@tonggia/100000
		where MaKH = @makh;


		delete GioHang
		where MaKH = @makh
	end try
	begin catch
		rollback tran
		return
	end catch 

commit
go

--proc đăng ký tài khoản
create proc DangKy
@taikhoan varchar(30),
@matkhau	varchar(30),
@hoten		nvarchar(50),
@diachi		nvarchar(100),
@sdt		varchar(10)
as
begin tran
	begin try
	declare @makh varchar(10)
	declare @count int
	set @count = (select count(*)from KhachHang) + 1000
	set @makh =  'KH' + REPLICATE('0', 4 - len(cast (@count as varchar))) + cast(@count as varchar)
	
	insert into KhachHang(MaKH,HoTenKH,DiaChiKH,SDT_KH,DiemTichLuy,IDCard) values (@makh,@hoten,@diachi,@sdt,0,null)
	insert into TaiKhoan(taikhoan,matkhau,makh) values (@taikhoan,@matkhau,@makh)
	end try
	begin catch
		rollback tran
		return
	end catch 
commit
