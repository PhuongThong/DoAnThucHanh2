-- Tạo nonclustered index tìm kiếm giá bán cho mỗi sản phẩm
create nonclustered index IX_SanPham_MaSP_GiaBan
on SanPham(MaSP)
include (GiaBan)
go

-- Tạo nonclustered index tìm kiếm thành tiền cho chi tiết hóa đơn
create nonclustered index IX_SanPham_MaSP_GiaBan
on CT_HoaDon(MaHD)
include (ThanhTien)
go