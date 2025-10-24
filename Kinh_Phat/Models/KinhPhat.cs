using System.ComponentModel.DataAnnotations;

namespace Kinh_Phat.Models
{
    public class KinhPhat
    {
        [Key]
        public string Id { get; set; } = string.Empty;
        
        [Required]
        [MaxLength(200)]
        public string Ten { get; set; } = string.Empty;
        
        [Required]
        public string NoiDung { get; set; } = string.Empty;
        
        [Required]
        [MaxLength(10)]
        public string ThoiGian { get; set; } = string.Empty; // "sang" hoặc "toi"
        
        [Required]
        public DateTime Ngay { get; set; }
        
        [MaxLength(500)]
        public string GhiChu { get; set; } = string.Empty;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}

