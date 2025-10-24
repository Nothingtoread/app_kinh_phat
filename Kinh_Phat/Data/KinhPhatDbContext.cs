using Microsoft.EntityFrameworkCore;
using Kinh_Phat.Models;

namespace Kinh_Phat.Data
{
    public class KinhPhatDbContext : DbContext
    {
        public KinhPhatDbContext(DbContextOptions<KinhPhatDbContext> options) : base(options)
        {
        }

        public DbSet<KinhPhat> KinhPhats { get; set; }
        public DbSet<PremiumDevice> PremiumDevices { get; set; }
        public DbSet<AdminUser> AdminUsers { get; set; }
        public DbSet<PdfLibrary> PdfLibraries { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Cấu hình index cho ThoiGian và Ngay để tối ưu hóa truy vấn
            modelBuilder.Entity<KinhPhat>()
                .HasIndex(k => new { k.ThoiGian, k.Ngay })
                .HasDatabaseName("IX_KinhPhat_ThoiGian_Ngay");

            // Cấu hình index cho Ngay để tối ưu hóa tìm kiếm theo ngày
            modelBuilder.Entity<KinhPhat>()
                .HasIndex(k => k.Ngay)
                .HasDatabaseName("IX_KinhPhat_Ngay");

            // Cấu hình index cho PremiumDevice
            modelBuilder.Entity<PremiumDevice>()
                .HasIndex(d => d.DeviceId)
                .HasDatabaseName("IX_PremiumDevice_DeviceId")
                .IsUnique();

            modelBuilder.Entity<PremiumDevice>()
                .HasIndex(d => d.DeviceFingerprint)
                .HasDatabaseName("IX_PremiumDevice_DeviceFingerprint");

            // Cấu hình index cho AdminUser
            modelBuilder.Entity<AdminUser>()
                .HasIndex(a => a.Username)
                .HasDatabaseName("IX_AdminUser_Username")
                .IsUnique();

            modelBuilder.Entity<AdminUser>()
                .HasIndex(a => a.Email)
                .HasDatabaseName("IX_AdminUser_Email")
                .IsUnique();

            // Cấu hình index cho PdfLibrary
            modelBuilder.Entity<PdfLibrary>()
                .HasIndex(p => p.Category)
                .HasDatabaseName("IX_PdfLibrary_Category");

            modelBuilder.Entity<PdfLibrary>()
                .HasIndex(p => p.IsActive)
                .HasDatabaseName("IX_PdfLibrary_IsActive");

            // Seed data - thêm dữ liệu mẫu
            SeedData(modelBuilder);
        }

