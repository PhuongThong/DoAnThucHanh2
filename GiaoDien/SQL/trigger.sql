--trigger Thanhtien(CT_HoaDon)
create trigger  trg_TinhThanhTien On CT_HoaDon
For update, insert
as 
begin
	if exists (select* from Inserted i
				where (i.GiaBan-i.GiaGiam)*i.SoLuongSP != i.ThanhTien)
				begin
					raiserror('Thong tin khong hop le. Xin kiem tra lai',16,1)
					rollback transaction
				end
end
go

--trigger TongGia(HoaDon)
create trigger trg_TinhTongGia on HoaDon
For update, insert
as
begin
	if exists (select* from Inserted i
				where i.TongGia != (select sum(ct.ThanhTien) 
										from CT_HoaDon ct 
										where ct.MaHD = i.MaHD 
										group by ct.MaHD))
				begin 
					raiserror('Thong tin khong hop le. Xin kiem tra lai',16,1)
					rollback transaction
				end
end
go

--trigger GiaGiam(CT_HoaDon)
create trigger trg_GiamGia_CT_HoaDon on CT_HoaDon
for update, insert
as
begin
	if exists (select* from Inserted i
				where i.GiaBan< i.GiaGiam)
				begin 
					raiserror('Thong tin khong hop le. Xin kiem tra lai',16,1)
					rollback transaction
				end
end
go

--trigger SoLuongSP(CT_HoaDon)
create trigger trg_SoLuongSP_CT_HoaDon on CT_HoaDon
for update, insert
as
begin
	if exists (select* from inserted i, SanPham sp
				where i.SoluongSP > sp.SoLuongTon)
				begin 
					raiserror('So luong san pham khong du de cung cap. Xin kiem tra lai',16,1)
					rollback transaction
				end
end
go




