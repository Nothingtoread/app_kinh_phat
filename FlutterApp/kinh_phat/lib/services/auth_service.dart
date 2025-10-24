import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/debug_logger.dart';

enum UserRole {
  guest,
  admin,
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _isDeveloperModeKey = 'is_developer_mode';
  static const String _isAdminLoggedInKey = 'is_admin_logged_in';
  static const String _adminUsernameKey = 'admin_username';
  static const String _adminRoleKey = 'admin_role';
  
  // API base URL
  static const String _apiBaseUrl = 'http://192.168.1.11:5275/api';
  
  UserRole _currentRole = UserRole.guest;
  bool _isDeveloperMode = false;
  bool _isAdminLoggedIn = false;
  String _currentAdminUsername = '';
  String _currentAdminRole = '';

  // Khởi tạo service
  Future<void> initialize() async {
    DebugLogger.authEvent('AuthService initialization started');
    await _loadAuthState();
    DebugLogger.authEvent('AuthService initialization completed', data: {
      'isDeveloperMode': _isDeveloperMode,
      'isAdminLoggedIn': _isAdminLoggedIn,
      'currentRole': _currentRole.toString(),
    });
  }

  // Load trạng thái authentication từ SharedPreferences
  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isDeveloperMode = prefs.getBool(_isDeveloperModeKey) ?? false;
    _isAdminLoggedIn = prefs.getBool(_isAdminLoggedInKey) ?? false;
    _currentAdminUsername = prefs.getString(_adminUsernameKey) ?? '';
    _currentAdminRole = prefs.getString(_adminRoleKey) ?? '';
    
    // Xác định role hiện tại
    if (_isDeveloperMode && _isAdminLoggedIn) {
      _currentRole = UserRole.admin;
    } else {
      _currentRole = UserRole.guest;
    }
  }

  // Lưu trạng thái authentication
  Future<void> _saveAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDeveloperModeKey, _isDeveloperMode);
    await prefs.setBool(_isAdminLoggedInKey, _isAdminLoggedIn);
    await prefs.setString(_adminUsernameKey, _currentAdminUsername);
    await prefs.setString(_adminRoleKey, _currentAdminRole);
  }

  // Bật/tắt Developer Mode
  Future<void> toggleDeveloperMode(bool enabled) async {
    _isDeveloperMode = enabled;
    
    // Nếu tắt developer mode, logout admin
    if (!enabled) {
      _isAdminLoggedIn = false;
      _currentRole = UserRole.guest;
    }
    
    await _saveAuthState();
  }

  // Kiểm tra Developer Mode
  bool isDeveloperModeEnabled() => _isDeveloperMode;

  // Đăng nhập Admin qua API
  Future<bool> loginAdmin(String username, String password) async {
    if (!_isDeveloperMode) {
      DebugLogger.authError('loginAdmin', Exception('Developer Mode chưa được bật'));
      throw Exception('Developer Mode chưa được bật');
    }

    try {
      DebugLogger.authEvent('Admin login attempt', data: {
        'username': username,
        'developerMode': _isDeveloperMode,
      });

      final response = await http.post(
        Uri.parse('$_apiBaseUrl/Admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      DebugLogger.networkResponse('POST', '$_apiBaseUrl/Admin/login', response.statusCode,
        responseBody: response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _isAdminLoggedIn = true;
          _currentRole = UserRole.admin;
          _currentAdminUsername = data['admin']['username'];
          _currentAdminRole = data['admin']['role'];
          await _saveAuthState();
          
          DebugLogger.authEvent('Admin login successful', data: {
            'username': _currentAdminUsername,
            'role': _currentAdminRole,
          });
          
          return true;
        }
      }
      
      DebugLogger.authEvent('Admin login failed', data: {
        'username': username,
        'statusCode': response.statusCode,
        'response': response.body,
      });
      
      return false;
    } catch (e, stackTrace) {
      DebugLogger.authError('loginAdmin', e, stackTrace: stackTrace);
      return false;
    }
  }

  // Đăng xuất Admin
  Future<void> logoutAdmin() async {
    _isAdminLoggedIn = false;
    _currentRole = UserRole.guest;
    _currentAdminUsername = '';
    _currentAdminRole = '';
    await _saveAuthState();
  }

  // Lấy role hiện tại
  UserRole getCurrentRole() => _currentRole;

  // Kiểm tra có phải Admin không
  bool isAdmin() => _currentRole == UserRole.admin;

  // Kiểm tra có phải Guest không
  bool isGuest() => _currentRole == UserRole.guest;

  // Kiểm tra Admin đã đăng nhập chưa
  bool isAdminLoggedIn() => _isAdminLoggedIn;

  // Lấy thông tin user hiện tại
  Map<String, dynamic> getCurrentUserInfo() {
    if (_currentRole == UserRole.admin) {
      return {
        'role': 'admin',
        'username': _currentAdminUsername,
        'adminRole': _currentAdminRole,
        'isDeveloperMode': _isDeveloperMode,
        'isLoggedIn': _isAdminLoggedIn,
      };
    } else {
      return {
        'role': 'guest',
        'isDeveloperMode': _isDeveloperMode,
        'isLoggedIn': false,
      };
    }
  }

  // Reset tất cả authentication state
  Future<void> resetAuthState() async {
    _isDeveloperMode = false;
    _isAdminLoggedIn = false;
    _currentRole = UserRole.guest;
    _currentAdminUsername = '';
    _currentAdminRole = '';
    await _saveAuthState();
  }

  // Hash password (để bảo mật hơn trong tương lai)
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate password strength (cho tương lai)
  bool _isPasswordStrong(String password) {
    return password.length >= 8 && 
           password.contains(RegExp(r'[A-Z]')) && 
           password.contains(RegExp(r'[a-z]')) && 
           password.contains(RegExp(r'[0-9]'));
  }

  // Lấy thông tin debug
  Map<String, dynamic> getDebugInfo() {
    return {
      'currentRole': _currentRole.toString(),
      'isDeveloperMode': _isDeveloperMode,
      'isAdminLoggedIn': _isAdminLoggedIn,
      'currentAdminUsername': _currentAdminUsername,
      'currentAdminRole': _currentAdminRole,
      'apiBaseUrl': _apiBaseUrl,
    };
  }

  // Lấy danh sách test accounts từ API
  Future<List<Map<String, dynamic>>> getTestAccounts() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/Admin/test-accounts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['accounts']);
      }
      return [];
    } catch (e) {
      print('Lỗi lấy test accounts: $e');
      return [];
    }
  }
}

