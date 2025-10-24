using System.ComponentModel.DataAnnotations;

namespace Kinh_Phat.Models
{
    public class PremiumDevice
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        [MaxLength(255)]
        public string DeviceId { get; set; } = string.Empty;
        
        [MaxLength(500)]
        public string DeviceFingerprint { get; set; } = string.Empty;
        
        [MaxLength(50)]
        public string Platform { get; set; } = string.Empty; // "android" hoặc "ios"
        
        [MaxLength(100)]
        public string ProductId { get; set; } = string.Empty;
        
        public string Receipt { get; set; } = string.Empty;
        
        public string ServerReceipt { get; set; } = string.Empty;
        
        public bool IsActive { get; set; } = false;
        
        public DateTime PurchaseDate { get; set; }
        
        public DateTime ExpiresAt { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}

