// Danh sách 50 bài kinh Phật phổ biến
class KinhList {
  static List<Map<String, String>> getAllKinh() {
    return [
      // Kinh sáng (1-25)
      {
        'id': 'sang_1',
        'ten': 'Kinh Từ Bi (Metta Sutta)',
        'noiDung': 'Kinh Từ Bi là một trong những bài kinh quan trọng nhất trong Phật giáo, dạy về tình thương yêu vô điều kiện...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Tình thương yêu vô điều kiện'
      },
      {
        'id': 'sang_2', 
        'ten': 'Kinh Quán Niệm Hơi Thở (Anapanasati Sutta)',
        'noiDung': 'Kinh Quán Niệm Hơi Thở hướng dẫn thiền định qua việc quan sát hơi thở...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Thiền định qua hơi thở'
      },
      {
        'id': 'sang_3',
        'ten': 'Kinh Bốn Niệm Xứ (Satipatthana Sutta)', 
        'noiDung': 'Kinh Bốn Niệm Xứ là nền tảng của thiền quán trong Phật giáo...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Nền tảng thiền quán'
      },
      {
        'id': 'sang_4',
        'ten': 'Kinh Pháp Cú (Dhammapada)',
        'noiDung': 'Kinh Pháp Cú là tập hợp những câu kệ ngắn gọn về đạo đức và trí tuệ...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Câu kệ về đạo đức'
      },
      {
        'id': 'sang_5',
        'ten': 'Kinh Tứ Thập Nhị Chương',
        'noiDung': 'Kinh Tứ Thập Nhị Chương là một trong những kinh đầu tiên được dịch sang tiếng Trung...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - 42 chương giáo lý cơ bản'
      },
      {
        'id': 'sang_6',
        'ten': 'Kinh Bát Đại Nhân Giác',
        'noiDung': 'Kinh Bát Đại Nhân Giác trình bày tám điều giác ngộ của bậc đại nhân...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Tám điều giác ngộ'
      },
      {
        'id': 'sang_7',
        'ten': 'Kinh Di Giáo',
        'noiDung': 'Kinh Di Giáo là lời dạy cuối cùng của Đức Phật trước khi nhập Niết Bàn...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Lời dạy cuối cùng'
      },
      {
        'id': 'sang_8',
        'ten': 'Kinh Thập Thiện Nghiệp Đạo',
        'noiDung': 'Kinh Thập Thiện Nghiệp Đạo giảng về mười nghiệp lành cần tu tập...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Mười nghiệp lành'
      },
      {
        'id': 'sang_9',
        'ten': 'Kinh Vu Lan Bồn',
        'noiDung': 'Kinh Vu Lan Bồn nói về lòng hiếu thảo và cách báo hiếu cha mẹ...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Lòng hiếu thảo'
      },
      {
        'id': 'sang_10',
        'ten': 'Kinh Báo Hiếu Công Ơn Cha Mẹ',
        'noiDung': 'Kinh Báo Hiếu Công Ơn Cha Mẹ nhấn mạnh công ơn sinh thành và dưỡng dục...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Công ơn cha mẹ'
      },
      {
        'id': 'sang_11',
        'ten': 'Kinh Sám Hối Hồng Danh',
        'noiDung': 'Kinh Sám Hối Hồng Danh giúp người tụng sám hối tội lỗi và phát nguyện tu hành...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Sám hối tội lỗi'
      },
      {
        'id': 'sang_12',
        'ten': 'Kinh Tăng Nhất A Hàm',
        'noiDung': 'Kinh Tăng Nhất A Hàm tập hợp các bài kinh ngắn về đạo đức và tu tập...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Đạo đức và tu tập'
      },
      {
        'id': 'sang_13',
        'ten': 'Kinh Trung A Hàm',
        'noiDung': 'Kinh Trung A Hàm tập hợp các bài kinh trung bình về giáo lý Phật giáo...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Giáo lý trung bình'
      },
      {
        'id': 'sang_14',
        'ten': 'Kinh Trường A Hàm',
        'noiDung': 'Kinh Trường A Hàm tập hợp các bài kinh dài về giáo lý và lịch sử Phật giáo...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Giáo lý và lịch sử'
      },
      {
        'id': 'sang_15',
        'ten': 'Kinh Tiểu Bộ',
        'noiDung': 'Kinh Tiểu Bộ tập hợp các bài kinh ngắn và truyện ngụ ngôn...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Truyện ngụ ngôn'
      },
      {
        'id': 'sang_16',
        'ten': 'Kinh Đại Bảo Tích',
        'noiDung': 'Kinh Đại Bảo Tích tập hợp nhiều bài kinh quan trọng...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Tập hợp kinh quan trọng'
      },
      {
        'id': 'sang_17',
        'ten': 'Kinh Đại Thừa Vô Lượng Thọ',
        'noiDung': 'Kinh Đại Thừa Vô Lượng Thọ giới thiệu về cõi Tịnh Độ và Phật A Di Đà...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Cõi Tịnh Độ'
      },
      {
        'id': 'sang_18',
        'ten': 'Kinh Đại Thừa Trang Nghiêm Bảo Vương',
        'noiDung': 'Kinh Đại Thừa Trang Nghiêm Bảo Vương nói về công đức và trang nghiêm của Phật...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Công đức và trang nghiêm'
      },
      {
        'id': 'sang_19',
        'ten': 'Kinh Đại Thừa Vô Lượng Nghĩa',
        'noiDung': 'Kinh Đại Thừa Vô Lượng Nghĩa giảng về ý nghĩa vô lượng của giáo pháp...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Ý nghĩa vô lượng'
      },
      {
        'id': 'sang_20',
        'ten': 'Kinh Đại Thừa Pháp Bảo Ký',
        'noiDung': 'Kinh Đại Thừa Pháp Bảo Ký nói về việc truyền bá và bảo vệ chánh pháp...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Truyền bá chánh pháp'
      },
      {
        'id': 'sang_21',
        'ten': 'Kinh Đại Thừa Pháp Hoa Văn Cú',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Văn Cú giải thích chi tiết về Kinh Pháp Hoa...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Giải thích Pháp Hoa'
      },
      {
        'id': 'sang_22',
        'ten': 'Kinh Đại Thừa Pháp Hoa Huyền Nghĩa',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Huyền Nghĩa giải thích ý nghĩa sâu xa của Kinh Pháp Hoa...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Ý nghĩa sâu xa Pháp Hoa'
      },
      {
        'id': 'sang_23',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Sớ',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Sớ chú giải về Kinh Pháp Hoa...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Chú giải Pháp Hoa'
      },
      {
        'id': 'sang_24',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ giải thích ý nghĩa và chú giải về Kinh Pháp Hoa...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Giải thích và chú giải Pháp Hoa'
      },
      {
        'id': 'sang_25',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao chú giải sâu hơn về Kinh Pháp Hoa...',
        'thoiGian': 'sang',
        'ghiChu': 'Kinh sáng - Chú giải sâu Pháp Hoa'
      },
      
      // Kinh tối (26-50)
      {
        'id': 'toi_1',
        'ten': 'Kinh Tâm Kinh (Heart Sutra)',
        'noiDung': 'Kinh Tâm Kinh là một trong những bài kinh ngắn gọn nhưng sâu sắc nhất trong Phật giáo Đại thừa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Trí tuệ Bát-nhã'
      },
      {
        'id': 'toi_2',
        'ten': 'Kinh Kim Cang (Diamond Sutra)',
        'noiDung': 'Kinh Kim Cang nhấn mạnh về tính không và sự giải thoát khỏi chấp trước...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Tính không và giải thoát'
      },
      {
        'id': 'toi_3',
        'ten': 'Kinh A Di Đà (Amitabha Sutra)',
        'noiDung': 'Kinh A Di Đà mô tả về cõi Tịnh Độ và đức Phật A Di Đà...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Cõi Tịnh Độ'
      },
      {
        'id': 'toi_4',
        'ten': 'Kinh Phổ Môn',
        'noiDung': 'Kinh Phổ Môn ca ngợi hạnh nguyện cứu khổ của Bồ Tát Quán Thế Âm...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Cứu khổ cứu nạn'
      },
      {
        'id': 'toi_5',
        'ten': 'Kinh Dược Sư',
        'noiDung': 'Kinh Dược Sư nói về 12 đại nguyện của Phật Dược Sư và công năng chữa bệnh...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Chữa bệnh và cứu độ'
      },
      {
        'id': 'toi_6',
        'ten': 'Kinh Địa Tạng',
        'noiDung': 'Kinh Địa Tạng nói về hạnh nguyện cứu độ chúng sinh trong địa ngục của Bồ Tát Địa Tạng...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Cứu độ địa ngục'
      },
      {
        'id': 'toi_7',
        'ten': 'Kinh Pháp Hoa',
        'noiDung': 'Kinh Pháp Hoa giảng về con đường thành Phật và các phương tiện thiện xảo...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Con đường thành Phật'
      },
      {
        'id': 'toi_8',
        'ten': 'Kinh Lăng Nghiêm',
        'noiDung': 'Kinh Lăng Nghiêm nói về bản tâm thanh tịnh và phương pháp tu tập...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Bản tâm thanh tịnh'
      },
      {
        'id': 'toi_9',
        'ten': 'Kinh Hoa Nghiêm',
        'noiDung': 'Kinh Hoa Nghiêm mô tả thế giới của chư Phật và con đường Bồ Tát...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Thế giới chư Phật'
      },
      {
        'id': 'toi_10',
        'ten': 'Kinh Niết Bàn',
        'noiDung': 'Kinh Niết Bàn nói về giáo lý cuối cùng của Đức Phật trước khi nhập Niết Bàn...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Giáo lý cuối cùng'
      },
      {
        'id': 'toi_11',
        'ten': 'Kinh Thủ Lăng Nghiêm',
        'noiDung': 'Kinh Thủ Lăng Nghiêm giới thiệu về phương pháp tu tập và bảo vệ chánh pháp...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Bảo vệ chánh pháp'
      },
      {
        'id': 'toi_12',
        'ten': 'Kinh Đại Bát Niết Bàn',
        'noiDung': 'Kinh Đại Bát Niết Bàn nói về bản chất của Niết Bàn và con đường đạt được...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Bản chất Niết Bàn'
      },
      {
        'id': 'toi_13',
        'ten': 'Kinh Đại Thừa Vô Lượng Thọ',
        'noiDung': 'Kinh Đại Thừa Vô Lượng Thọ giới thiệu về cõi Tịnh Độ và Phật A Di Đà...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Cõi Tịnh Độ vô lượng'
      },
      {
        'id': 'toi_14',
        'ten': 'Kinh Đại Thừa Trang Nghiêm Bảo Vương',
        'noiDung': 'Kinh Đại Thừa Trang Nghiêm Bảo Vương nói về công đức và trang nghiêm của Phật...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Công đức trang nghiêm'
      },
      {
        'id': 'toi_15',
        'ten': 'Kinh Đại Thừa Vô Lượng Nghĩa',
        'noiDung': 'Kinh Đại Thừa Vô Lượng Nghĩa giảng về ý nghĩa vô lượng của giáo pháp...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Ý nghĩa vô lượng'
      },
      {
        'id': 'toi_16',
        'ten': 'Kinh Đại Thừa Pháp Bảo Ký',
        'noiDung': 'Kinh Đại Thừa Pháp Bảo Ký nói về việc truyền bá và bảo vệ chánh pháp...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Truyền bá chánh pháp'
      },
      {
        'id': 'toi_17',
        'ten': 'Kinh Đại Thừa Pháp Hoa Văn Cú',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Văn Cú giải thích chi tiết về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Giải thích chi tiết Pháp Hoa'
      },
      {
        'id': 'toi_18',
        'ten': 'Kinh Đại Thừa Pháp Hoa Huyền Nghĩa',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Huyền Nghĩa giải thích ý nghĩa sâu xa của Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Ý nghĩa sâu xa Pháp Hoa'
      },
      {
        'id': 'toi_19',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Sớ',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Sớ chú giải về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Chú giải Pháp Hoa'
      },
      {
        'id': 'toi_20',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ giải thích ý nghĩa và chú giải về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Giải thích và chú giải Pháp Hoa'
      },
      {
        'id': 'toi_21',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao chú giải sâu hơn về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Chú giải sâu Pháp Hoa'
      },
      {
        'id': 'toi_22',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký ghi chép và giải thích về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Ghi chép và giải thích Pháp Hoa'
      },
      {
        'id': 'toi_23',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký Thích',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký Thích giải thích chi tiết về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Giải thích chi tiết Pháp Hoa'
      },
      {
        'id': 'toi_24',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký Thích Lược',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký Thích Lược tóm tắt và giải thích về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Tóm tắt và giải thích Pháp Hoa'
      },
      {
        'id': 'toi_25',
        'ten': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký Thích Lược Ký',
        'noiDung': 'Kinh Đại Thừa Pháp Hoa Kinh Nghĩa Sớ Sao Ký Thích Lược Ký ghi chép và tóm tắt về Kinh Pháp Hoa...',
        'thoiGian': 'toi',
        'ghiChu': 'Kinh tối - Ghi chép và tóm tắt Pháp Hoa'
      },
    ];
  }
}
