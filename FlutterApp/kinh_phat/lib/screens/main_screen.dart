import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../data/kinh_data.dart';
import '../models/kinh_phat.dart';
import '../services/api_service.dart';
import '../services/ad_service.dart';
import '../services/auth_service.dart';
import 'kinh_detail_screen.dart';
import 'kinh_management_screen.dart';
import 'premium_screen.dart';
import 'settings_screen.dart';
import 'pdf_library_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  
  final AdService _adService = AdService();
  final AuthService _authService = AuthService();
  BannerAd? _bannerAd;
  bool _isPremiumUser = false;
  bool _isLoading = false;
  List<KinhPhat> _kinhSang = [];
  List<KinhPhat> _kinhToi = [];

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
    _loadBannerAd();
    _authService.initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerAd?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Kiểm tra trạng thái premium
      _isPremiumUser = await _adService.isPremiumUser();
      
      // Load dữ liệu từ API
      _kinhSang = await ApiService.getKinhSang();
      _kinhToi = await ApiService.getKinhToi();
      
      // Fallback về mock data nếu API lỗi
      if (_kinhSang.isEmpty || _kinhToi.isEmpty) {
        KinhData.initializeData();
        _kinhSang = KinhData.getKinhSang();
        _kinhToi = KinhData.getKinhToi();
      }
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

  void _loadBannerAd() {
    if (_isPremiumUser) return;

    _bannerAd = _adService.createBannerAd();
    _bannerAd!.load();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomePage(),
          const PdfLibraryScreen(),
          _buildSettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF8B4513),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          _authService.isAdmin() ? 'Kinh Phật Hàng Ngày (Admin)' : 'Kinh Phật Hàng Ngày',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: _authService.isAdmin() ? Colors.red[700] : const Color(0xFF8B4513),
        elevation: 0,
        actions: [
          // Premium button (chỉ hiển thị cho Guest)
          if (!_isPremiumUser && _authService.isGuest())
            IconButton(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumScreen(),
                  ),
                );
                if (result == true) {
                  // Premium purchased, reload data
                  await _initializeData();
                  _loadBannerAd();
                }
              },
              icon: const Icon(Icons.star, color: Colors.amber),
              tooltip: 'Nâng cấp Premium',
            ),
          // Admin indicator
          if (_authService.isAdmin())
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bạn đang ở chế độ Admin'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
              tooltip: 'Chế độ Admin',
            ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KinhManagementScreen(),
                ),
              ).then((_) {
                // Reload data when returning from management screen
                _initializeData();
              });
            },
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Quản lý kinh',
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
          ],
        ),
      ),
      body: Column(
        children: [
          // Phần chọn ngày
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _authService.isAdmin() ? Colors.red[700] : const Color(0xFF8B4513),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _authService.isAdmin() ? 'Ngày hôm nay (Admin)' : 'Ngày hôm nay',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: const Text(
                    'Chọn ngày',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Banner Ad (chỉ hiển thị nếu không phải premium và là Guest)
          if (!_isPremiumUser && _authService.isGuest() && _bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          
          // Loading indicator
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
                ),
              ),
            )
          else
            // Nội dung tab
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildKinhTab('sang'),
                  _buildKinhTab('toi'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return SettingsScreen(
      onDeveloperModeChanged: () {
        // Reload để cập nhật UI khi thay đổi developer mode
        setState(() {});
      },
      onAdminLoginChanged: () {
        // Reload để cập nhật UI khi admin login/logout
        setState(() {});
      },
    );
  }

  Widget _buildKinhTab(String thoiGian) {
    final kinhList = thoiGian == 'sang' ? _kinhSang : _kinhToi;
    KinhPhat? kinh;
    
    // Tìm kinh theo ngày
    for (var k in kinhList) {
      if (k.ngay.year == _selectedDate.year &&
          k.ngay.month == _selectedDate.month &&
          k.ngay.day == _selectedDate.day) {
        kinh = k;
        break;
      }
    }
    
    // Nếu không tìm thấy, lấy kinh gần nhất
    if (kinh == null && kinhList.isNotEmpty) {
      kinhList.sort((a, b) => a.ngay.compareTo(b.ngay));
      kinh = kinhList.first;
    }
    
    if (kinh == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có kinh cho ngày này',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng chọn ngày khác',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () => _navigateToDetail(kinh!),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: thoiGian == 'sang' 
                            ? Colors.amber[100] 
                            : Colors.indigo[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        thoiGian == 'sang' 
                            ? Icons.wb_sunny 
                            : Icons.nightlight_round,
                        color: thoiGian == 'sang' 
                            ? Colors.amber[700] 
                            : Colors.indigo[700],
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kinh.ten,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kinh.ghiChu,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Nội dung:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kinh.noiDung.length > 200 
                      ? '${kinh.noiDung.substring(0, 200)}...'
                      : kinh.noiDung,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF34495E),
                  ),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Nhấn để đọc chi tiết',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B4513),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _navigateToDetail(KinhPhat kinh) async {
    // Hiển thị interstitial ad trước khi chuyển màn hình (nếu không phải premium và là Guest)
    if (!_isPremiumUser && _authService.isGuest()) {
      await _adService.loadInterstitialAd();
      await _adService.showInterstitialAd();
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KinhDetailScreen(kinh: kinh),
      ),
    );
  }
}

