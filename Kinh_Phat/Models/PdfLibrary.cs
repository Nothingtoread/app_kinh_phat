using System;
using System.ComponentModel.DataAnnotations;

namespace Kinh_Phat.Models
{
    public class PdfLibrary
    {
        public int Id { get; set; }

        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        [Required]
        [StringLength(500)]
        public string Description { get; set; }

        [Required]
        [StringLength(100)]
        public string FileName { get; set; }

        [Required]
        [StringLength(500)]
        public string FilePath { get; set; }

        public long FileSize { get; set; } // File size in bytes

        [StringLength(50)]
        public string Category { get; set; } // e.g., "Kinh Sáng", "Kinh Tối", "Kinh Chung"

        [StringLength(100)]
        public string Author { get; set; }

        public bool IsActive { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        [StringLength(100)]
        public string CreatedBy { get; set; } // Username of admin who uploaded

        public int DownloadCount { get; set; } // Track how many times downloaded
    }
}
