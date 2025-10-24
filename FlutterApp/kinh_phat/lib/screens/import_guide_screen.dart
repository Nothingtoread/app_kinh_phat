import 'package:flutter/material.dart';

class ImportGuideScreen extends StatelessWidget {
  const ImportGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text(
          'Hướng Dẫn Thêm Kinh Từ PDF',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Hướng Dẫn Thêm Kinh Từ PDF',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Để thêm kinh từ file PDF vào ứng dụng, bạn cần làm theo các bước sau:',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF34495E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildStep(
                      '1',
                      'Mở file PDF',
                      'Mở file "kinh-phat-cho-phat-tu-tai-gia-thich-nhat-tu.pdf" trên máy tính của bạn.',
                    ),
                    const SizedBox(height: 16),
                    
                    _buildStep(
                      '2',
                      'Chọn và sao chép nội dung',
                      'Chọn từng đoạn kinh và sao chép (Ctrl+C) vào clipboard. Mỗi đoạn sẽ là một bài kinh cho một ngày.',
                    ),
                    const SizedBox(height: 16),
                    
                    _buildStep(
                      '3',
                      'Mở ứng dụng quản lý kinh',
                      'Trong ứng dụng, nhấn nút ⚙️ (Settings) ở góc phải màn hình chính để mở màn hình quản lý kinh.',
                    ),
                    const SizedBox(height: 16),
                    
                    _buildStep(
                      '4',
                      'Thêm kinh mới',
                      'Nhấn "Thêm Kinh Mới" và điền thông tin:\n'
                      '• Tên kinh: Ví dụ "Kinh Phật cho Phật tử tại gia - Ngày 1"\n'
                      '• Thời gian: Chọn "Kinh Sáng" hoặc "Kinh Tối"\n'
                      '• Ngày: Chọn ngày muốn hiển thị kinh này\n'
                      '• Nội dung: Dán nội dung đã sao chép từ PDF\n'
                      '• Ghi chú: Thêm ghi chú nếu cần',
                    ),
                    const SizedBox(height: 16),
                    
                    _buildStep(
                      '5',
                      'Lưu và kiểm tra',
                      'Nhấn "Thêm Kinh" để lưu. Sau đó quay lại màn hình chính để kiểm tra kinh đã được thêm.',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber[700],
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Gợi Ý Chia Kinh Theo Ngày',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const Text(
                      'Để chia kinh từ PDF thành các ngày khác nhau:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF34495E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildTip('📅', 'Chia theo chương', 'Mỗi chương trong PDF có thể là một ngày khác nhau.'),
                    _buildTip('📖', 'Chia theo độ dài', 'Mỗi đoạn khoảng 200-500 từ phù hợp cho một ngày.'),
                    _buildTip('🕐', 'Phân chia thời gian', 'Có thể chia thành kinh sáng và kinh tối cho cùng một chủ đề.'),
                    _buildTip('📝', 'Thêm ghi chú', 'Ghi chú ngắn về nội dung để dễ nhớ và tìm kiếm.'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_outlined,
                          color: Colors.orange[700],
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Lưu Ý Quan Trọng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const Text(
                      '• Đảm bảo nội dung kinh được sao chép chính xác từ PDF\n'
                      '• Kiểm tra định dạng văn bản sau khi dán\n'
                      '• Có thể chỉnh sửa nội dung trong ứng dụng nếu cần\n'
                      '• Lưu ý về bản quyền và nguồn gốc của kinh\n'
                      '• Nên chia nhỏ để dễ đọc và thực hành hàng ngày',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF34495E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay Lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF34495E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTip(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF34495E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
