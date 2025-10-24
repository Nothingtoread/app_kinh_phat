using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Kinh_Phat.Data;
using Kinh_Phat.Models;

namespace Kinh_Phat.Services
{
    public interface IAdminAuthService
    {
        Task<bool> ValidateAdminAsync(string username, string password);
        Task<AdminUser?> GetAdminByUsernameAsync(string username);
        Task<bool> CreateAdminAsync(string username, string password, string email, string fullName, string role = "Admin");
        Task UpdateLastLoginAsync(string username);
    }

    public class AdminAuthService : IAdminAuthService
    {
        private readonly KinhPhatDbContext _context;

        public AdminAuthService(KinhPhatDbContext context)
        {
            _context = context;
        }

        public async Task<bool> ValidateAdminAsync(string username, string password)
        {
            var admin = await _context.AdminUsers
                .FirstOrDefaultAsync(a => a.Username == username && a.IsActive);

            if (admin == null)
                return false;

            var hashedPassword = HashPassword(password);
            return admin.PasswordHash == hashedPassword;
        }

        public async Task<AdminUser?> GetAdminByUsernameAsync(string username)
        {
            return await _context.AdminUsers
                .FirstOrDefaultAsync(a => a.Username == username && a.IsActive);
        }

        public async Task<bool> CreateAdminAsync(string username, string password, string email, string fullName, string role = "Admin")
        {
            // Check if username already exists
            var existingAdmin = await _context.AdminUsers
                .FirstOrDefaultAsync(a => a.Username == username);

            if (existingAdmin != null)
                return false;

            var admin = new AdminUser
            {
                Username = username,
                PasswordHash = HashPassword(password),
                Email = email,
                FullName = fullName,
                Role = role,
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.AdminUsers.Add(admin);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task UpdateLastLoginAsync(string username)
        {
            var admin = await _context.AdminUsers
                .FirstOrDefaultAsync(a => a.Username == username);

            if (admin != null)
            {
                admin.LastLoginAt = DateTime.UtcNow;
                admin.UpdatedAt = DateTime.UtcNow;
                await _context.SaveChangesAsync();
            }
        }

        private string HashPassword(string password)
        {
            using var sha256 = SHA256.Create();
            var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password + "KinhPhatSalt2024"));
            return Convert.ToBase64String(hashedBytes);
        }
    }
}
