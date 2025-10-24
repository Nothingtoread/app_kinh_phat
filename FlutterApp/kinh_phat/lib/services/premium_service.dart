import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:io';
import 'device_service.dart';
import 'api_service.dart';

class PremiumService {
  static final PremiumService _instance = PremiumService._internal();
  factory PremiumService() => _instance;
  PremiumService._internal();

  static const String _premiumKey = 'is_premium_user';
  static const String _deviceIdKey = 'device_id';
  static const String _receiptKey = 'purchase_receipt';
  static const String _purchaseDateKey = 'purchase_date';
  
  // Product ID cho premium (cần cấu hình trong Google Play Console)
  static const String _premiumProductId = 'premium_monthly'; // Thay đổi theo product ID thật
  
  final DeviceService _deviceService = DeviceService();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  
  bool _isPremiumUser = false;
  String? _deviceId;
  String? _receipt;

  // Khởi tạo service
  Future<void> initialize() async {
    await _loadPremiumStatus();
    await _initializeInAppPurchase();
  }

  // Khởi tạo In-App Purchase
  Future<void> _initializeInAppPurchase() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        print('In-App Purchase không khả dụng');
        return;
      }

      // Listen to purchase updates
      _inAppPurchase.purchaseStream.listen(_handlePurchaseUpdate);
    } catch (e) {
      print('Lỗi khởi tạo In-App Purchase: $e');
    }
  }

  // Xử lý purchase updates
  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        _handleSuccessfulPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print('Lỗi mua hàng: ${purchaseDetails.error}');
      }
    }
  }

  // Xử lý mua hàng thành công
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    try {
      // Lưu receipt
      await _saveReceipt(purchaseDetails.verificationData.localVerificationData);
      
      // Validate receipt với server
      final isValid = await _validateReceiptWithServer(
        purchaseDetails.verificationData.localVerificationData,
        purchaseDetails.verificationData.serverVerificationData,
      );

      if (isValid) {
        // Set premium status
        await setPremiumUser(true);
        
        // Complete purchase
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    } catch (e) {
      print('Lỗi xử lý mua hàng: $e');
    }
  }

  // Validate receipt với server
  Future<bool> _validateReceiptWithServer(String localReceipt, String serverReceipt) async {
    try {
      final deviceId = await _deviceService.getDeviceId();
      final deviceFingerprint = await _deviceService.getDeviceFingerprint();
      
      // Gửi receipt lên server để validate
      final response = await ApiService.validatePurchase({
        'deviceId': deviceId,
        'deviceFingerprint': deviceFingerprint,
        'localReceipt': localReceipt,
        'serverReceipt': serverReceipt,
        'productId': _premiumProductId,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      });

      return response['isValid'] == true;
    } catch (e) {
      print('Lỗi validate receipt: $e');
      return false;
    }
  }

  // Lưu receipt
  Future<void> _saveReceipt(String receipt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_receiptKey, receipt);
    await prefs.setString(_purchaseDateKey, DateTime.now().toIso8601String());
    _receipt = receipt;
  }

  // Kiểm tra trạng thái premium
  Future<bool> isPremiumUser() async {
    if (!_isPremiumUser) {
      await _loadPremiumStatus();
    }
    return _isPremiumUser;
  }

  // Đặt trạng thái premium
  Future<void> setPremiumUser(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, isPremium);
    _isPremiumUser = isPremium;
  }

  // Load trạng thái premium từ SharedPreferences
  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremiumUser = prefs.getBool(_premiumKey) ?? false;
    _deviceId = prefs.getString(_deviceIdKey);
    _receipt = prefs.getString(_receiptKey);

    // Nếu chưa có device ID, tạo mới
    if (_deviceId == null) {
      _deviceId = await _deviceService.getDeviceId();
      await prefs.setString(_deviceIdKey, _deviceId!);
    }

    // Kiểm tra premium status với server
    await _checkPremiumStatusWithServer();
  }

  // Kiểm tra premium status với server
  Future<void> _checkPremiumStatusWithServer() async {
    try {
      if (_deviceId == null) return;

      final response = await ApiService.checkPremiumStatus(_deviceId!);
      
      if (response['isPremium'] == true) {
        await setPremiumUser(true);
      } else if (response['isPremium'] == false && _isPremiumUser) {
        // Server nói không premium nhưng local có premium
        // Có thể receipt đã hết hạn hoặc bị revoke
        await setPremiumUser(false);
      }
    } catch (e) {
      print('Lỗi kiểm tra premium status với server: $e');
      // Giữ nguyên trạng thái local nếu server lỗi
    }
  }

  // Mua premium
  Future<bool> purchasePremium() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        print('In-App Purchase không khả dụng');
        return false;
      }

      // Lấy product details
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({_premiumProductId});
      
      if (response.notFoundIDs.isNotEmpty) {
        print('Không tìm thấy product: ${response.notFoundIDs}');
        return false;
      }

      final ProductDetails productDetails = response.productDetails.first;
      
      // Tạo purchase param
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      
      // Thực hiện mua hàng
      final bool success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      
      return success;
    } catch (e) {
      print('Lỗi mua premium: $e');
      return false;
    }
  }

  // Restore purchases (cho iOS)
  Future<bool> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      return true;
    } catch (e) {
      print('Lỗi restore purchases: $e');
      return false;
    }
  }

  // Lấy device ID
  Future<String> getDeviceId() async {
    if (_deviceId == null) {
      _deviceId = await _deviceService.getDeviceId();
    }
    return _deviceId!;
  }

  // Lấy receipt
  String? getReceipt() => _receipt;

  // Kiểm tra xem có thể restore purchases không
  Future<bool> canRestorePurchases() async {
    return await _inAppPurchase.isAvailable();
  }
}
