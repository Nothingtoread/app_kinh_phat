import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/pdf_library.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/debug_logger.dart';
import 'pdf_viewer_screen.dart';

class PdfLibraryScreen extends StatefulWidget {
  const PdfLibraryScreen({super.key});

  @override
  State<PdfLibraryScreen> createState() => _PdfLibraryScreenState();
}

class _PdfLibraryScreenState extends State<PdfLibraryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  
  List<PdfLibrary> _allPdfs = [];
  List<PdfLibrary> _kinhSangPdfs = [];
  List<PdfLibrary> _kinhToiPdfs = [];
  List<PdfLibrary> _kinhChungPdfs = [];
  
  bool _isLoading = false;
  String _selectedCategory = 'Tất cả';

  final List<String> _categories = [
    'Tất cả',
    'Kinh Sáng',
    'Kinh Tối',
    'Kinh Chung',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPdfLibraries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPdfLibraries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DebugLogger.info('Loading PDF libraries...');
      _allPdfs = await ApiService.getAllPdfLibraries();
      
      _kinhSangPdfs = _allPdfs.where((pdf) => pdf.category == 'Kinh Sáng').toList();
      _kinhToiPdfs = _allPdfs.where((pdf) => pdf.category == 'Kinh Tối').toList();
      _kinhChungPdfs = _allPdfs.where((pdf) => pdf.category == 'Kinh Chung').toList();
      
      DebugLogger.info('PDF libraries loaded successfully', data: {
        'total': _allPdfs.length,
        'kinhSang': _kinhSangPdfs.length,
        'kinhToi': _kinhToiPdfs.length,
        'kinhChung': _kinhChungPdfs.length,
      });
    } catch (e, stackTrace) {
      DebugLogger.error('Failed to load PDF libraries', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải thư viện PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadPdf() async {
    if (!_authService.isAdmin()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chỉ admin mới có thể upload PDF'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        
        if (bytes != null) {
          // Show upload dialog
          final uploadResult = await _showUploadDialog(file.name, bytes);
          if (uploadResult != null) {
            await _loadPdfLibraries(); // Reload after upload
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Không thể đọc file PDF'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      DebugLogger.error('Failed to upload PDF', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi upload PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<PdfLibrary?> _showUploadDialog(String fileName, List<int> bytes) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final authorController = TextEditingController();
    String selectedCategory = 'Kinh Chung';

    return showDialog<PdfLibrary>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload PDF'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Tác giả',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: ['Kinh Sáng', 'Kinh Tối', 'Kinh Chung']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập tiêu đề')),
                );
                return;
              }

              try {
                final pdfLibrary = await ApiService.uploadPdf(
                  title: titleController.text,
                  description: descriptionController.text,
                  category: selectedCategory,
                  author: authorController.text,
                  createdBy: _authService.getCurrentUserInfo()['username'] ?? 'admin',
                  fileBytes: bytes,
                  fileName: fileName,
                );

                Navigator.pop(context, pdfLibrary);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Upload PDF thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi upload: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePdf(PdfLibrary pdfLibrary) async {
    if (!_authService.isAdmin()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chỉ admin mới có thể xóa PDF'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${pdfLibrary.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ApiService.deletePdfLibrary(pdfLibrary.id);
        await _loadPdfLibraries();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa PDF thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xóa PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _viewPdf(PdfLibrary pdfLibrary) async {
    try {
      DebugLogger.info('Downloading PDF for viewing', data: {
        'id': pdfLibrary.id,
        'title': pdfLibrary.title,
      });

      final bytes = await ApiService.downloadPdf(pdfLibrary.id);
      
      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${pdfLibrary.fileName}');
      await file.writeAsBytes(bytes);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(
              file: file,
              title: pdfLibrary.title,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      DebugLogger.error('Failed to view PDF', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi mở PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text(
          'Thư Viện PDF',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        actions: [
          if (_authService.isAdmin())
            IconButton(
              onPressed: _uploadPdf,
              icon: const Icon(Icons.upload_file, color: Colors.white),
              tooltip: 'Upload PDF',
            ),
          IconButton(
            onPressed: _loadPdfLibraries,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Làm mới',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.wb_sunny, size: 24),
              text: 'Kinh Sáng',
            ),
            Tab(
              icon: Icon(Icons.nightlight_round, size: 24),
              text: 'Kinh Tối',
            ),
            Tab(
              icon: Icon(Icons.library_books, size: 24),
              text: 'Kinh Chung',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPdfList(_kinhSangPdfs),
                _buildPdfList(_kinhToiPdfs),
                _buildPdfList(_kinhChungPdfs),
              ],
            ),
    );
  }

  Widget _buildPdfList(List<PdfLibrary> pdfs) {
    if (pdfs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có PDF nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _authService.isAdmin() 
                  ? 'Nhấn nút upload để thêm PDF'
                  : 'Admin sẽ thêm PDF vào đây',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pdfs.length,
      itemBuilder: (context, index) {
        final pdf = pdfs[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _viewPdf(pdf),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red[700],
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pdf.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (pdf.author.isNotEmpty)
                              Text(
                                'Tác giả: ${pdf.author}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            Text(
                              'Kích thước: ${pdf.fileSizeFormatted}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_authService.isAdmin())
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deletePdf(pdf);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Xóa', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (pdf.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      pdf.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF34495E),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lượt tải: ${pdf.downloadCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        'Nhấn để xem',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
