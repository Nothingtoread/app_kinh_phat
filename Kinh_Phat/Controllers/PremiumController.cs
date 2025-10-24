using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Kinh_Phat.Data;
using Kinh_Phat.Models;
using System.Text.Json;

namespace Kinh_Phat.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PremiumController : ControllerBase
    {
        private readonly KinhPhatDbContext _context;

        public PremiumController(KinhPhatDbContext context)
        {
            _context = context;
        }

        // GET: api/Premium/status/{deviceId}
        [HttpGet("status/{deviceId}")]
        public async Task<ActionResult<object>> GetPremiumStatus(string deviceId)
        {
            try
            {
                var device = await _context.PremiumDevices
                    .FirstOrDefaultAsync(d => d.DeviceId == deviceId);

                if (device == null)
                {
                    return Ok(new { isPremium = false, message = "Device chưa được đăng ký" });
                }

                // Kiểm tra xem premium có còn hiệu lực không
                var isActive = device.IsActive && 
                              device.ExpiresAt > DateTime.UtcNow;

                return Ok(new { 
                    isPremium = isActive, 
                    expiresAt = device.ExpiresAt,
                    purchaseDate = device.PurchaseDate,
                    deviceId = device.DeviceId
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi kiểm tra premium status", error = ex.Message });
            }
        }

        // POST: api/Premium/validate
        [HttpPost("validate")]
        public async Task<ActionResult<object>> ValidatePurchase([FromBody] PurchaseValidationRequest request)
        {
            try
            {
                // Validate receipt với Google Play/App Store
                var isValidReceipt = await ValidateReceiptWithStore(request);
                
                if (!isValidReceipt)
                {
                    return BadRequest(new { isValid = false, message = "Receipt không hợp lệ" });
                }

                // Tìm hoặc tạo device record
                var device = await _context.PremiumDevices
                    .FirstOrDefaultAsync(d => d.DeviceId == request.DeviceId);

                if (device == null)
                {
                    // Tạo device mới
                    device = new PremiumDevice
                    {
                        DeviceId = request.DeviceId,
                        DeviceFingerprint = request.DeviceFingerprint,
                        Platform = request.Platform,
                        ProductId = request.ProductId,
                        Receipt = request.LocalReceipt,
                        ServerReceipt = request.ServerReceipt,
                        IsActive = true,
                        PurchaseDate = DateTime.UtcNow,
                        ExpiresAt = DateTime.UtcNow.AddMonths(1), // Premium 1 tháng
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };

                    _context.PremiumDevices.Add(device);
                }
                else
                {
                    // Cập nhật device hiện có
                    device.Receipt = request.LocalReceipt;
                    device.ServerReceipt = request.ServerReceipt;
                    device.IsActive = true;
                    device.PurchaseDate = DateTime.UtcNow;
                    device.ExpiresAt = DateTime.UtcNow.AddMonths(1);
                    device.UpdatedAt = DateTime.UtcNow;
                }

                await _context.SaveChangesAsync();

                return Ok(new { 
                    isValid = true, 
                    message = "Purchase validated successfully",
                    expiresAt = device.ExpiresAt
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi validate purchase", error = ex.Message });
            }
        }

        // POST: api/Premium/register-device
        [HttpPost("register-device")]
        public async Task<ActionResult<object>> RegisterDevice([FromBody] DeviceRegistrationRequest request)
        {
            try
            {
                var device = await _context.PremiumDevices
                    .FirstOrDefaultAsync(d => d.DeviceId == request.DeviceId);

                if (device == null)
                {
                    device = new PremiumDevice
                    {
                        DeviceId = request.DeviceId,
                        DeviceFingerprint = request.DeviceFingerprint,
                        Platform = request.Platform,
                        IsActive = false,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };

                    _context.PremiumDevices.Add(device);
                    await _context.SaveChangesAsync();

                    return Ok(new { 
                        message = "Device registered successfully",
                        deviceId = device.DeviceId
                    });
                }

                return Ok(new { 
                    message = "Device already registered",
                    deviceId = device.DeviceId,
                    isPremium = device.IsActive && device.ExpiresAt > DateTime.UtcNow
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi register device", error = ex.Message });
            }
        }

        // Validate receipt với Google Play/App Store
        private async Task<bool> ValidateReceiptWithStore(PurchaseValidationRequest request)
        {
            try
            {
                if (request.Platform == "android")
                {
                    return await ValidateGooglePlayReceipt(request);
                }
                else if (request.Platform == "ios")
                {
                    return await ValidateAppStoreReceipt(request);
                }

                return false;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi validate receipt: {ex.Message}");
                return false;
            }
        }

        // Validate Google Play receipt
        private async Task<bool> ValidateGooglePlayReceipt(PurchaseValidationRequest request)
        {
            try
            {
                // TODO: Implement Google Play receipt validation
                // Sử dụng Google Play Developer API để validate receipt
                // https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/get
                
                // Tạm thời return true cho demo
                // Trong production, cần implement thật
                return !string.IsNullOrEmpty(request.LocalReceipt);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi validate Google Play receipt: {ex.Message}");
                return false;
            }
        }

        // Validate App Store receipt
        private async Task<bool> ValidateAppStoreReceipt(PurchaseValidationRequest request)
        {
            try
            {
                // TODO: Implement App Store receipt validation
                // Sử dụng App Store Server API để validate receipt
                // https://developer.apple.com/documentation/appstoreserverapi
                
                // Tạm thời return true cho demo
                // Trong production, cần implement thật
                return !string.IsNullOrEmpty(request.LocalReceipt);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi validate App Store receipt: {ex.Message}");
                return false;
            }
        }
    }

    // Request models
    public class PurchaseValidationRequest
    {
        public string DeviceId { get; set; } = string.Empty;
        public string DeviceFingerprint { get; set; } = string.Empty;
        public string LocalReceipt { get; set; } = string.Empty;
        public string ServerReceipt { get; set; } = string.Empty;
        public string ProductId { get; set; } = string.Empty;
        public string Platform { get; set; } = string.Empty;
    }

    public class DeviceRegistrationRequest
    {
        public string DeviceId { get; set; } = string.Empty;
        public string DeviceFingerprint { get; set; } = string.Empty;
        public string Platform { get; set; } = string.Empty;
    }
}

