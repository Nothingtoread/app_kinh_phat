# Hướng Dẫn Thêm Kinh Phật Từ PDF

## 📋 Tổng Quan

Ứng dụng "Kinh Phật Hàng Ngày" đã được cập nhật với tính năng quản lý kinh, cho phép bạn thêm kinh mới từ file PDF `kinh-phat-cho-phat-tu-tai-gia-thich-nhat-tu.pdf`.

## 🚀 Cách Sử Dụng Tính Năng Mới

### 1. Truy Cập Màn Hình Quản Lý Kinh
- Mở ứng dụng tại: `http://localhost:8080`
- Nhấn nút ⚙️ (Settings) ở góc phải màn hình chính
- Hoặc nhấn nút ❓ (Help) để xem hướng dẫn chi tiết

### 2. Thêm Kinh Mới
1. **Nhấn "Thêm Kinh Mới"**
2. **Điền thông tin:**
   - **Tên kinh**: Ví dụ "Kinh Phật cho Phật tử tại gia - Ngày 1"
   - **Thời gian**: Chọn "Kinh Sáng" hoặc "Kinh Tối"
   - **Ngày**: Chọn ngày muốn hiển thị kinh này
   - **Nội dung**: Dán nội dung từ PDF
   - **Ghi chú**: Thêm ghi chú nếu cần

### 3. Quản Lý Kinh Hiện Có
- Xem danh sách tất cả kinh đã thêm
- Xóa kinh không cần thiết
- Sắp xếp theo ngày tự động

## 📖 Hướng Dẫn Chia Kinh Từ PDF

### Bước 1: Mở File PDF
Mở file `C:\Users\NHON\Downloads\kinh-phat-cho-phat-tu-tai-gia-thich-nhat-tu.pdf`

### Bước 2: Chia Theo Chương/Đoạn
**Gợi ý chia kinh:**
- **Mỗi chương** = 1 ngày
- **Mỗi đoạn** khoảng 200-500 từ
- **Có thể chia** thành kinh sáng và kinh tối cho cùng chủ đề

### Bước 3: Sao Chép Nội Dung
1. Chọn đoạn kinh trong PDF
2. Sao chép (Ctrl+C)
3. Dán vào ứng dụng

### Bước 4: Thêm Vào Ứng Dụng
1. Mở màn hình quản lý kinh
2. Điền thông tin đầy đủ
3. Nhấn "Thêm Kinh"
4. Kiểm tra trên màn hình chính

## 📅 Ví Dụ Chia Kinh Theo Ngày

### Ngày 1 - Kinh Sáng
```
Tên: "Kinh Phật cho Phật tử tại gia - Ngày 1 - Sáng"
Nội dung: [Đoạn đầu tiên từ PDF]
Ngày: [Ngày hiện tại]
```

### Ngày 1 - Kinh Tối
```
Tên: "Kinh Phật cho Phật tử tại gia - Ngày 1 - Tối"
Nội dung: [Đoạn thứ hai từ PDF]
Ngày: [Ngày hiện tại]
```

### Ngày 2 - Kinh Sáng
```
Tên: "Kinh Phật cho Phật tử tại gia - Ngày 2 - Sáng"
Nội dung: [Đoạn thứ ba từ PDF]
Ngày: [Ngày mai]
```

## 🔧 Tính Năng Kỹ Thuật

### Cấu Trúc Dữ Liệu Mới
- **KinhData.addKinh()**: Thêm kinh mới
- **KinhData.removeKinh()**: Xóa kinh
- **KinhData.getKinhByDate()**: Tìm kinh theo ngày
- **Tự động sắp xếp** theo ngày

### Màn Hình Mới
- **KinhManagementScreen**: Quản lý kinh
- **ImportGuideScreen**: Hướng dẫn thêm kinh từ PDF
- **Tích hợp** với màn hình chính

## 📱 Cách Sử Dụng Ứng Dụng

### Màn Hình Chính
1. **Tab "Kinh Sáng"**: Xem kinh buổi sáng
2. **Tab "Kinh Tối"**: Xem kinh buổi tối
3. **Chọn ngày**: Nhấn "Chọn ngày" để xem kinh ngày khác
4. **Đọc chi tiết**: Nhấn vào card kinh để xem đầy đủ

### Màn Hình Quản Lý
1. **Thêm kinh**: Form đầy đủ để thêm kinh mới
2. **Xem danh sách**: Tất cả kinh đã thêm
3. **Xóa kinh**: Xóa kinh không cần thiết
4. **Hướng dẫn**: Xem hướng dẫn chi tiết

## ⚠️ Lưu Ý Quan Trọng

### Về Nội Dung
- **Kiểm tra chính tả** sau khi dán từ PDF
- **Định dạng văn bản** có thể cần chỉnh sửa
- **Bản quyền**: Đảm bảo có quyền sử dụng nội dung

### Về Kỹ Thuật
- **Dữ liệu tạm thời**: Kinh sẽ mất khi restart ứng dụng
- **Lưu trữ**: Cần implement database để lưu trữ lâu dài
- **Backup**: Nên backup dữ liệu quan trọng

## 🎯 Mục Tiêu Tiếp Theo

### Tính Năng Có Thể Thêm
1. **Lưu trữ database**: SQLite hoặc Firebase
2. **Import từ file**: Hỗ trợ import từ TXT, DOC
3. **Tìm kiếm**: Tìm kinh theo từ khóa
4. **Chia sẻ**: Chia sẻ kinh qua social media
5. **Thông báo**: Nhắc nhở đọc kinh hàng ngày

### Cải Thiện UI/UX
1. **Dark mode**: Chế độ tối
2. **Font size**: Điều chỉnh kích thước chữ
3. **Bookmark**: Đánh dấu kinh yêu thích
4. **History**: Lịch sử đọc kinh

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. **Kiểm tra console**: Xem lỗi trong developer tools
2. **Restart ứng dụng**: `flutter run -d web-server --web-port 8080`
3. **Kiểm tra dữ liệu**: Đảm bảo format đúng

---

**Chúc bạn có những giây phút an lạc với ứng dụng đọc kinh! 🙏**

*Ứng dụng đang chạy tại: http://localhost:8080*
