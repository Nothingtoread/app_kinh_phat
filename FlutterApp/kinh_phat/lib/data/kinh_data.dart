import '../models/kinh_phat.dart';
import 'kinh_list.dart';

class KinhData {
  static List<KinhPhat> _kinhSang = [];
  static List<KinhPhat> _kinhToi = [];

  static void initializeData() {
    _kinhSang = _generateKinhSang();
    _kinhToi = _generateKinhToi();
  }

  static List<KinhPhat> getKinhSang() => _kinhSang;
  static List<KinhPhat> getKinhToi() => _kinhToi;

  static void addKinh(KinhPhat kinh) {
    if (kinh.thoiGian == 'sang') {
      _kinhSang.add(kinh);
      _kinhSang.sort((a, b) => a.ngay.compareTo(b.ngay));
    } else {
      _kinhToi.add(kinh);
      _kinhToi.sort((a, b) => a.ngay.compareTo(b.ngay));
    }
  }

  static void removeKinh(KinhPhat kinh) {
    if (kinh.thoiGian == 'sang') {
      _kinhSang.remove(kinh);
    } else {
      _kinhToi.remove(kinh);
    }
  }

  static KinhPhat? getKinhByDate(DateTime date, String thoiGian) {
    final kinhList = thoiGian == 'sang' ? _kinhSang : _kinhToi;
    
    // Tìm kinh theo ngày (chỉ so sánh ngày, không so sánh giờ)
    for (var kinh in kinhList) {
      if (kinh.ngay.year == date.year &&
          kinh.ngay.month == date.month &&
          kinh.ngay.day == date.day) {
        return kinh;
      }
    }
    
    // Nếu không tìm thấy, trả về kinh gần nhất
    if (kinhList.isNotEmpty) {
      // Tìm kinh gần nhất với ngày được chọn
      kinhList.sort((a, b) => a.ngay.compareTo(b.ngay));
      return kinhList.first;
    }
    
    return null;
  }

  static List<KinhPhat> getAllKinh() {
    return [..._kinhSang, ..._kinhToi];
  }

  static List<KinhPhat> _generateKinhSang() {
    final now = DateTime.now();
    final allKinh = KinhList.getAllKinh();
    final kinhSang = allKinh.where((k) => k['thoiGian'] == 'sang').toList();
    
    return kinhSang.asMap().entries.map((entry) {
      final index = entry.key;
      final kinhData = entry.value;
      return KinhPhat(
        id: kinhData['id']!,
        ten: kinhData['ten']!,
        noiDung: kinhData['noiDung']!,
        thoiGian: kinhData['thoiGian']!,
        ngay: now.add(Duration(days: index)),
        ghiChu: kinhData['ghiChu']!,
      );
    }).toList();
  }

  static List<KinhPhat> _generateKinhToi() {
    final now = DateTime.now();
    final allKinh = KinhList.getAllKinh();
    final kinhToi = allKinh.where((k) => k['thoiGian'] == 'toi').toList();
    
    return kinhToi.asMap().entries.map((entry) {
      final index = entry.key;
      final kinhData = entry.value;
      return KinhPhat(
        id: kinhData['id']!,
        ten: kinhData['ten']!,
        noiDung: kinhData['noiDung']!,
        thoiGian: kinhData['thoiGian']!,
        ngay: now.add(Duration(days: index)),
        ghiChu: kinhData['ghiChu']!,
      );
    }).toList();
  }
}