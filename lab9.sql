--1 Viết hàm diemtb dạng Scarlar function tính điểm trung bình của một sinh viên bất kỳ
go
create function diemtb (@msv char(5))
returns float
as
begin
 declare @tb float
 set @tb = (select avg(Diemthi)
 from KetQua
where MaSV=@msv)
 return @tb
end
go
select dbo.diemtb ('01')--2.	Viết hàm bằng 2 cách (table – value fuction và multistatement value function) tính điểm trung bình của cả lớp, thông tin gồm MaSV, Hoten, ĐiemTB, sử dụng hàm diemtb ở câu 1go
--cách 1
create function trbinhlop(@malop char(5))
returns table
as
return
 select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop
 group by s.masv, Hoten
 go
--cách 2
create function trbinhlop1(@malop char(5))
returns @dsdiemtb table (masv char(5), tensv nvarchar(20), dtb float)
as
begin
 insert @dsdiemtb
 select Sinhvien.masv, Hoten,
 trungbinh=dbo.diemtb(Sinhvien.MaSV)
 from Sinhvien s join KetQua k on Sinhvien.MaSV=KetQua.MaSV
 where MaLop=@malop
 group by Sinhvien.masv, Hoten
 return
end
go
--3.Viết một thủ tục kiểm tra một sinh viên đã thi bao nhiêu môn, tham số là MaSV, (VD sinh viên có MaSV=01
--thi 3 môn) kết quả trả về chuỗi thông báo “Sinh viên 01 thi 3 môn” hoặc “Sinh viên 01 không thi mônnào”
go
create procedure ktra @msv char(5)
as
begin
 declare @n int
 set @n=(select count(*) from ketqua where Masv=@msv)
 if @n=0
 print N'sinh vien '+@msv + N'không thi môn nào'
 else
 print 'sinh vien '+ @msv+ 'thi '+cast(@n as char(2))+ N'môn'
end
go
exec ktra '01'
--4.Viết một trigger kiểm tra sỉ số lớp khi thêm một sinh viên mới vào danh sách sinh viên thì hệ thống cập
--nhật lại siso của lớp, mỗi lớp tối đa 10SV, nếu thêm vào >10 thì thông báo lớp đầy và hủy giao dịch
go
create trigger updatelop
on sinhvien
for insert
as
begin
 declare @ss int
 set @ss=(select count(*) from sinhvien s
 where malop in(select malop from inserted))
 if @ss>10
 begin
 print N'LỚP ĐẦY'
 rollback tran
 end
 else
 begin
 update lop
 set SiSo=@ss
 where malop in (select malop from inserted)
 end