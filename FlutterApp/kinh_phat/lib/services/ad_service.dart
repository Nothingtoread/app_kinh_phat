import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static const String _premiumKey = 'is_premium_user';
  
  // Test Ad Unit IDs - Thay thế bằng Ad Unit IDs thật khi publish
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  
  bool _isPremiumUser = false;
  bool _isInitialized = false;

  // Khởi tạo Google Mobile Ads
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      await _loadPremiumStatus();
      _isInitialized = true;
    } catch (e) {
      print('Lỗi khởi tạo Google Mobile Ads: $e');
    }
  }

  // Kiểm tra trạng thái premium
  Future<bool> isPremiumUser() async {
    if (!_isInitialized) await initialize();
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
  }

  // Tạo Banner Ad
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  // Load Interstitial Ad
  Future<void> loadInterstitialAd() async {
    if (_isPremiumUser) return;

    try {
      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            print('Interstitial ad loaded');
          },
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');
          },
        ),
      );
    } catch (e) {
      print('Lỗi load interstitial ad: $e');
    }
  }

  // Hiển thị Interstitial Ad
  Future<void> showInterstitialAd() async {
    if (_isPremiumUser || _interstitialAd == null) return;

    try {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('Interstitial ad showed');
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          // Load ad mới cho lần tiếp theo
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          print('Interstitial ad failed to show: $error');
        },
      );

      await _interstitialAd!.show();
    } catch (e) {
      print('Lỗi hiển thị interstitial ad: $e');
    }
  }

  // Load Rewarded Ad
  Future<void> loadRewardedAd() async {
    if (_isPremiumUser) return;

    try {
      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            print('Rewarded ad loaded');
          },
          onAdFailedToLoad: (error) {
            print('Rewarded ad failed to load: $error');
          },
        ),
      );
    } catch (e) {
      print('Lỗi load rewarded ad: $e');
    }
  }

  // Hiển thị Rewarded Ad
  Future<bool> showRewardedAd() async {
    if (_isPremiumUser || _rewardedAd == null) return false;

    try {
      bool rewardEarned = false;
      
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('Rewarded ad showed');
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          // Load ad mới cho lần tiếp theo
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          print('Rewarded ad failed to show: $error');
        },
      );

      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          rewardEarned = true;
          print('User earned reward: ${reward.amount} ${reward.type}');
        },
      );

      return rewardEarned;
    } catch (e) {
      print('Lỗi hiển thị rewarded ad: $e');
      return false;
    }
  }

  // Dispose tất cả ads
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}

