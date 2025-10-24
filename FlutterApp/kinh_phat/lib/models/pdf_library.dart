class PdfLibrary {
  final int id;
  final String title;
  final String description;
  final String fileName;
  final String filePath;
  final int fileSize;
  final String category;
  final String author;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final int downloadCount;

  PdfLibrary({
    required this.id,
    required this.title,
    required this.description,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.category,
    required this.author,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.downloadCount,
  });

  factory PdfLibrary.fromJson(Map<String, dynamic> json) {
    return PdfLibrary(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileSize: json['fileSize'],
      category: json['category'],
      author: json['author'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      downloadCount: json['downloadCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fileName': fileName,
      'filePath': filePath,
      'fileSize': fileSize,
      'category': category,
      'author': author,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'downloadCount': downloadCount,
    };
  }

  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get downloadUrl {
    return 'http://192.168.1.11:5275/api/PdfLibrary/download/$id';
  }
}
