# Kinh Phật Hàng Ngày

Ứng dụng đọc kinh Phật hàng ngày với tính năng thư viện PDF và quản lý admin.

## 🚀 Tính năng chính

### 📱 Flutter App
- **Trang chủ**: Đọc kinh sáng và kinh tối theo ngày
- **Thư viện PDF**: Xem và quản lý PDF kinh Phật
- **Cài đặt**: Quản lý developer mode và admin login
- **Premium**: Tính năng trả phí để loại bỏ quảng cáo
- **Quảng cáo**: Google Mobile Ads integration

### 🔧 .NET API Backend
- **RESTful API**: CRUD operations cho kinh Phật và PDF
- **Authentication**: Admin login với roles (SuperAdmin, Admin, Editor)
- **File Management**: Upload và download PDF files
- **Database**: SQL Server LocalDB với Entity Framework Core
- **CORS**: Hỗ trợ cross-origin requests

## 🏗️ Kiến trúc hệ thống

```
Kinh_Phat/
├── Kinh_Phat/                 # .NET API Backend
│   ├── Controllers/           # API Controllers
│   ├── Models/               # Data Models
│   ├── Data/                 # Database Context
│   ├── Services/             # Business Logic
│   └── Migrations/           # Database Migrations
├── FlutterApp/kinh_phat/      # Flutter Mobile App
│   ├── lib/
│   │   ├── models/           # Data Models
│   │   ├── screens/          # UI Screens
│   │   ├── services/         # API Services
│   │   ├── utils/            # Utilities
│   │   └── data/             # Mock Data
│   └── android/              # Android Configuration
└── README.md
```

## 🛠️ Công nghệ sử dụng

### Backend (.NET)
- **.NET 10.0** - Framework chính
- **Entity Framework Core** - ORM
- **SQL Server LocalDB** - Database
- **ASP.NET Core Web API** - REST API
- **CORS** - Cross-Origin Resource Sharing

### Frontend (Flutter)
- **Flutter 3.9.2** - Mobile Framework
- **Dart** - Programming Language
- **Google Mobile Ads** - Advertisement
- **HTTP** - API Communication
- **Shared Preferences** - Local Storage
- **File Picker** - File Selection
- **PDF Viewer** - PDF Display

## 📋 Yêu cầu hệ thống

### Backend
- .NET 10.0 SDK
- SQL Server LocalDB
- Visual Studio 2022 hoặc VS Code

### Frontend
- Flutter SDK 3.9.2+
- Android Studio hoặc VS Code
- Android SDK (cho Android development)

## 🚀 Hướng dẫn cài đặt

### 1. Clone Repository
```bash
git clone https://github.com/Nothingtoread/app_kinh_phat.git
cd app_kinh_phat
```

### 2. Backend Setup
```bash
cd Kinh_Phat
dotnet restore
dotnet ef database update
dotnet run --urls "http://localhost:5275"
```

### 3. Frontend Setup
```bash
cd FlutterApp/kinh_phat
flutter pub get
flutter run
```

## 🔐 Admin Accounts

Hệ thống có sẵn các tài khoản admin test:

| Username | Password | Role | Mô tả |
|----------|----------|------|-------|
| admin | admin123 | SuperAdmin | Full access |
| manager | manager123 | Admin | Manage content |
| editor | editor123 | Editor | Create/edit content |
| testadmin | test123 | Admin | General test |
| developer | dev2024 | SuperAdmin | Developer account |

## 📱 Tính năng chi tiết

### Guest Users
- Đọc kinh sáng/tối theo ngày
- Xem thư viện PDF
- Mua premium để loại bỏ quảng cáo
- Sử dụng ứng dụng offline với mock data

### Admin Users
- Tất cả tính năng của Guest
- Upload PDF files
- Quản lý nội dung kinh
- Xóa PDF files
- Developer mode controls

### Premium Features
- Loại bỏ banner ads
- Loại bỏ interstitial ads
- Device-based authentication
- Receipt validation

## 🔧 API Endpoints

### Kinh Phật
- `GET /api/KinhPhat` - Lấy tất cả kinh
- `GET /api/KinhPhat/sang` - Lấy kinh sáng
- `GET /api/KinhPhat/toi` - Lấy kinh tối
- `GET /api/KinhPhat/{id}` - Lấy kinh theo ID
- `POST /api/KinhPhat` - Thêm kinh mới
- `PUT /api/KinhPhat/{id}` - Cập nhật kinh
- `DELETE /api/KinhPhat/{id}` - Xóa kinh

### PDF Library
- `GET /api/PdfLibrary` - Lấy tất cả PDF
- `GET /api/PdfLibrary/{id}` - Lấy PDF theo ID
- `GET /api/PdfLibrary/category/{category}` - Lấy PDF theo category
- `GET /api/PdfLibrary/download/{id}` - Download PDF
- `POST /api/PdfLibrary` - Upload PDF
- `PUT /api/PdfLibrary/{id}` - Cập nhật PDF
- `DELETE /api/PdfLibrary/{id}` - Xóa PDF

### Admin
- `POST /api/Admin/login` - Admin login
- `POST /api/Admin/create` - Tạo admin mới
- `GET /api/Admin/test-accounts` - Lấy danh sách test accounts

### Premium
- `GET /api/Premium/status/{deviceId}` - Kiểm tra premium status
- `POST /api/Premium/validate` - Validate purchase
- `POST /api/Premium/register-device` - Register device

## 🐛 Debug & Logging

Ứng dụng có hệ thống debug logging toàn diện:
- System information logging
- Network request/response logging
- API call logging
- Authentication event logging
- Error logging với stack trace
- Performance monitoring

## 📄 License

MIT License - Xem file LICENSE để biết thêm chi tiết.

## 🤝 Contributing

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📞 Support

Nếu gặp vấn đề, vui lòng tạo issue trên GitHub repository.

---

**Phát triển bởi**: Nothingtoread  
**Repository**: [https://github.com/Nothingtoread/app_kinh_phat](https://github.com/Nothingtoread/app_kinh_phat)
