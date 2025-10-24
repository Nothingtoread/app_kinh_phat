import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/main_screen.dart';
import 'services/ad_service.dart';
import 'services/auth_service.dart';
import 'utils/debug_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo debug logging
  DebugLogger.enable();
  DebugLogger.setMinLevel(LogLevel.debug);
  DebugLogger.systemInfo();
  DebugLogger.info('App starting...');
  
  try {
    // Khởi tạo Google Mobile Ads
    DebugLogger.info('Initializing Google Mobile Ads...');
    await MobileAds.instance.initialize();
    DebugLogger.info('Google Mobile Ads initialized successfully');
    
    // Khởi tạo AdService
    DebugLogger.info('Initializing AdService...');
    await AdService().initialize();
    DebugLogger.info('AdService initialized successfully');
    
    // Khởi tạo AuthService
    DebugLogger.info('Initializing AuthService...');
    await AuthService().initialize();
    DebugLogger.info('AuthService initialized successfully');
    
    DebugLogger.info('All services initialized, starting app...');
    runApp(const MainApp());
  } catch (e, stackTrace) {
    DebugLogger.critical('Failed to initialize app', error: e, stackTrace: stackTrace);
    rethrow;
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinh Phật Hàng Ngày',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: const Color(0xFF8B4513),
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B4513),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
