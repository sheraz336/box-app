import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false; // Track if ad is loaded

  void loadAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3512120495633654/5731406074', // Replace with your actual AdMob unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true; // Set flag to true when ad is ready
          print("Ad Loaded Successfully");
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _isAdLoaded = false;
          print('Ad failed to load: $error');
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
          if (onAdDismissed != null) onAdDismissed(); // Navigate after ad
          loadAd(); // Load next ad
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _interstitialAd = null;
          _isAdLoaded = false;
          print("Ad failed to show: $error");
          if (onAdDismissed != null) onAdDismissed(); // Navigate if ad fails
          loadAd();
        },
      );

      _interstitialAd!.show();
    } else {
      print("Ad not ready yet, navigating immediately");
      if (onAdDismissed != null) onAdDismissed(); // Navigate if ad is not ready
      loadAd(); // Attempt to load a new ad
    }
  }
}