        private void SeedData(ModelBuilder modelBuilder)
        {
            // Sử dụng ngày cố định để tránh lỗi migration
            var baseDate = new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            
            // Kinh sáng
            var kinhSang = new[]
            {
                new KinhPhat { Id = "sang_1", Ten = "Kinh Từ Bi (Metta Sutta)", NoiDung = "Kinh Từ Bi là một trong những bài kinh quan trọng nhất trong Phật giáo, dạy về tình thương yêu vô điều kiện...", ThoiGian = "sang", Ngay = baseDate.AddDays(0), GhiChu = "Kinh sáng - Tình thương yêu vô điều kiện", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_2", Ten = "Kinh Quán Niệm Hơi Thở (Anapanasati Sutta)", NoiDung = "Kinh Quán Niệm Hơi Thở hướng dẫn thiền định qua việc quan sát hơi thở...", ThoiGian = "sang", Ngay = baseDate.AddDays(1), GhiChu = "Kinh sáng - Thiền định qua hơi thở", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_3", Ten = "Kinh Bốn Niệm Xứ (Satipatthana Sutta)", NoiDung = "Kinh Bốn Niệm Xứ là nền tảng của thiền quán trong Phật giáo...", ThoiGian = "sang", Ngay = baseDate.AddDays(2), GhiChu = "Kinh sáng - Nền tảng thiền quán", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_4", Ten = "Kinh Pháp Cú (Dhammapada)", NoiDung = "Kinh Pháp Cú là tập hợp những câu kệ ngắn gọn về đạo đức và trí tuệ...", ThoiGian = "sang", Ngay = baseDate.AddDays(3), GhiChu = "Kinh sáng - Câu kệ về đạo đức", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_5", Ten = "Kinh Tứ Thập Nhị Chương", NoiDung = "Kinh Tứ Thập Nhị Chương là một trong những kinh đầu tiên được dịch sang tiếng Trung...", ThoiGian = "sang", Ngay = baseDate.AddDays(4), GhiChu = "Kinh sáng - 42 chương giáo lý cơ bản", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_6", Ten = "Kinh Bát Đại Nhân Giác", NoiDung = "Kinh Bát Đại Nhân Giác trình bày tám điều giác ngộ của bậc đại nhân...", ThoiGian = "sang", Ngay = baseDate.AddDays(5), GhiChu = "Kinh sáng - Tám điều giác ngộ", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_7", Ten = "Kinh Di Giáo", NoiDung = "Kinh Di Giáo là lời dạy cuối cùng của Đức Phật trước khi nhập Niết Bàn...", ThoiGian = "sang", Ngay = baseDate.AddDays(6), GhiChu = "Kinh sáng - Lời dạy cuối cùng", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_8", Ten = "Kinh Thập Thiện Nghiệp Đạo", NoiDung = "Kinh Thập Thiện Nghiệp Đạo giảng về mười nghiệp lành cần tu tập...", ThoiGian = "sang", Ngay = baseDate.AddDays(7), GhiChu = "Kinh sáng - Mười nghiệp lành", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_9", Ten = "Kinh Vu Lan Bồn", NoiDung = "Kinh Vu Lan Bồn nói về lòng hiếu thảo và cách báo hiếu cha mẹ...", ThoiGian = "sang", Ngay = baseDate.AddDays(8), GhiChu = "Kinh sáng - Lòng hiếu thảo", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "sang_10", Ten = "Kinh Báo Hiếu Công Ơn Cha Mẹ", NoiDung = "Kinh Báo Hiếu Công Ơn Cha Mẹ nhấn mạnh công ơn sinh thành và dưỡng dục...", ThoiGian = "sang", Ngay = baseDate.AddDays(9), GhiChu = "Kinh sáng - Công ơn cha mẹ", CreatedAt = baseDate, UpdatedAt = baseDate }
            };

            // Kinh tối
            var kinhToi = new[]
            {
                new KinhPhat { Id = "toi_1", Ten = "Kinh Tâm Kinh (Heart Sutra)", NoiDung = "Kinh Tâm Kinh là một trong những bài kinh ngắn gọn nhưng sâu sắc nhất trong Phật giáo Đại thừa...", ThoiGian = "toi", Ngay = baseDate.AddDays(0), GhiChu = "Kinh tối - Trí tuệ Bát-nhã", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_2", Ten = "Kinh Kim Cang (Diamond Sutra)", NoiDung = "Kinh Kim Cang nhấn mạnh về tính không và sự giải thoát khỏi chấp trước...", ThoiGian = "toi", Ngay = baseDate.AddDays(1), GhiChu = "Kinh tối - Tính không và giải thoát", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_3", Ten = "Kinh A Di Đà (Amitabha Sutra)", NoiDung = "Kinh A Di Đà mô tả về cõi Tịnh Độ và đức Phật A Di Đà...", ThoiGian = "toi", Ngay = baseDate.AddDays(2), GhiChu = "Kinh tối - Cõi Tịnh Độ", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_4", Ten = "Kinh Phổ Môn", NoiDung = "Kinh Phổ Môn ca ngợi hạnh nguyện cứu khổ của Bồ Tát Quán Thế Âm...", ThoiGian = "toi", Ngay = baseDate.AddDays(3), GhiChu = "Kinh tối - Cứu khổ cứu nạn", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_5", Ten = "Kinh Dược Sư", NoiDung = "Kinh Dược Sư nói về 12 đại nguyện của Phật Dược Sư và công năng chữa bệnh...", ThoiGian = "toi", Ngay = baseDate.AddDays(4), GhiChu = "Kinh tối - Chữa bệnh và cứu độ", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_6", Ten = "Kinh Địa Tạng", NoiDung = "Kinh Địa Tạng nói về hạnh nguyện cứu độ chúng sinh trong địa ngục của Bồ Tát Địa Tạng...", ThoiGian = "toi", Ngay = baseDate.AddDays(5), GhiChu = "Kinh tối - Cứu độ địa ngục", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_7", Ten = "Kinh Pháp Hoa", NoiDung = "Kinh Pháp Hoa giảng về con đường thành Phật và các phương tiện thiện xảo...", ThoiGian = "toi", Ngay = baseDate.AddDays(6), GhiChu = "Kinh tối - Con đường thành Phật", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_8", Ten = "Kinh Lăng Nghiêm", NoiDung = "Kinh Lăng Nghiêm nói về bản tâm thanh tịnh và phương pháp tu tập...", ThoiGian = "toi", Ngay = baseDate.AddDays(7), GhiChu = "Kinh tối - Bản tâm thanh tịnh", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_9", Ten = "Kinh Hoa Nghiêm", NoiDung = "Kinh Hoa Nghiêm mô tả thế giới của chư Phật và con đường Bồ Tát...", ThoiGian = "toi", Ngay = baseDate.AddDays(8), GhiChu = "Kinh tối - Thế giới chư Phật", CreatedAt = baseDate, UpdatedAt = baseDate },
                new KinhPhat { Id = "toi_10", Ten = "Kinh Niết Bàn", NoiDung = "Kinh Niết Bàn nói về giáo lý cuối cùng của Đức Phật trước khi nhập Niết Bàn...", ThoiGian = "toi", Ngay = baseDate.AddDays(9), GhiChu = "Kinh tối - Giáo lý cuối cùng", CreatedAt = baseDate, UpdatedAt = baseDate }
            };

            modelBuilder.Entity<KinhPhat>().HasData(kinhSang.Concat(kinhToi));

            // Seed Admin Users - Test accounts
            var adminUsers = new[]
            {
                new AdminUser 
                { 
                    Id = 1,
                    Username = "admin", 
                    PasswordHash = HashPassword("admin123"), 
                    Email = "admin@kinhphat.com", 
                    FullName = "Administrator", 
                    Role = "SuperAdmin",
                    IsActive = true,
                    CreatedAt = baseDate,
                    UpdatedAt = baseDate
                },
                new AdminUser 
                { 
                    Id = 2,
                    Username = "manager", 
                    PasswordHash = HashPassword("manager123"), 
                    Email = "manager@kinhphat.com", 
                    FullName = "Content Manager", 
                    Role = "Admin",
                    IsActive = true,
                    CreatedAt = baseDate,
                    UpdatedAt = baseDate
                },
                new AdminUser 
                { 
                    Id = 3,
                    Username = "editor", 
                    PasswordHash = HashPassword("editor123"), 
                    Email = "editor@kinhphat.com", 
                    FullName = "Content Editor", 
                    Role = "Editor",
                    IsActive = true,
                    CreatedAt = baseDate,
                    UpdatedAt = baseDate
                },
                new AdminUser 
                { 
                    Id = 4,
                    Username = "testadmin", 
                    PasswordHash = HashPassword("test123"), 
                    Email = "test@kinhphat.com", 
                    FullName = "Test Admin", 
                    Role = "Admin",
                    IsActive = true,
                    CreatedAt = baseDate,
                    UpdatedAt = baseDate
                },
                new AdminUser 
                { 
                    Id = 5,
                    Username = "developer", 
                    PasswordHash = HashPassword("dev2024"), 
                    Email = "dev@kinhphat.com", 
                    FullName = "Developer", 
                    Role = "SuperAdmin",
                    IsActive = true,
                    CreatedAt = baseDate,
                    UpdatedAt = baseDate
                }
            };

            modelBuilder.Entity<AdminUser>().HasData(adminUsers);
        }

        private string HashPassword(string password)
        {
            using var sha256 = System.Security.Cryptography.SHA256.Create();
            var hashedBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password + "KinhPhatSalt2024"));
            return Convert.ToBase64String(hashedBytes);
        }
    }
}
