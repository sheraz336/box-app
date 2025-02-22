import 'dart:async';
import 'dart:ui';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  Timer? _adTimer;
  int _boxAddCount = 0;
  int _locationAddCount = 0;

  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoaded = false;

  AdManager() {
    loadAd();
    _startAdTimer(); // Start the 3-minute ad timer
  }

  void loadAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3512120495633654/5731406074',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _isAdLoaded = false;
        },
      ),
    );
  }

  void showAd({VoidCallback? onAdDismissed}) {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _interstitialAd = null;
          _isAdLoaded = false;
          loadAd(); // Load the next ad
          if (onAdDismissed != null) onAdDismissed();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _interstitialAd = null;
          _isAdLoaded = false;
          loadAd();
          if (onAdDismissed != null) onAdDismissed();
        },
      );

      _interstitialAd!.show();
    } else {
      loadAd();
      if (onAdDismissed != null) onAdDismissed();
    }
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3512120495633654/9283600285', // Replace with actual Rewarded Ad ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          _isRewardedAdLoaded = false;
          print("Rewarded Ad failed to load: $error");
        },
      ),
    );
  }

  void showRewardedAd(VoidCallback onRewardEarned) {
    if (_isRewardedAdLoaded && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoaded = false;
          loadRewardedAd(); // Reload for next time
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoaded = false;
          loadRewardedAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onRewardEarned();
        },
      );
    } else {
      print("Rewarded Ad not ready.");
      onRewardEarned(); // Proceed without the ad
    }
  }

  // Show an ad every 3 minutes
  void _startAdTimer() {
    _adTimer?.cancel();
    _adTimer = Timer.periodic(Duration(minutes: 3), (timer) {
      showAd();
    });
  }

  void incrementBoxCount(VoidCallback onActionCompleted) {
    _boxAddCount++;
    if (_boxAddCount >= 3) {
      _boxAddCount = 0; // Reset counter
      showAd(onAdDismissed: onActionCompleted);
    } else {
      onActionCompleted(); // Proceed normally if ad is not triggered
    }
  }

  void incrementLocationCount(VoidCallback onActionCompleted) {
    _locationAddCount++;
    if (_locationAddCount >= 2) {
      _locationAddCount = 0; // Reset counter
      showAd(onAdDismissed: onActionCompleted);
    } else {
      onActionCompleted(); // Proceed normally if ad is not triggered
    }
  }

  void dispose() {
    _adTimer?.cancel();
  }
}


