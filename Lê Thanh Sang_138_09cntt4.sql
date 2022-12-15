create table SinhVien(
MaSV varchar(20) not null primary key,
HoTen nvarchar(40),
Ngaysinh smalldatetime
)
go
create table MonHoc(
MaMH varchar(10) not null primary key,
TenMH nvarchar(40),
SoTC int
)
go
create table Diem(
MaSV varchar(20) not null constraint fk_MaSV references Sinhvien(MaSV),
MaMH varchar(10) not null  constraint fk_MaMH references MonHoc(MaMH),
DiemThi decimal
)

-----Nhập dữ liệu cho bảng-----

insert SinhVien values
('001', N'Lê thanh sang', '2002-10-10'),
('002',	N'trịnh hoàng việt ', '2002-1-1'),
('003', N'trần nguyên luân', '2002-7-5')

insert MonHoc values
('MH1', 'LTWeb', '3'),
('MH2', 'HQTCSDL', '3'),
('MH3', 'LSDCSVN', '2')

insert Diem values
('001', 'MH5', '10'),
('002', 'MH1', '7.5'),
('001', 'MH4', '6'),
('003', 'MH2', '8.5'),
('003', 'MH1', '9')
-- seclect xem dữ liệu
SELECT * FROM SinhVien
SELECT * FROM Diem
SELECT * FROM MonHoc
GO
-- CÂU 2 HÀM THỐNG KÊ SINH VIÊN CÓ ĐIỂM DƯỚI 5 CỦA MÔN HỌC  VỚI TÊN ĐƯỢC NHẬP TỪ BÀN PHÍM
create function thong_ke_diem(@TenMH nvarchar(40))
RETURNS INT AS
begin
 declare @dem int
 set @dem = (select DiemThi from Diem
where @dem<5 )
 return @dem 
end
go
select dbo.thong_ke_diem('LTW')
-- Câu 3
CREATE PROCEDURE nhapdiem (@masv CHAR(10), @mamon CHAR(10), @diemthi FLOAT)
AS
BEGIN
	INSERT INTO DIEM (MASV, MAMON, DIEMTHI)
	VALUES (@masv, @mamon, @diemthi)
END

-- câu 4
create trigger insert_edit
on Diem
FOR  INSERT, UPDATE
AS
declare @diem float
if @diem between (select DiemThi From inserted) <10 and (select DiemThi From inserted)<0
begin
print
N'Không hợp lệ '
rollback transaction
end
insert into Diem values ('001','MH3','2')








