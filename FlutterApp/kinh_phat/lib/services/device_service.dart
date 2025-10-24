import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  String? _deviceId;
  String? _deviceFingerprint;

  // Lấy Device ID duy nhất
  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // Sử dụng Android ID hoặc tạo fingerprint
        _deviceId = androidInfo.id;
        if (_deviceId == null || _deviceId!.isEmpty) {
          _deviceId = await _generateAndroidFingerprint(androidInfo);
        }
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        // Sử dụng identifierForVendor
        _deviceId = iosInfo.identifierForVendor;
        if (_deviceId == null || _deviceId!.isEmpty) {
          _deviceId = await _generateIOSFingerprint(iosInfo);
        }
      } else {
        // Fallback cho các platform khác
        _deviceId = await _generateFallbackFingerprint();
      }

      return _deviceId!;
    } catch (e) {
      print('Lỗi khi lấy Device ID: $e');
      return await _generateFallbackFingerprint();
    }
  }

  // Tạo fingerprint cho Android
  Future<String> _generateAndroidFingerprint(AndroidDeviceInfo androidInfo) async {
    final fingerprintData = {
      'model': androidInfo.model,
      'brand': androidInfo.brand,
      'device': androidInfo.device,
      'product': androidInfo.product,
      'hardware': androidInfo.hardware,
      'androidId': androidInfo.id,
    };
    
    return _generateHash(fingerprintData);
  }

  // Tạo fingerprint cho iOS
  Future<String> _generateIOSFingerprint(IosDeviceInfo iosInfo) async {
    final fingerprintData = {
      'model': iosInfo.model,
      'name': iosInfo.name,
      'systemName': iosInfo.systemName,
      'systemVersion': iosInfo.systemVersion,
      'localizedModel': iosInfo.localizedModel,
    };
    
    return _generateHash(fingerprintData);
  }

  // Fallback fingerprint
  Future<String> _generateFallbackFingerprint() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (timestamp.hashCode % 1000000).toString();
    return 'fallback_${timestamp}_$random';
  }

  // Tạo hash từ data
  String _generateHash(Map<String, dynamic> data) {
    final jsonString = json.encode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Lấy device fingerprint để gửi lên server
  Future<String> getDeviceFingerprint() async {
    if (_deviceFingerprint != null) return _deviceFingerprint!;

    try {
      final deviceInfo = DeviceInfoPlugin();
      Map<String, dynamic> fingerprintData = {};

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        fingerprintData = {
          'platform': 'android',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'device': androidInfo.device,
          'product': androidInfo.product,
          'hardware': androidInfo.hardware,
          'androidId': androidInfo.id,
          'version': androidInfo.version.release,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        fingerprintData = {
          'platform': 'ios',
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'localizedModel': iosInfo.localizedModel,
          'identifierForVendor': iosInfo.identifierForVendor,
        };
      }

      _deviceFingerprint = _generateHash(fingerprintData);
      return _deviceFingerprint!;
    } catch (e) {
      print('Lỗi khi tạo device fingerprint: $e');
      return await _generateFallbackFingerprint();
    }
  }
}

