class KinhPhat {
  final String id;
  final String ten;
  final String noiDung;
  final String thoiGian; // "sang" hoặc "toi"
  final DateTime ngay;
  final String ghiChu;

  KinhPhat({
    required this.id,
    required this.ten,
    required this.noiDung,
    required this.thoiGian,
    required this.ngay,
    this.ghiChu = '',
  });

  factory KinhPhat.fromJson(Map<String, dynamic> json) {
    return KinhPhat(
      id: json['id'],
      ten: json['ten'],
      noiDung: json['noiDung'],
      thoiGian: json['thoiGian'],
      ngay: DateTime.parse(json['ngay']),
      ghiChu: json['ghiChu'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'noiDung': noiDung,
      'thoiGian': thoiGian,
      'ngay': ngay.toIso8601String(),
      'ghiChu': ghiChu,
    };
  }
}

