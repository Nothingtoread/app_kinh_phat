import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../utils/debug_logger.dart';

class PdfViewerScreen extends StatefulWidget {
  final File file;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.file,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFViewController? _pdfViewController;
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    DebugLogger.info('Opening PDF viewer', data: {
      'title': widget.title,
      'filePath': widget.file.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Lỗi khi mở PDF',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[300],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : PDFView(
                  filePath: widget.file.path,
                  onRender: (pages) {
                    setState(() {
                      _totalPages = pages!;
                      _isLoading = false;
                    });
                    DebugLogger.info('PDF rendered successfully', data: {
                      'totalPages': _totalPages,
                    });
                  },
                  onViewCreated: (PDFViewController controller) {
                    _pdfViewController = controller;
                  },
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      _currentPage = page! + 1;
                    });
                  },
                  onError: (error) {
                    setState(() {
                      _errorMessage = error.toString();
                      _isLoading = false;
                    });
                    DebugLogger.error('PDF view error', error: error);
                  },
                ),
      bottomNavigationBar: _totalPages > 0
          ? Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _currentPage > 1
                        ? () {
                            _pdfViewController?.setPage(_currentPage - 2);
                          }
                        : null,
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    tooltip: 'Trang trước',
                  ),
                  IconButton(
                    onPressed: () {
                      _showPageJumpDialog();
                    },
                    icon: const Icon(Icons.list, color: Colors.white),
                    tooltip: 'Chuyển trang',
                  ),
                  IconButton(
                    onPressed: _currentPage < _totalPages
                        ? () {
                            _pdfViewController?.setPage(_currentPage);
                          }
                        : null,
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    tooltip: 'Trang sau',
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _showPageJumpDialog() {
    final pageController = TextEditingController(text: _currentPage.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chuyển đến trang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nhập số trang (1 - $_totalPages)'),
            const SizedBox(height: 16),
            TextField(
              controller: pageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số trang',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final pageNumber = int.tryParse(pageController.text);
              if (pageNumber != null && 
                  pageNumber >= 1 && 
                  pageNumber <= _totalPages) {
                _pdfViewController?.setPage(pageNumber - 1);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vui lòng nhập số trang từ 1 đến $_totalPages'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Chuyển'),
          ),
        ],
      ),
    );
  }
}
