# FlowTask — website HTML + Supabase + Netlify

FlowTask là website quản lý cá nhân tiếng Việt, gồm 4 chức năng chính:
1. Công việc: tạo, lọc, đánh dấu hoàn thành, đặt hạn và mức ưu tiên.
2. Ghi chú: tạo, chỉnh sửa, xóa ghi chú.
3. Mục tiêu: mô tả, hạn hoàn thành và tiến độ 0–100%.
4. Thói quen: tạo thói quen và đánh dấu hoàn thành trong ngày.

## A. Thiết lập Supabase
1. Tạo project tại https://supabase.com/
2. Vào **SQL Editor** → **New query**, dán toàn bộ `supabase-schema.sql`, bấm **Run**.
3. Vào **Project Settings → API** (hoặc mục API Keys trong giao diện mới), sao chép Project URL và **anon/public key** hoặc **publishable key**.
4. Mở `index.html`, tìm hai dòng:
   ```js
   const SUPABASE_URL = "https://YOUR_PROJECT_ID.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY";
   ```
   thay bằng thông tin project của bạn.
5. Trong **Authentication → URL Configuration**, sau khi deploy, đặt Site URL thành URL Netlify của bạn. Có thể thêm URL deploy vào Redirect URLs nếu cần.
6. Nếu muốn người dùng đăng ký mà không xác nhận email, cấu hình Email provider trong Authentication theo nhu cầu. Khuyến nghị giữ xác nhận email bật khi website dùng thật.

## B. Đưa lên Netlify
1. Sau khi thay thông tin Supabase, vào https://app.netlify.com/drop
2. Kéo thả thư mục chứa `index.html` lên Netlify (hoặc giải nén gói ZIP rồi kéo thả thư mục).
3. Netlify cấp URL website. Thêm URL này vào Supabase Authentication → URL Configuration.

## Bảo mật quan trọng
- Không đặt `service_role` key trong HTML/frontend. Chỉ dùng anon/public hoặc publishable key.
- Script SQL bật Row Level Security (RLS), mỗi người chỉ thao tác được dữ liệu có `user_id` trùng với `auth.uid()`.
- Supabase Auth quản lý thông tin đăng nhập trong `auth.users`; không tự lưu mật khẩu trong bảng tùy chỉnh.
- HTML tĩnh không thể giữ bí mật khóa public; an toàn dựa vào RLS và chính sách Auth.
- Đây là starter project. Trước khi dùng cho sản phẩm lớn, nên bổ sung kiểm thử, giới hạn tốc độ, giám sát lỗi và chính sách quyền riêng tư.
