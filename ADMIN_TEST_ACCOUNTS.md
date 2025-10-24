# Test Admin Accounts - Kinh Phật App

## 📋 Danh sách tài khoản Admin Test

Dưới đây là các tài khoản admin đã được tạo sẵn trong database để test:

### 🔑 **Tài khoản SuperAdmin (Quyền cao nhất)**

| Username | Password | Role | Email | Full Name | Mô tả |
|----------|----------|------|-------|-----------|-------|
| `admin` | `admin123` | SuperAdmin | admin@kinhphat.com | Administrator | Tài khoản quản trị viên chính |
| `developer` | `dev2024` | SuperAdmin | dev@kinhphat.com | Developer | Tài khoản developer |

### 👨‍💼 **Tài khoản Admin (Quyền quản lý)**

| Username | Password | Role | Email | Full Name | Mô tả |
|----------|----------|------|-------|-----------|-------|
| `manager` | `manager123` | Admin | manager@kinhphat.com | Content Manager | Tài khoản quản lý nội dung |
| `testadmin` | `test123` | Admin | test@kinhphat.com | Test Admin | Tài khoản test admin |

### ✏️ **Tài khoản Editor (Quyền biên tập)**

| Username | Password | Role | Email | Full Name | Mô tả |
|----------|----------|------|-------|-----------|-------|
| `editor` | `editor123` | Editor | editor@kinhphat.com | Content Editor | Tài khoản biên tập viên |

## 🚀 **Cách sử dụng**

### 1. **Trong Flutter App:**
- Bật Developer Mode trong Settings
- Sử dụng bất kỳ tài khoản nào ở trên để đăng nhập Admin
- Sau khi đăng nhập thành công, bạn sẽ có quyền admin

### 2. **API Endpoints:**

#### **Đăng nhập Admin:**
```http
POST http://localhost:5275/api/Admin/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

#### **Tạo Admin mới:**
```http
POST http://localhost:5275/api/Admin/create
Content-Type: application/json

{
  "username": "newadmin",
  "password": "password123",
  "email": "newadmin@kinhphat.com",
  "fullName": "New Admin",
  "role": "Admin"
}
```

#### **Lấy danh sách test accounts:**
```http
GET http://localhost:5275/api/Admin/test-accounts
```

## 🔒 **Bảo mật**

- Tất cả mật khẩu đều được hash bằng SHA256 với salt
- Salt được sử dụng: `KinhPhatSalt2024`
- Chỉ sử dụng các tài khoản này cho mục đích test và phát triển
- **KHÔNG** sử dụng trong production!

## 📊 **Cấu trúc Database**

Bảng `AdminUsers` bao gồm:
- `Id`: Primary key
- `Username`: Tên đăng nhập (unique)
- `PasswordHash`: Mật khẩu đã hash
- `Email`: Email (unique)
- `FullName`: Tên đầy đủ
- `Role`: Vai trò (SuperAdmin, Admin, Editor)
- `IsActive`: Trạng thái hoạt động
- `CreatedAt`: Ngày tạo
- `UpdatedAt`: Ngày cập nhật
- `LastLoginAt`: Lần đăng nhập cuối

## ⚠️ **Lưu ý quan trọng**

1. **Chỉ dành cho test**: Các tài khoản này chỉ nên sử dụng trong môi trường development
2. **Đổi mật khẩu**: Trước khi deploy production, hãy đổi tất cả mật khẩu
3. **Xóa test accounts**: Xóa các tài khoản test trước khi deploy
4. **Backup**: Luôn backup database trước khi thay đổi

## 🛠️ **Troubleshooting**

Nếu gặp lỗi đăng nhập:
1. Kiểm tra Developer Mode đã được bật chưa
2. Kiểm tra API có đang chạy không (`http://localhost:5275`)
3. Kiểm tra database connection
4. Xem logs trong console để debug

---
*Tạo bởi: AI Assistant - 24/10/2025*
