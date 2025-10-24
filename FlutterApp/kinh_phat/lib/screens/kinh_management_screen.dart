import 'package:flutter/material.dart';
import '../models/kinh_phat.dart';
import '../data/kinh_data.dart';
import '../services/api_service.dart';
import 'import_guide_screen.dart';

class KinhManagementScreen extends StatefulWidget {
  const KinhManagementScreen({super.key});

  @override
  State<KinhManagementScreen> createState() => _KinhManagementScreenState();
}

class _KinhManagementScreenState extends State<KinhManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _noiDungController = TextEditingController();
  final _ghiChuController = TextEditingController();
  
  String _thoiGian = 'sang';
  DateTime _selectedDate = DateTime.now();
  
  List<KinhPhat> _kinhSang = [];
  List<KinhPhat> _kinhToi = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKinh();
  }

  Future<void> _loadKinh() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load từ API
      _kinhSang = await ApiService.getKinhSang();
      _kinhToi = await ApiService.getKinhToi();
    } catch (e) {
      // Fallback về mock data nếu API lỗi
      KinhData.initializeData();
      _kinhSang = KinhData.getKinhSang();
      _kinhToi = KinhData.getKinhToi();
      print('Lỗi khi load dữ liệu từ API: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text(
          'Quản Lý Kinh Phật',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImportGuideScreen(),
                ),
              );
            },
            icon: const Icon(Icons.help_outline, color: Colors.white),
            tooltip: 'Hướng dẫn thêm kinh từ PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form thêm kinh mới
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thêm Kinh Mới',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Tên kinh
                      TextFormField(
                        controller: _tenController,
                        decoration: const InputDecoration(
                          labelText: 'Tên kinh',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.book),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên kinh';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Thời gian
                      DropdownButtonFormField<String>(
                        initialValue: _thoiGian,
                        decoration: const InputDecoration(
                          labelText: 'Thời gian',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'sang',
                            child: Row(
                              children: [
                                Icon(Icons.wb_sunny, color: Colors.amber),
                                SizedBox(width: 8),
                                Text('Kinh Sáng'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'toi',
                            child: Row(
                              children: [
                                Icon(Icons.nightlight_round, color: Colors.indigo),
                                SizedBox(width: 8),
                                Text('Kinh Tối'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _thoiGian = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Ngày
                      InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Ngày',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Nội dung kinh
                      TextFormField(
                        controller: _noiDungController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          labelText: 'Nội dung kinh',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập nội dung kinh';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Ghi chú
                      TextFormField(
                        controller: _ghiChuController,
                        decoration: const InputDecoration(
                          labelText: 'Ghi chú (tùy chọn)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Nút thêm
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _addKinh,
                          icon: _isLoading 
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.add),
                          label: Text(_isLoading ? 'Đang thêm...' : 'Thêm Kinh'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
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
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Danh sách kinh hiện có
            const Text(
              'Kinh Hiện Có',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            
            // Tab để xem kinh sáng và tối
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Color(0xFF8B4513),
                    labelColor: Color(0xFF8B4513),
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.wb_sunny),
                        text: 'Kinh Sáng',
                      ),
                      Tab(
                        icon: Icon(Icons.nightlight_round),
                        text: 'Kinh Tối',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        _buildKinhList(_kinhSang),
                        _buildKinhList(_kinhToi),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKinhList(List<KinhPhat> kinhList) {
    if (kinhList.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có kinh nào',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: kinhList.length,
      itemBuilder: (context, index) {
        final kinh = kinhList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: kinh.thoiGian == 'sang' 
                  ? Colors.amber[100] 
                  : Colors.indigo[100],
              child: Icon(
                kinh.thoiGian == 'sang' 
                    ? Icons.wb_sunny 
                    : Icons.nightlight_round,
                color: kinh.thoiGian == 'sang' 
                    ? Colors.amber[700] 
                    : Colors.indigo[700],
              ),
            ),
            title: Text(
              kinh.ten,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${kinh.ngay.day}/${kinh.ngay.month}/${kinh.ngay.year}'),
                Text(
                  kinh.noiDung.length > 100 
                      ? '${kinh.noiDung.substring(0, 100)}...'
                      : kinh.noiDung,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () => _deleteKinh(kinh),
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Xóa kinh',
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addKinh() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final kinh = KinhPhat(
          id: '${_thoiGian}_${DateTime.now().millisecondsSinceEpoch}',
          ten: _tenController.text,
          noiDung: _noiDungController.text,
          thoiGian: _thoiGian,
          ngay: _selectedDate,
          ghiChu: _ghiChuController.text,
        );

        // Thêm vào API
        await ApiService.addKinhPhat(kinh);
        
        // Reload dữ liệu
        await _loadKinh();

        // Xóa form
        _tenController.clear();
        _noiDungController.clear();
        _ghiChuController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã thêm kinh "${kinh.ten}" thành công'),
              backgroundColor: Colors.green[600],
            ),
          );
        }
      } catch (e) {
        // Fallback về local data nếu API lỗi
        final kinh = KinhPhat(
          id: '${_thoiGian}_${DateTime.now().millisecondsSinceEpoch}',
          ten: _tenController.text,
          noiDung: _noiDungController.text,
          thoiGian: _thoiGian,
          ngay: _selectedDate,
          ghiChu: _ghiChuController.text,
        );

        KinhData.addKinh(kinh);
        await _loadKinh();

        // Xóa form
        _tenController.clear();
        _noiDungController.clear();
        _ghiChuController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã thêm kinh "${kinh.ten}" thành công (offline)'),
              backgroundColor: Colors.orange[600],
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
  }

  Future<void> _deleteKinh(KinhPhat kinh) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa kinh "${kinh.ten}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              setState(() {
                _isLoading = true;
              });

              try {
                // Xóa từ API
                await ApiService.deleteKinhPhat(kinh.id);
                
                // Reload dữ liệu
                await _loadKinh();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa kinh "${kinh.ten}"'),
                      backgroundColor: Colors.red[600],
                    ),
                  );
                }
              } catch (e) {
                // Fallback về local data nếu API lỗi
                KinhData.removeKinh(kinh);
                await _loadKinh();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa kinh "${kinh.ten}" (offline)'),
                      backgroundColor: Colors.orange[600],
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
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
