using Microsoft.AspNetCore.Mvc;
using Kinh_Phat.Services;
using Kinh_Phat.Models;

namespace Kinh_Phat.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {
        private readonly IAdminAuthService _adminAuthService;

        public AdminController(IAdminAuthService adminAuthService)
        {
            _adminAuthService = adminAuthService;
        }

        [HttpPost("login")]
        public async Task<ActionResult<AdminLoginResponse>> Login([FromBody] AdminLoginRequest request)
        {
            try
            {
                var isValid = await _adminAuthService.ValidateAdminAsync(request.Username, request.Password);
                
                if (!isValid)
                {
                    return Unauthorized(new { message = "Tên đăng nhập hoặc mật khẩu không đúng" });
                }

                var admin = await _adminAuthService.GetAdminByUsernameAsync(request.Username);
                if (admin == null)
                {
                    return Unauthorized(new { message = "Tài khoản không tồn tại" });
                }

                await _adminAuthService.UpdateLastLoginAsync(request.Username);

                return Ok(new AdminLoginResponse
                {
                    Success = true,
                    Message = "Đăng nhập thành công",
                    Admin = new AdminInfo
                    {
                        Id = admin.Id,
                        Username = admin.Username,
                        Email = admin.Email,
                        FullName = admin.FullName,
                        Role = admin.Role,
                        LastLoginAt = admin.LastLoginAt
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi server: " + ex.Message });
            }
        }

        [HttpPost("create")]
        public async Task<ActionResult<AdminCreateResponse>> CreateAdmin([FromBody] AdminCreateRequest request)
        {
            try
            {
                var success = await _adminAuthService.CreateAdminAsync(
                    request.Username, 
                    request.Password, 
                    request.Email, 
                    request.FullName, 
                    request.Role ?? "Admin"
                );

                if (!success)
                {
                    return BadRequest(new { message = "Tên đăng nhập đã tồn tại" });
                }

                return Ok(new AdminCreateResponse
                {
                    Success = true,
                    Message = "Tạo tài khoản admin thành công"
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi server: " + ex.Message });
            }
        }

        [HttpGet("test-accounts")]
        public ActionResult<object> GetTestAccounts()
        {
            var testAccounts = new[]
            {
                new { Username = "admin", Password = "admin123", Role = "SuperAdmin", Description = "Tài khoản quản trị viên chính" },
                new { Username = "manager", Password = "manager123", Role = "Admin", Description = "Tài khoản quản lý nội dung" },
                new { Username = "editor", Password = "editor123", Role = "Editor", Description = "Tài khoản biên tập viên" },
                new { Username = "testadmin", Password = "test123", Role = "Admin", Description = "Tài khoản test admin" },
                new { Username = "developer", Password = "dev2024", Role = "SuperAdmin", Description = "Tài khoản developer" }
            };

            return Ok(new
            {
                Message = "Danh sách tài khoản test admin",
                Accounts = testAccounts,
                Note = "Chỉ sử dụng cho mục đích test và phát triển"
            });
        }
    }

    // DTOs
    public class AdminLoginRequest
    {
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }

    public class AdminLoginResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public AdminInfo? Admin { get; set; }
    }

    public class AdminCreateRequest
    {
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string? Role { get; set; }
    }

    public class AdminCreateResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
    }

    public class AdminInfo
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public DateTime? LastLoginAt { get; set; }
    }
}
