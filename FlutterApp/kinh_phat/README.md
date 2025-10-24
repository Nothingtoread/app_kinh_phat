# Ứng Dụng Kinh Phật Hàng Ngày

Ứng dụng Flutter hỗ trợ người dùng đọc kinh Phật theo ngày với 2 thời điểm: Sáng và Tối.

## Tính Năng

- 📖 **Hai tab riêng biệt**: Kinh Sáng và Kinh Tối
- 📅 **Chọn ngày**: Người dùng có thể chọn ngày để xem kinh tương ứng
- 🎨 **Giao diện đẹp**: Thiết kế phù hợp với tinh thần Phật giáo
- 📱 **Responsive**: Hoạt động tốt trên nhiều kích thước màn hình
- 📋 **Sao chép nội dung**: Có thể sao chép nội dung kinh để chia sẻ

## Cấu Trúc Dự Án

```
lib/
├── main.dart                 # Entry point của ứng dụng
├── models/
│   └── kinh_phat.dart       # Model class cho dữ liệu kinh
├── data/
│   └── kinh_data.dart       # Dữ liệu mẫu cho kinh sáng và tối
└── screens/
    ├── home_screen.dart     # Màn hình chính với TabBar
    └── kinh_detail_screen.dart # Màn hình chi tiết kinh
```

## Cách Chạy Ứng Dụng

### 1. Cài đặt Flutter
Đảm bảo bạn đã cài đặt Flutter SDK và có thể chạy `flutter doctor` thành công.

### 2. Clone và cài đặt dependencies
```bash
git clone <repository-url>
cd kinh_phat
flutter pub get
```

### 3. Chạy ứng dụng

#### Trên Web (Khuyến nghị)
```bash
flutter run -d web-server --web-port 8080
```
Sau đó mở trình duyệt và truy cập: `http://localhost:8080`

#### Trên Windows
```bash
flutter run -d windows
```

#### Trên Android
```bash
flutter run -d android
```

## Cách Sử Dụng

1. **Mở ứng dụng**: Ứng dụng sẽ hiển thị ngày hiện tại
2. **Chọn thời gian**: Sử dụng 2 tab "Kinh Sáng" và "Kinh Tối"
3. **Chọn ngày**: Nhấn nút "Chọn ngày" để xem kinh của ngày khác
4. **Đọc chi tiết**: Nhấn vào card kinh để xem nội dung đầy đủ
5. **Sao chép**: Trong màn hình chi tiết, có thể sao chép nội dung

## Dữ Liệu Mẫu

Ứng dụng hiện có dữ liệu mẫu cho 3 ngày:
- **Kinh Sáng**: Kinh Từ Bi, Kinh Quán Niệm Hơi Thở, Kinh Bốn Niệm Xứ
- **Kinh Tối**: Kinh Tâm Kinh, Kinh Kim Cang, Kinh A Di Đà

## Tùy Chỉnh

### Thêm Kinh Mới
Chỉnh sửa file `lib/data/kinh_data.dart` và thêm dữ liệu mới vào các hàm `_generateKinhSang()` và `_generateKinhToi()`.

### Thay Đổi Giao Diện
Chỉnh sửa file `lib/main.dart` để thay đổi theme và màu sắc.

## Công Nghệ Sử Dụng

- **Flutter**: Framework phát triển ứng dụng đa nền tảng
- **Dart**: Ngôn ngữ lập trình
- **Material Design**: Thiết kế giao diện

## Lưu Ý

- Ứng dụng hoàn toàn chạy trên frontend, không cần backend
- Dữ liệu được lưu trữ tĩnh trong code
- Phù hợp cho việc học tập và thực hành Phật pháp hàng ngày

## Hỗ Trợ

Nếu gặp vấn đề, vui lòng kiểm tra:
1. Flutter version: `flutter --version`
2. Dependencies: `flutter pub get`
3. Device connection: `flutter devices`

---

**Chúc bạn có những giây phút an lạc với ứng dụng đọc kinh! 🙏**