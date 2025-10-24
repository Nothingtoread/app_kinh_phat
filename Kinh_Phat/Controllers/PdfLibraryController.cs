using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Kinh_Phat.Data;
using Kinh_Phat.Models;
using System.IO;

namespace Kinh_Phat.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PdfLibraryController : ControllerBase
    {
        private readonly KinhPhatDbContext _context;
        private readonly IWebHostEnvironment _environment;

        public PdfLibraryController(KinhPhatDbContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        // GET: api/PdfLibrary
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PdfLibrary>>> GetPdfLibraries()
        {
            return await _context.PdfLibraries
                .Where(p => p.IsActive)
                .OrderByDescending(p => p.CreatedAt)
                .ToListAsync();
        }

        // GET: api/PdfLibrary/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<PdfLibrary>> GetPdfLibrary(int id)
        {
            var pdfLibrary = await _context.PdfLibraries.FindAsync(id);

            if (pdfLibrary == null || !pdfLibrary.IsActive)
            {
                return NotFound();
            }

            return pdfLibrary;
        }

        // GET: api/PdfLibrary/category/{category}
        [HttpGet("category/{category}")]
        public async Task<ActionResult<IEnumerable<PdfLibrary>>> GetPdfLibrariesByCategory(string category)
        {
            return await _context.PdfLibraries
                .Where(p => p.IsActive && p.Category == category)
                .OrderByDescending(p => p.CreatedAt)
                .ToListAsync();
        }

        // GET: api/PdfLibrary/download/{id}
        [HttpGet("download/{id}")]
        public async Task<IActionResult> DownloadPdf(int id)
        {
            var pdfLibrary = await _context.PdfLibraries.FindAsync(id);

            if (pdfLibrary == null || !pdfLibrary.IsActive)
            {
                return NotFound();
            }

            var filePath = Path.Combine(_environment.ContentRootPath, "wwwroot", "pdfs", pdfLibrary.FileName);
            
            if (!System.IO.File.Exists(filePath))
            {
                return NotFound("File not found on server");
            }

            // Increment download count
            pdfLibrary.DownloadCount++;
            await _context.SaveChangesAsync();

            var fileBytes = await System.IO.File.ReadAllBytesAsync(filePath);
            return File(fileBytes, "application/pdf", pdfLibrary.FileName);
        }

        // POST: api/PdfLibrary
        [HttpPost]
        public async Task<ActionResult<PdfLibrary>> PostPdfLibrary([FromForm] PdfLibraryUploadRequest request)
        {
            if (request.File == null || request.File.Length == 0)
            {
                return BadRequest("No file uploaded");
            }

            if (!request.File.ContentType.Equals("application/pdf", StringComparison.OrdinalIgnoreCase))
            {
                return BadRequest("Only PDF files are allowed");
            }

            // Create uploads directory if it doesn't exist
            var uploadsPath = Path.Combine(_environment.ContentRootPath, "wwwroot", "pdfs");
            if (!Directory.Exists(uploadsPath))
            {
                Directory.CreateDirectory(uploadsPath);
            }

            // Generate unique filename
            var fileName = $"{Guid.NewGuid()}_{request.File.FileName}";
            var filePath = Path.Combine(uploadsPath, fileName);

            // Save file
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await request.File.CopyToAsync(stream);
            }

            // Create database record
            var pdfLibrary = new PdfLibrary
            {
                Title = request.Title,
                Description = request.Description,
                FileName = fileName,
                FilePath = filePath,
                FileSize = request.File.Length,
                Category = request.Category,
                Author = request.Author,
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                CreatedBy = request.CreatedBy ?? "Unknown",
                DownloadCount = 0
            };

            _context.PdfLibraries.Add(pdfLibrary);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetPdfLibrary), new { id = pdfLibrary.Id }, pdfLibrary);
        }

        // PUT: api/PdfLibrary/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPdfLibrary(int id, PdfLibraryUpdateRequest request)
        {
            var pdfLibrary = await _context.PdfLibraries.FindAsync(id);

            if (pdfLibrary == null)
            {
                return NotFound();
            }

            pdfLibrary.Title = request.Title;
            pdfLibrary.Description = request.Description;
            pdfLibrary.Category = request.Category;
            pdfLibrary.Author = request.Author;
            pdfLibrary.UpdatedAt = DateTime.UtcNow;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PdfLibraryExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/PdfLibrary/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePdfLibrary(int id)
        {
            var pdfLibrary = await _context.PdfLibraries.FindAsync(id);

            if (pdfLibrary == null)
            {
                return NotFound();
            }

            // Soft delete - just mark as inactive
            pdfLibrary.IsActive = false;
            pdfLibrary.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/PdfLibrary/{id}/permanent
        [HttpDelete("{id}/permanent")]
        public async Task<IActionResult> PermanentDeletePdfLibrary(int id)
        {
            var pdfLibrary = await _context.PdfLibraries.FindAsync(id);

            if (pdfLibrary == null)
            {
                return NotFound();
            }

            // Delete physical file
            var filePath = Path.Combine(_environment.ContentRootPath, "wwwroot", "pdfs", pdfLibrary.FileName);
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }

            // Delete database record
            _context.PdfLibraries.Remove(pdfLibrary);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool PdfLibraryExists(int id)
        {
            return _context.PdfLibraries.Any(e => e.Id == id);
        }
    }

    public class PdfLibraryUploadRequest
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
        public string Author { get; set; }
        public string CreatedBy { get; set; }
        public IFormFile File { get; set; }
    }

    public class PdfLibraryUpdateRequest
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
        public string Author { get; set; }
    }
}
