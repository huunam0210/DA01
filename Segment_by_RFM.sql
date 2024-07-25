--Bước 1: Tính giá trị R,F,M với từng khách hàng
--Bước 2: chia giá trị thành các khoảng trên thang 1-5
ntile(5) over (order by r desc) as r_score
ntile(5) over (order by f) as f_score.
ntile(5) over (order by m) as r_score.
--Bước 3: Phân nhóm theo 125 tổ hợp r-f-m
--Bước 4: Trực quan hóa dữ liệu
