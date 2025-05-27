import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // ✅ Replace with your actual AdMob unit IDs
  static const String bannerAdUnitId = 'ca-app-pub-5462334042904965/2784557347';
  static const String interstitialAdUnitId =
      'ca-app-pub-5462334042904965/6532230664';
  static const String rewardedAdUnitId =
      'ca-app-pub-5462334042904965/4939338587';

  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadRewardedAd();
  }

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('✅ Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial failed: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitialAd(); // Preload next
    } else {
      debugPrint('⚠️ Interstitial ad not ready');
    }
  }

  static void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          debugPrint('✅ Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded ad failed: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  static void showRewardedAd({
    required VoidCallback onRewarded,
    VoidCallback? onAdUnavailable,
  }) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('ℹ️ Rewarded ad dismissed');
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('❌ Failed to show rewarded ad: $error');
          loadRewardedAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('🎉 User earned reward: \${reward.amount}');
          onRewarded();
        },
      );

      _rewardedAd = null;
    } else {
      debugPrint('⚠️ No rewarded ad available');
      if (onAdUnavailable != null) {
        onAdUnavailable();
      }
    }
  }

  static BannerAd createBannerAd({required BannerAdListener listener}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    );
  }
}
