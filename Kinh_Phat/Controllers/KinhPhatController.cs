using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Kinh_Phat.Data;
using Kinh_Phat.Models;

namespace Kinh_Phat.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KinhPhatController : ControllerBase
    {
        private readonly KinhPhatDbContext _context;

        public KinhPhatController(KinhPhatDbContext context)
        {
            _context = context;
        }

        // GET: api/KinhPhat
        [HttpGet]
        public async Task<ActionResult<IEnumerable<KinhPhat>>> GetKinhPhats()
        {
            try
            {
                return await _context.KinhPhats
                    .OrderBy(k => k.ThoiGian)
                    .ThenBy(k => k.Ngay)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi lấy danh sách kinh phật", error = ex.Message });
            }
        }

        // GET: api/KinhPhat/sang
        [HttpGet("sang")]
        public async Task<ActionResult<IEnumerable<KinhPhat>>> GetKinhSang()
        {
            try
            {
                return await _context.KinhPhats
                    .Where(k => k.ThoiGian == "sang")
                    .OrderBy(k => k.Ngay)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi lấy danh sách kinh sáng", error = ex.Message });
            }
        }

        // GET: api/KinhPhat/toi
        [HttpGet("toi")]
        public async Task<ActionResult<IEnumerable<KinhPhat>>> GetKinhToi()
        {
            try
            {
                return await _context.KinhPhats
                    .Where(k => k.ThoiGian == "toi")
                    .OrderBy(k => k.Ngay)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi lấy danh sách kinh tối", error = ex.Message });
            }
        }

        // GET: api/KinhPhat/5
        [HttpGet("{id}")]
        public async Task<ActionResult<KinhPhat>> GetKinhPhat(string id)
        {
            try
            {
                var kinhPhat = await _context.KinhPhats.FindAsync(id);

                if (kinhPhat == null)
                {
                    return NotFound(new { message = "Không tìm thấy kinh phật với ID: " + id });
                }

                return kinhPhat;
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi lấy kinh phật", error = ex.Message });
            }
        }

        // GET: api/KinhPhat/by-date?date=2024-01-01&thoiGian=sang
        [HttpGet("by-date")]
        public async Task<ActionResult<KinhPhat>> GetKinhPhatByDate(DateTime date, string thoiGian)
        {
            try
            {
                var kinhPhat = await _context.KinhPhats
                    .Where(k => k.ThoiGian == thoiGian && 
                               k.Ngay.Date == date.Date)
                    .FirstOrDefaultAsync();

                if (kinhPhat == null)
                {
                    // Nếu không tìm thấy kinh theo ngày cụ thể, trả về kinh gần nhất
                    kinhPhat = await _context.KinhPhats
                        .Where(k => k.ThoiGian == thoiGian)
                        .OrderBy(k => Math.Abs((k.Ngay.Date - date.Date).Ticks))
                        .FirstOrDefaultAsync();
                }

                if (kinhPhat == null)
                {
                    return NotFound(new { message = $"Không tìm thấy kinh {thoiGian} cho ngày {date:yyyy-MM-dd}" });
                }

                return kinhPhat;
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi lấy kinh phật theo ngày", error = ex.Message });
            }
        }

        // POST: api/KinhPhat
        [HttpPost]
        public async Task<ActionResult<KinhPhat>> PostKinhPhat(KinhPhat kinhPhat)
        {
            try
            {
                if (string.IsNullOrEmpty(kinhPhat.Id))
                {
                    kinhPhat.Id = Guid.NewGuid().ToString();
                }

                kinhPhat.CreatedAt = DateTime.UtcNow;
                kinhPhat.UpdatedAt = DateTime.UtcNow;

                _context.KinhPhats.Add(kinhPhat);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetKinhPhat", new { id = kinhPhat.Id }, kinhPhat);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi tạo kinh phật", error = ex.Message });
            }
        }

        // PUT: api/KinhPhat/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutKinhPhat(string id, KinhPhat kinhPhat)
        {
            try
            {
                if (id != kinhPhat.Id)
                {
                    return BadRequest(new { message = "ID không khớp" });
                }

                kinhPhat.UpdatedAt = DateTime.UtcNow;

                _context.Entry(kinhPhat).State = EntityState.Modified;

                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!KinhPhatExists(id))
                    {
                        return NotFound(new { message = "Không tìm thấy kinh phật với ID: " + id });
                    }
                    else
                    {
                        throw;
                    }
                }

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi cập nhật kinh phật", error = ex.Message });
            }
        }

        // DELETE: api/KinhPhat/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteKinhPhat(string id)
        {
            try
            {
                var kinhPhat = await _context.KinhPhats.FindAsync(id);
                if (kinhPhat == null)
                {
                    return NotFound(new { message = "Không tìm thấy kinh phật với ID: " + id });
                }

                _context.KinhPhats.Remove(kinhPhat);
                await _context.SaveChangesAsync();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Lỗi khi xóa kinh phật", error = ex.Message });
            }
        }

        private bool KinhPhatExists(string id)
        {
            return _context.KinhPhats.Any(e => e.Id == id);
        }
    }
}

